//
//  BackgroundsViewController.swift
//  SomBokmApplication
//
//  Created by Bader Alrshaid on 10/9/15.
//  Copyright © 2015 Baims. All rights reserved.
//

import UIKit

class BackgroundsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    var backgroundNames = [String]()
    var storyMakingViewController : StoryMakingViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundNames = ["islandBGST", "beachBGST","parkBGST","sea1BGST","sea2BGST" /*, "storyReading01", "storyReading02", "storyReading03", "storyReading04", "storyReading05", "storyReading06", "storyReading07", "storyReading08", "storyReading09"*/]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func hideButtonTapped(sender: UIButton) {
        self.storyMakingViewController.hideBackgroundsContainerView()
    }
}


extension BackgroundsViewController
{
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.backgroundNames.count;
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! BackgroundsCollectionViewCell
        
        cell.imageView.image = UIImage(named: self.backgroundNames[indexPath.item])
        cell.imageView.image!.accessibilityIdentifier = self.backgroundNames[indexPath.item]
        
        
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        cell.selectedBackgroundView = selectedView
        cell.bringSubviewToFront(cell.selectedBackgroundView!)
        
        
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        return true
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! BackgroundsCollectionViewCell
        
        
        self.storyMakingViewController.hideBackgroundsContainerView(cell.imageView.image!.accessibilityIdentifier!)
        
        collectionView.deselectItemAtIndexPath(indexPath, animated: false)
    }
}