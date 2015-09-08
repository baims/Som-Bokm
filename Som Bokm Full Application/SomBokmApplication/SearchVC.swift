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
    //    var suggestedItems : Array<String> = []
    //    var searchedItemExists : Bool = false
    //    var dictionaryOfElements : [String:(categoryType:String,nameInArabic:String)] = Dictionary()
    //    var elementName     : String?       //will transfer to the elementVC when *SEARCHING* to get the key from Dictionary
    //    var dictionaryName  : String?       //will transfer to the elementVC when *SEARCHING* to push the elementDictionary
    //    var dictionaryKey   : String?
    //    var categoryDictionary = NSDictionary() //Dictionary of Categories ONLY without alphabit
    //
    //    var elementsNames : Array<String> = []
    
    
    var suggestedItems : [ElementManager.Element] = []
    var selectedElement = ElementManager.Element()
    var searchedItemExists = false
    var base = ElementManager.Base()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.backgroundColor = UIColor.clearColor()
        table.separatorColor = UIColor.clearColor()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "hideKeyboard:"  , name: "hideKeyboard", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showKeyboard:"  , name: "showKeyboard", object: nil)
        
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //println("**")
        //        for i in suggestedItems {
        //            i.printDescreption()
        //            println("--")
        //        }
        //println("**")
        return suggestedItems.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("searchCell", forIndexPath: indexPath) as! SearchTableViewCell
        
        cell.cellLabel.text  = suggestedItems[indexPath.row].arName
        
        var imageName        = suggestedItems[indexPath.row].imageName
        cell.cellImage.image = UIImage(named:imageName!)
        
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
        
        
        
        let text =  suggestedItems[indexPath.row].arName!
        searchField.text = text
        
        checkSearching(text)
        println(searchedItemExists)
        if searchedItemExists{
            println ("notifiaction pushed")
            
            NSNotificationCenter.defaultCenter().postNotificationName("goToSearchedItem", object:selectedElement )
            // notifiaction pushed
            
            table.reloadData()
            searchField.text = ""
            
            searchField.resignFirstResponder()
            
        }
        
    }
    
    
    
    @IBAction func searchWord(sender: UITextField) {
        if let text = sender.text{
            checkSearching(sender.text)
            table.reloadData()
        }
        
    }
    
    func hideKeyboard(notification: NSNotification?){
        searchField.resignFirstResponder()
    }
    func showKeyboard(notification: NSNotification?){
        searchField.becomeFirstResponder()
    }
    
    func checkSearching(text: String){
        let array = ElementManager.getArrayyOfElementsWithPrefix(text, base: ElementManager.Base())
        suggestedItems = array
        
        // get the element
        if let str = ElementManager.Element.getEnglishNameFromArabic(text){
            var el = ElementManager.Base()[str]
            
            if !el.isNil!
            {
                selectedElement = el
                println("The selected element \(selectedElement.name) is ready to push")
                searchedItemExists = true
            }
            else{
                searchedItemExists = false
            }
        }
        
        
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
