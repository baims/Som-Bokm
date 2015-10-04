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
    
    override func viewDidAppear(animated: Bool) {
        collectionView.reloadData()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryArray!.count
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cellCat", forIndexPath: indexPath) as! CollectionViewCell
        
        let elementInCollection = categoryArray![indexPath.row]
        let textOfCategory = elementInCollection.name!
        
        if let cellIcon = UIImage(named: elementInCollection.thumbImageName!){
            cell.cellBG.image = cellIcon
        }
            
            
        else{
            //make an image that contains only name :
            cell.label.hidden = false
            cell.label.text = textOfCategory
            cell.cellBG.image  = UIImage(named: "defaultCollectionButton")
            
        }
        
        return cell
        
    }
    
    
    
    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        selectedIndexPath = indexPath
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
