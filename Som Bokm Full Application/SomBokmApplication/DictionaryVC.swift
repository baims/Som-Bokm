//  ViewController.swift
//  QamosSomBokm
//  Created by OMAR on 6/20/15.
//  Copyright (c) 2015 Baims. All rights reserved.
//

import UIKit


class DictionaryVC: UIViewController , UICollectionViewDelegate , UICollectionViewDataSource{
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchButton: UIButton!

    var arrayOfKeys = NSArray() // array of categories KEYS only ,ex. ["animals","plants","names"...]
    var arrayOfKeysLetters = NSArray() // array of alphabit KEYS only ,ex. ["A","B","C"...]
    var updatedArrayOfKeys = NSArray()
    var categoryDictionary = NSDictionary() //Dictionary of Categories ONLY without alphabit
    var alphabitDictionary = NSDictionary() //Dictionary of alphabit ONLY without category
    var numbersDictionary  = NSDictionary() //Dictionary of NUMBERS  ONLY without category

    var updatedDictionary = NSDictionary()
    
    var selectedIndexPath : NSIndexPath!    //index for collection view to know which item was selected in segue
    //This will bey (key : String , value: Tuple(String,String)) that will store both arabic name and english
    var dictionaryOfElements : [String:(categoryType:String,nameInArabic:String)] = Dictionary()
    /*shows all elements from all categories ex.
            [Key : Name in english , Value : (categoryType , name in arabic)]

*/
    var elementName     : String?       //will transfer to the elementVC when *SEARCHING* to get the key from Dictionary
    var dictionaryName  : String?       //will transfer to the elementVC when *SEARCHING* to push the elementDictionary
    var dictionaryKey   : String?       
    
//    var searchedItemExists = false
    
    
    
    
// ------- V I E W  D I D  L O A D  -------------
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        segmentControl.selectedSegmentIndex = 1

//        self.navigationController?.navigationBarHidden = true

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "goToSearchedItem:", name: "goToSearchedItem", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "hideSearchView:"  , name: "hideSearchView", object: nil)

    }
    

    
    
    override func viewWillAppear(animated: Bool) {
             //   self.navigationController?.navigationBar.hidden = true

        if let pathForPlist = NSBundle.mainBundle().pathForResource("Dictionary", ofType: "plist"){

            if let dictionaryForPlist = NSDictionary(contentsOfFile: pathForPlist){
// CAtegoies
                if let categories: NSDictionary? = dictionaryForPlist.objectForKey("categories") as? NSDictionary{
                    categoryDictionary =  categories!
                    println(categories!)
                    if let arrayOfCategories = categories?.allKeys{
                        arrayOfKeys = NSArray(array: arrayOfCategories)

                    }
                }
///ALPHABIT
                
                if let alphabiticLettersDictionary: NSDictionary? = dictionaryForPlist.objectForKey("alphabit") as? NSDictionary{
                    alphabitDictionary =  alphabiticLettersDictionary!
                    
                    if let arrayOfCategories = alphabiticLettersDictionary?.allKeys{
// sort the array accendingly
                    let sortedAlphabiticArray = arrayOfCategories.sorted { $1.localizedCaseInsensitiveCompare($0 as! String) == NSComparisonResult.OrderedDescending }
//                    println(sortedAlphabiticArray)
                        arrayOfKeysLetters = NSArray(array: sortedAlphabiticArray)
                        
                    }
                }
                
            }
            
            
// preparing For Search
// another if let To convert NSDictionary to swift Dictionaty aand then do the for in 
            
            if let dict = NSDictionary(dictionary: categoryDictionary) as? Dictionary<String, NSDictionary> {
//  c : catagory
                for (ckey ,cDic ) in dict
                {
                    let categDictionary = cDic as? Dictionary<String,NSDictionary>
//  e : element
                    for (eKey , eDic) in categDictionary!
                    {
                        let name   = eDic.objectForKey("name") as! String
                        let dicKey = ckey
                        dictionaryOfElements.updateValue((name,dicKey), forKey: eKey)
                    }
                }
                
                println("^^^^^^^^^^^^\n\(dictionaryOfElements)")
     
                
                
            }
            
        }
        println(segmentControl)
        
    switch segmentControl
    {
        case 0 :
            updatedArrayOfKeys = arrayOfKeysLetters
            updatedDictionary  = alphabitDictionary
        
            
        case 1 :
            updatedArrayOfKeys = arrayOfKeys
            updatedDictionary  = categoryDictionary
        
            
        default:
            updatedArrayOfKeys = arrayOfKeys
            updatedDictionary  = categoryDictionary
        }
        
        
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
        var dif = searchView.frame.origin.x - searchViewFrameOn.origin.x
        searchViewFrameOff = searchView.frame
        searchButton.frame.origin.x += dif - 80
        searchButtonFrameOff = searchButton.frame
        
    }
    
    
// -----------------   F U N C T I O N S   --------------
    
    
    func goToSearchedItem(notification:NSNotification){
        var center = NSNotificationCenter.defaultCenter()
        var elementNeeds = notification.object as! [String]
        dictionaryName = elementNeeds[0]
        dictionaryKey = elementNeeds[1]
        elementName = elementNeeds[2]
        
        performSegueWithIdentifier("showElementFromCategories", sender: self)
    }
    
    // O P E N i n g
    func showSearchView(notification: NSNotification?){
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
            showSearchView(nil)
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
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cellId = "collectionViewCell"
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellId, forIndexPath: indexPath) as! CollectionViewCell
        
        if let cell_image = UIImage(named:(updatedArrayOfKeys[indexPath.row] as? String)! + "_thumb" ){
            cell.cellBG.image = cell_image
            cell.cellBG.contentMode = UIViewContentMode.ScaleAspectFit
        }
        else{
//make an image that contains only name :
            cell.label.hidden = false
                    cell.label.text = updatedArrayOfKeys[indexPath.row] as? String
            cell.cellBG.image  = UIImage(named: "defaultCollectionButton")
            
        }

        cell.contentView.addSubview(cell.label)
        
        return cell;
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return updatedArrayOfKeys.count
    }

    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        selectedIndexPath = indexPath
        
        return true
    }


    
// -------- S E G M E N T  C O N T R O L ----------------

    @IBAction func segmentChangedValue(sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0 {
            updatedArrayOfKeys = arrayOfKeysLetters
            updatedDictionary  = alphabitDictionary
            }
        
        else
            {
            updatedArrayOfKeys = arrayOfKeys
            updatedDictionary  = categoryDictionary

            }
        self.collectionView.reloadData()
    }
    
    
    
// ----------- S    E    G   U   E ---------->
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
// from search
        if segue.identifier == "showElementFromCategories"
        {
            let vc : ElementVC = segue.destinationViewController as! ElementVC
            
//passing the pressed button key to the dictionary that will be sent to the next VC
            if let elementCategory = (categoryDictionary.objectForKey(dictionaryName!) as? NSDictionary){

                if let elementDictionary: NSDictionary  = elementCategory.objectForKey(dictionaryKey!) as? NSDictionary{

                    vc.elementDictionary = elementDictionary
//                    println("Dictionary of the element is the following,,,\n\(elementDictionary)")
                    vc.dictionaryName = elementName!
//                    println("Name of the element is \(elementName)")
                }
            }
        }
            
        else if segue.identifier == "showCat"
        {
            let vc : CategoriesVC = segue.destinationViewController as! CategoriesVC
        
            if let itemName = updatedArrayOfKeys[selectedIndexPath.row] as? String
            {
                //passing the pressed button key to the dictionary that will be sent to the next VC
                var dictionaryOfSelectedItem : NSDictionary = updatedDictionary.objectForKey(itemName) as! NSDictionary
                vc.categoryDict = dictionaryOfSelectedItem
            }
            
        }
        

}
 
    
    
    // Code Finished :  Aug 15
}
