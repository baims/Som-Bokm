//
//  SavedStoriesCollectionViewController.swift
//  StoryTelling
//
//  Created by Bader Alrshaid on 7/31/15.
//  Copyright (c) 2015 Bader Alrshaid. All rights reserved.
//

import UIKit
import RealmSwift


class SavedStoriesCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var typeOfRealmString : String!
    var adminMode         : Bool!
    
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var addToReadStoriesButton: UIButton!
    @IBOutlet weak var addNewStoryButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    var numberOfStories : Int!
    var stories : Results<StoryTelling>!
    
    var selectedStoryTelling : StoryTelling!
    
    let reuseIdentifier = "Cell"
    var isEditingCollectionView = false
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.allowsMultipleSelection = true
        //self.clearsSelectionOnViewWillAppear = true
    }
    
    override func viewWillAppear(animated: Bool) {
        if self.collectionView.indexPathsForSelectedItems().count > 0
        {
            self.collectionView.deselectItemAtIndexPath(self.collectionView?.indexPathsForSelectedItems().first as? NSIndexPath, animated: true)
        }
        
        // Loading the Collection View and showing the saved stories
        let predicate = NSPredicate(format: "%K == true", self.typeOfRealmString.lowercaseString);
        
        let realm = Realm()
        self.stories = realm.objects(StoryTelling).filter(predicate).sorted("date", ascending: false)
        self.numberOfStories = self.stories.count
        
        self.collectionView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "ShowSavedScene"
        {
            let vc = segue.destinationViewController as! StoryMakingViewController
            vc.orderOfSceneInStory = 1 // because it's the first one
            vc.dateOfStory         = self.selectedStoryTelling.date
            vc.typeOfRealmString   = self.typeOfRealmString
            vc.adminMode           = self.adminMode
        }
        
        else if segue.identifier == "StoryTelling"
        {
            let vc = segue.destinationViewController as! StoryMakingViewController
            vc.orderOfSceneInStory = 1 // because it's the first one
            vc.dateOfStory         = NSDate()
            vc.typeOfRealmString   = self.typeOfRealmString
            vc.adminMode           = self.adminMode
        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool
    {
        if identifier == "ShowSavedScene" && self.isEditingCollectionView == true
        {
            return false
        }
        
        return true
    }
}


// MARK: Storyboard buttons actions
extension SavedStoriesCollectionViewController
{
    @IBAction func editButtonTapped(sender: UIButton) {
        if !self.isEditingCollectionView {
            self.isEditingCollectionView = true
            
            sender.setTitle("تم", forState: UIControlState.Normal)
            
            self.deleteButton.enabled           = true
            self.addToReadStoriesButton.enabled = true
            
            self.collectionView!.reloadData()
            
        }
        else if self.isEditingCollectionView {
            self.isEditingCollectionView = false
            
            sender.setTitle("تعديل", forState: UIControlState.Normal)
            
            self.deleteButton.enabled           = false
            self.addToReadStoriesButton.enabled = false
            
            self.collectionView!.reloadData()
        }
    }
    
    
    @IBAction func deleteAllStoriesButtonTapped(sender: UIBarButtonItem)
    {
        let alertController = UIAlertController(title: "تأكيد", message: "هل انت متأكد من مسح جميع القصص المحفوظة؟", preferredStyle: UIAlertControllerStyle.Alert)
        
        let cancelAction = UIAlertAction(title: "الغاء", style: .Cancel, handler: nil)
        
        let deleteAction = UIAlertAction(title: "مسح جميع القصص", style: UIAlertActionStyle.Destructive)
            { (action) -> Void in
                let realm = Realm()
                
                realm.write {
                    realm.delete(realm.objects(StoryTelling))
                }
                
                self.stories = realm.objects(StoryTelling).sorted("date", ascending: false)
                self.numberOfStories = self.stories.count
                
                self.collectionView?.reloadData()
        }
        
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func deleteButtonTapped(sender: UIBarButtonItem)
    {
        let alertController = UIAlertController(title: "تأكيد", message: "هل انت متأكد من مسح القصص التي اخترتها؟", preferredStyle: UIAlertControllerStyle.Alert)
        
        let cancelAction = UIAlertAction(title: "الغاء", style: .Cancel, handler: nil)
        
        let deleteAction = UIAlertAction(title: "مسح القصص المختارة", style: UIAlertActionStyle.Destructive)
            { (action) -> Void in
                
                var stories = [StoryTelling]()
                
                for indexPath in self.collectionView!.indexPathsForSelectedItems()
                {
                    let cell = self.collectionView!.cellForItemAtIndexPath(indexPath as! NSIndexPath) as!SavedStoryCollectionViewCell
                    
                    stories.append(cell.storyTelling)
                }
                
                let realm = Realm()
                
                realm.write {
                    realm.delete(stories)
                }
                
                
                self.stories = realm.objects(StoryTelling).sorted("date", ascending: false)
                self.numberOfStories = self.stories.count
                
                self.collectionView?.reloadData()
        }
        
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func backButtonTapped(sender: UIButton)
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}


// MARK: UICollectionViewDataSource & UICollectionViewDelegate
extension SavedStoriesCollectionViewController
{
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.numberOfStories
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! SavedStoryCollectionViewCell
        
        cell.dateLabel.text = "\(self.stories[indexPath.item].date)"
        cell.storyTelling   = self.stories[indexPath.item]
        
        
        let backgroundView = UIView(frame: cell.frame)
        backgroundView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        cell.selectedBackgroundView = backgroundView
        
        return cell
    }
    

    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! SavedStoryCollectionViewCell
        
        if self.isEditingCollectionView == false
        {
            self.selectedStoryTelling = cell.storyTelling // getting the story to pass it in prepareForSegue:
        }
        
        return true
    }
    
    
    func collectionView(collectionView: UICollectionView, shouldDeselectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
}
