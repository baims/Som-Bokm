//
//  MasteredWordVCViewController.swift
//  Quiz-somBokm
//
//  Created by Omar Alibrahim on 8/3/15.
//  Copyright (c) 2015 OMSI. All rights reserved.
//

import UIKit

class MasteredWordVCViewController: UIViewController , UITableViewDelegate ,  UITableViewDataSource  , UIAlertViewDelegate {

    var masteredWordsArray = [String]()
    @IBOutlet var tableView : UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        

// uncomment this line if you are using NSUserDefaults 
        
//        masteredWordsArray = NSUserDefaults.standardUserDefaults().objectForKey("MasteredWordsArray") as! [String]
        
        println(masteredWordsArray)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("cellFotMaster", forIndexPath: indexPath) as! UITableViewCell
        
        cell.textLabel?.text = masteredWordsArray[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return masteredWordsArray.count
    }
    
    
    
    @IBAction func backButtonTapped(sender: UIButton)
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func clearAllWords(sender:UIButton){
        var alert = UIAlertView(title: "تحذير!", message: "سيتم مسح جميع الكلمات من قائمة الكلمات المتقنة , هل أنت متأكد ؟", delegate: self, cancelButtonTitle: "Clear", otherButtonTitles: "Cancel")
        alert.show()

    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 0 {
            NSUserDefaults.standardUserDefaults().setObject([], forKey: "MasteredWordsArray")
            masteredWordsArray = []
            var Print_numberOFmasteredWords = ElementManager.getMasteredWords()
            
            ElementManager.resetBase()
            
            tableView.reloadData()

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

extension ElementManager {
    class func getMasteredWords()->[ElementManager.Element]
    {
        var mastered : [ElementManager.Element] = []
        for element in self.getAllElementsFromBase(base: Base())
        {
            if element.isMastered! == true{
//                print(element.name! + "  IS master\n")
                mastered.append(element)
            }
        }
        println("All mastered words are\(mastered.count)")
        return mastered
    }
    

}

extension ElementManager{
    class func resetBase(){
        var b = Base()
            b = prepareItemsOfDataBase()
            b.sync()
    }
}
