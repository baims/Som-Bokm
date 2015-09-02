//
//  CategoriesVC.swift
//  QamosSomBokm
//
//  Created by Omar on 6/26/15.
//  Copyright (c) 2015 Baims. All rights reserved.
//

import UIKit

class CategoriesVC: UIViewController,  UICollectionViewDelegate,UICollectionViewDataSource {

    var categoryDict =  NSDictionary()
    var selectedIndexPath : NSIndexPath!
    var categoryArray = NSArray()
    var passDictionary = NSDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryArray = categoryDict.allKeys
  
      //  println(self.categoryDict.description)
    }
    
    override func viewWillLayoutSubviews() {
        let bgImageView = UIImageView(image: UIImage(named: "parkLandscapeBG"))
        bgImageView.contentMode = .ScaleAspectFit
        bgImageView.frame = self.view.frame
        self.view.addSubview(bgImageView)
        self.view.sendSubviewToBack(bgImageView)
    }

    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cellCat", forIndexPath: indexPath) as! CollectionViewCell
        let textOfCategory = categoryArray[indexPath.row] as? String
        if let cellIcon = UIImage(named: textOfCategory! + "ButtonCollection"){
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
        
        if let itemName = categoryArray[selectedIndexPath.row] as? String{
            //println(itemName)
            
            //passing the pressed button key to the dictionary that will be sent to the next VC
            var dictionaryOfSelectedItem : NSDictionary = categoryDict.objectForKey(itemName) as! NSDictionary
            
            vc.elementDictionary = dictionaryOfSelectedItem
            vc.dictionaryName =  categoryArray.objectAtIndex(selectedIndexPath.row) as! String

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
