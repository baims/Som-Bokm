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
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var deleteAllButton: UIButton!
    
    
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
        if let indexPaths = self.collectionView.indexPathsForSelectedItems() where indexPaths.count > 0
        {
            self.collectionView.deselectItemAtIndexPath(indexPaths.first!, animated: true)
        }
        
        // Loading the Collection View and showing the saved stories
        let predicate = NSPredicate(format: "%K == true", self.typeOfRealmString.lowercaseString);
        
        let realm = try! Realm()
        self.stories = realm.objects(StoryTelling).filter(predicate).sorted("date", ascending: false)
        self.numberOfStories = self.stories.count
        
        self.collectionView.reloadData()
    }
    
    override func viewDidLayoutSubviews()
    {
        self.hideUnnecessarySubviews()
    }
    
    func hideUnnecessarySubviews()
    {
        if self.adminMode == false
        {
            self.addNewStoryButton.hidden      = true
            self.editButton.hidden             = true
            self.addToReadStoriesButton.hidden = true
            self.deleteButton.hidden           = true
            self.deleteAllButton.hidden        = true
        }
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
    @IBAction func editButtonTapped(sender: UIButton)
    {
        let normalImage = sender.imageForState(.Normal)
        sender.setImage(sender.imageForState(.Highlighted), forState: .Normal)
        sender.setImage(normalImage, forState: .Highlighted)
        
        if !self.isEditingCollectionView
        {
            self.isEditingCollectionView = true
            
            self.deleteButton.enabled           = true
            self.addToReadStoriesButton.enabled = true
            
            self.collectionView!.reloadData()
            
        }
        else
        {
            self.isEditingCollectionView = false
            
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
                let realm = try! Realm()
                
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
                
                for indexPath in self.collectionView!.indexPathsForSelectedItems()!
                {
                    let cell = self.collectionView!.cellForItemAtIndexPath(indexPath) as! SavedStoryCollectionViewCell
                    
                    stories.append(cell.storyTelling)
                }
                
                let realm = try! Realm()
                
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
        
        let dateFormat = NSDateFormatter()
        dateFormat.dateFormat = "hh:mm  dd/MM/yyyy"
        
        cell.dateLabel.text = "\(dateFormat.stringFromDate(self.stories[indexPath.item].date))"
        cell.storyTelling   = self.stories[indexPath.item]
        
        cell.bgImageView.image = UIImage(named: (self.stories[indexPath.item].scenes.first?.backgroundImageName)!)
        
        
        let backgroundView = UIView(frame: cell.frame)
        let tickImageView  = UIImageView(image: UIImage(named: "tick"))
        tickImageView.frame = CGRectMake(8, 8, 28, 28)
        
        if self.isEditingCollectionView == true
        {
            backgroundView.addSubview(tickImageView)
        }
        
        cell.selectedBackgroundView = backgroundView
        cell.bringSubviewToFront(cell.selectedBackgroundView!)
        
        cell.layoutIfNeeded()
        
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
