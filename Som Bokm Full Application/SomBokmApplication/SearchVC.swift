//
//  SearchVC.swift
//  QamosSomBokm
//
//  Created by Omar Alibrahim on 8/11/15.
//  Copyright (c) 2015 Baims. All rights reserved.
//

import UIKit

class SearchVC: UIViewController ,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var searchField: UITextField!
    
    @IBOutlet weak var table: UITableView!
    var suggestedItems : Array<String> = []
    
    var searchedItemExists : Bool = false
    var dictionaryOfElements : [String:(categoryType:String,nameInArabic:String)] = Dictionary()
    var elementName     : String?       //will transfer to the elementVC when *SEARCHING* to get the key from Dictionary
    var dictionaryName  : String?       //will transfer to the elementVC when *SEARCHING* to push the elementDictionary
    var dictionaryKey   : String?
    var categoryDictionary = NSDictionary() //Dictionary of Categories ONLY without alphabit
    
    var elementsNames : Array<String> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.backgroundColor = UIColor.clearColor()
        table.separatorColor = UIColor.clearColor()
        
        

        var def = NSUserDefaults.standardUserDefaults()
        categoryDictionary = def.valueForKey("categoryDictionary") as! NSDictionary
        
        
        
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
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "hideKeyboard:"  , name: "hideKeyboard", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showKeyboard:"  , name: "showKeyboard", object: nil)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return suggestedItems.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("searchCell", forIndexPath: indexPath) as! SearchTableViewCell
        
        cell.cellLabel.text = suggestedItems[indexPath.row]
        
        var imageName       = elementsNames [indexPath.row] + "Big"
        
        cell.cellImage.image = UIImage(named: imageName)
        
        var seperatorView = UIView(frame: CGRectMake(0,cell.frame.size.height-3,cell.frame.size.width,3))
        seperatorView.backgroundColor = UIColor.grayColor()
        cell.addSubview(seperatorView)
        
        cell.alpha = 0.7
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("Selected")
        
        var cell = tableView.cellForRowAtIndexPath(indexPath) as! SearchTableViewCell
        searchField.text = cell.cellLabel.text
        
        checkSearching(cell.cellLabel.text!)
        
        if searchedItemExists{
            println ("notifiaction pushed")
            
            var elementNeeds = [dictionaryName!, dictionaryKey!, elementName!]
            NSNotificationCenter.defaultCenter().postNotificationName("goToSearchedItem", object:elementNeeds )
            NSNotificationCenter.defaultCenter().postNotificationName("hideSearchView", object: nil)
            // notifiaction pushed
            suggestedItems = []
            elementsNames = []
            table.reloadData()
            searchField.text = ""
            
            searchField.resignFirstResponder()

        }
        
    }
    
    
    
    @IBAction func searchWord(sender: UITextField) {
        if let text = sender.text{
            suggestedItems = []
            elementsNames = []
            
            checkSearching(text)
        }
        
    }
    
    func hideKeyboard(notification: NSNotification?){
        searchField.resignFirstResponder()
    }
    func showKeyboard(notification: NSNotification?){
        searchField.becomeFirstResponder()
    }
    
    func checkSearching(text: String)->Bool{
        searchedItemExists   = false
        for (k,(a,e)) in dictionaryOfElements as! [String:(String,String)] {
            //                println(s)
            if text == a{
                //                    println("Founded \(a)")
                elementName     = a
                dictionaryName  = e
                dictionaryKey   = k
                
                searchedItemExists   = true
                //Go to the VC which has the value searched for
            }
            
            //Uncomment These lines if you want to search with un full word
            if a.hasPrefix(text){
                
                println("Suggested: \(a)")
                
                suggestedItems.append(a)
                elementsNames.append(k)
                
                table.reloadData()
                
                
                
                
                /*
                Here it should be some code that displays suggestions for the user
                */
            }
            else{
                table.reloadData()
            }
            
        }
        return searchedItemExists
    }
    
    @IBAction func goToTheSearchedItem(sender: AnyObject) {
        if searchedItemExists{
            //            self.performSegueWithIdentifier("showElementFromCategories", sender: self)
            searchField.resignFirstResponder()
            println("Presed")
        }
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
