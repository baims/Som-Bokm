//
//  CategoriesVC.swift
//  QamosSomBokm
//
//  Created by Omar on 6/26/15.
//  Copyright (c) 2015 Baims. All rights reserved.
//

import UIKit

class CategoriesVC: UIViewController,  UICollectionViewDelegate,UICollectionViewDataSource {
    
    var selectedIndexPath : NSIndexPath!
    var categoryArray  : [ElementManager.Element]?
    var masterMode     : Bool? = false
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var deleteMasteredWordsButton: UIButton!
    
    @IBOutlet var imageOfElement: UIImageView!
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        if masterMode == true {
            categoryArray = ElementManager.getMasteredWords()
        }
        else{
            deleteMasteredWordsButton.hidden = true
        }
    }
    
    override func viewWillLayoutSubviews() {
        let bgImageView = UIImageView(image: UIImage(named: "parkLandscapeBG"))
        bgImageView.contentMode = .ScaleAspectFit
        bgImageView.frame = self.view.frame
        self.view.addSubview(bgImageView)
        self.view.sendSubviewToBack(bgImageView)
    }
    
//    override func viewDidLayoutSubviews() {
//        self.collectionView.setNeedsLayout()
//        self.collectionView.layoutIfNeeded()
//    }
 
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryArray!.count
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cellCat", forIndexPath: indexPath) as! CollectionViewCell
        
        let elementInCollection = categoryArray![indexPath.row]
//        _ = elementInCollection.name!
        
        if let cellIcon = UIImage(named: elementInCollection.thumbImageName!){
            cell.cellBG.image = cellIcon
            cell.elementImage.hidden = true;
            cell.label.hidden = true
        }
            
            
        else if (elementInCollection.thumbImageExists == false){
            
            
            
            //make an image that contains only name :
            cell.elementImage.hidden = false;
            cell.label.hidden = false
            cell.cellBG.image  = UIImage(named: "defaultCollectionButton")
            cell.elementImage.image = elementInCollection.image
            
            if elementInCollection.arName == "" || elementInCollection.arName == nil{
                cell.label.text = elementInCollection.name

            }
            else{
            cell.label.text = elementInCollection.arName
            }
            
        }
        
        
        cell.bringSubviewToFront(cell.label)
        cell.bringSubviewToFront(cell.elementImage)

        cell.layoutIfNeeded()
        
        return cell
        
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
       
        if categoryArray![selectedIndexPath.row].videoExist != true
        {
            return false
        }
        return true
    }
    
    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        selectedIndexPath = indexPath


        if self.shouldPerformSegueWithIdentifier("toElement", sender: self)
        {
            // check if it has content 
      
        }
        return true
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let vc : ElementVC = segue.destinationViewController as! ElementVC
        
        if let _ = categoryArray![selectedIndexPath.row].categoryName{
            //println(itemName)
            
            //passing the pressed button key to the dictionary that will be sent to the next VC
            let itemToTransfer = categoryArray![selectedIndexPath.row]
            itemToTransfer.printDescreption()
            vc.element    = itemToTransfer
            
            
            // println(dictionaryOfSelectedItem)
            
        }
        
        
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    
    
    
    @IBAction func backButtonTapped(sender: UIButton)
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
}
