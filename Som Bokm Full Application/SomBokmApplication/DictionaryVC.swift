//  ViewController.swift
//  QamosSomBokm
//  Created by OMAR on 6/20/15.
//  Copyright (c) 2015 Baims. All rights reserved.
//

import UIKit


class DictionaryVC: UIViewController , UICollectionViewDelegate , UICollectionViewDataSource{
    
    @IBOutlet weak var collectionView : UICollectionView!
    @IBOutlet weak var segmentControl : UISegmentedControl!
    @IBOutlet weak var searchView     : UIView!
    @IBOutlet weak var searchButton   : UIButton!
    var elementNeeds : ElementManager.Element?
    
    var selectedIndexPath : NSIndexPath!    //index for collection view to know which item was selected in segue
    /**
    Here dictionary wont have access to the mastered words synced from QuizVC
    */
    var base = ElementManager.prepareItemsOfDataBase()
    var rootsArray : [ElementManager.Root]?
    
    // ------- V I E W  D I D  L O A D  -------------
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        rootsArray = base.rootArray //
        
        segmentControl.removeAllSegments()
        
        var counter=0
        for root in rootsArray!
        {
            segmentControl.insertSegmentWithTitle(root.rootName, atIndex: counter, animated: false)
            counter++
        }
        
        base.printDescreption()
        
        
        segmentControl.selectedSegmentIndex = (0)
        collectionView.reloadData()
        
        //        self.navigationController?.navigationBarHidden = true
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "goToSearchedItem:", name: "goToSearchedItem", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "hideSearchView:"  , name: "hideSearchView", object: nil)
        
    }
    
    
    
    
    // ------------- L  A  Y  O  U  T --------------
    
    
    override func viewWillLayoutSubviews() {
        let bgImageView = UIImageView(image: UIImage(named: "parkLandscapeBG"))
        bgImageView.contentMode = .ScaleAspectFit
        bgImageView.frame = self.view.frame
        self.view.addSubview(bgImageView)
        self.view.sendSubviewToBack(bgImageView)
        
        
    }
    
    
    var searchViewFrameOn    :  CGRect!
    var searchViewFrameOff   :  CGRect!
    
    var searchButtonFrameOn  : CGRect!
    var searchButtonFrameOff : CGRect!
    
    
    override func viewDidLayoutSubviews() {
        
        searchViewFrameOn   = searchView.frame
        searchButtonFrameOn = searchButton.frame
        
        searchView.frame.origin.x = self.view.frame.size.width
        searchButtonFrameOff = searchView.frame
        let dif = searchView.frame.origin.x - searchViewFrameOn.origin.x
        searchViewFrameOff = searchView.frame
        searchButton.frame.origin.x += dif - 80
        searchButtonFrameOff = searchButton.frame
        
    }
    
    
    // -----------------   F U N C T I O N S   --------------
    
    func goToSearchedItem(notification:NSNotification){
        elementNeeds = notification.object as? ElementManager.Element
        
        performSegueWithIdentifier("showElementFromCategories", sender: self)
    }
    
    // O P E N i n g
    func showSearchView(){
        NSNotificationCenter.defaultCenter().postNotificationName("showKeyboard", object: nil)
        UIView.animateKeyframesWithDuration(0.3, delay: 0.0, options: UIViewKeyframeAnimationOptions.BeginFromCurrentState, animations: { () -> Void in
            
            
            self.searchView.frame        = self.searchViewFrameOn
            self.searchButton.frame      = self.searchButtonFrameOn
            //          self.searchButton.transform  = CGAffineTransformRotate(self.searchButton.transform, CGFloat(-M_PI/2.0))
            
            }, completion: nil)
        
    }
    
    // C L O S I N G
    func hideSearchView(notification: NSNotification?){
        NSNotificationCenter.defaultCenter().postNotificationName("hideKeyboard", object:nil )
        
        UIView.animateKeyframesWithDuration(0.3, delay: 0.0, options: UIViewKeyframeAnimationOptions.BeginFromCurrentState, animations: { () -> Void in
            
            self.searchView.frame       = self.searchViewFrameOff
            self.searchButton.frame     = self.searchButtonFrameOff
            //          self.searchButton.transform = CGAffineTransformRotate(self.searchButton.transform, CGFloat(M_PI/2.0))
            
            
            
            }, completion: nil)
        
    }
    
    
    // ----------------- A  C  T  I  O  N  S  ---------------
    
    
    
    @IBAction func pressedSearch(sender: AnyObject)
    {
        if self.searchButton.frame == searchButtonFrameOff
        {
            showSearchView()
        }
        else
        {
            hideSearchView(nil)
        }
    }
    
    
    
    @IBAction func backButtonTapped(sender: UIButton)
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    // ----------- C o l l e c t i o n   V i e w  -------------
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cellId    = "collectionViewCell"
        let cell      = collectionView.dequeueReusableCellWithReuseIdentifier(cellId, forIndexPath: indexPath) as! CollectionViewCell
        
        // C E L L  _  I M A G E
        
        let cell_image_name = rootsArray![segmentControl.selectedSegmentIndex].categoriesArray![indexPath.row].categoryName! + "_thumb"
        if let cell_image   = UIImage(named:cell_image_name){
            cell.cellBG.image       = cell_image
            cell.cellBG.contentMode = UIViewContentMode.ScaleAspectFit
        }
            
        else{
            //make an image that contains only name :
            cell.label.hidden = false
            let text = base.rootArray![segmentControl.selectedSegmentIndex].categoriesArray![indexPath.row].categoryName
            cell.label.text = text
            cell.cellBG.image  = UIImage(named: "defaultCollectionButton")
            
        }
        
        cell.bringSubviewToFront(cell.label)
        
        cell.layoutIfNeeded()
        
        return cell;
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = base.rootArray![segmentControl.selectedSegmentIndex].categoriesArray!.count
        return count
    }
    
    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        selectedIndexPath = indexPath
        
        return true
    }
    
    
    // -------- S E G M E N T  C O N T R O L ----------------
    
    @IBAction func segmentChangedValue(sender: UISegmentedControl)
    {
        self.collectionView.reloadData()
    }
    
    // ----------- S    E    G   U   E ---------->
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // from search
        if segue.identifier == "showElementFromCategories"
        {
            let vc : ElementVC = segue.destinationViewController as! ElementVC
            print("&& HERE PREPAREA FOR SUGUE")
            print(elementNeeds?.name)
            
            //passing the pressed button key to the dictionary that will be sent to the next VC
            let itemToTransfer : ElementManager.Element? = elementNeeds
            itemToTransfer?.printDescreption()
            vc.element    = itemToTransfer
            
            
        }
            
            
        else if segue.identifier == "showCat"
        {
            let vc : CategoriesVC = segue.destinationViewController as! CategoriesVC
            
            if let _ = rootsArray![segmentControl.selectedSegmentIndex].rootName
            {
                //passing the pressed button key to the dictionary that will be sent to the next VC
                let item  = rootsArray![segmentControl.selectedSegmentIndex].categoriesArray![selectedIndexPath.row].elementsArray
                
                vc.categoryArray = item
            }
            
        }
        
        
    }
    
    
    
    // Code Finished :  Aug 15
    // Last touch September 3 // converted to ElementManager
}
