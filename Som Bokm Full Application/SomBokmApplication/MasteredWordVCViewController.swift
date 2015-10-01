//
//  MasteredWordVCViewController.swift
//  Quiz-somBokm
//
//  Created by Omar Alibrahim on 8/3/15.
//  Copyright (c) 2015 OMSI. All rights reserved.
//

import UIKit
/*


you can delete this class no longer useful


*/

class MasteredWordVCViewController: UIViewController , UITableViewDelegate ,  UITableViewDataSource  , UIAlertViewDelegate {

    var masteredWordsArray = [String]()
    @IBOutlet var tableView : UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
              // Do any additional setup after loading the view.
    }

    override func viewWillAppear(animated: Bool) {

//        let allElemtns = ElementManager.getAllElementsFromBase()
        masteredWordsArray = []
        
        for i in ElementManager.getMasteredWords()
        {
                masteredWordsArray +=  [i.name!]
            
        }
                tableView.reloadData()
        // reload Base in Quiz VC
        
//        for element in allElemtns{
        
            //            print(element.isMastered == false ? element.name! + " not mastered" : element.name! + " is Mastered\n")
//            if element.isMastered! == true
//            {
//                print("element 1 in mastered : " + element.name!)
//                masteredWordsArray.append(element.name!)
//            }
//        }
        // uncomment this line if you are using NSUserDefaults
        
        //        masteredWordsArray = NSUserDefaults.standardUserDefaults().objectForKey("MasteredWordsArray") as! [String]
        
        print(masteredWordsArray)
        

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cellFotMaster", forIndexPath: indexPath)
        
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
        let alert = UIAlertView(title: "تحذير!", message: "سيتم مسح جميع الكلمات من قائمة الكلمات المتقنة , هل أنت متأكد ؟", delegate: self, cancelButtonTitle: "Clear", otherButtonTitles: "Cancel")
        alert.show()

    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 0 {
            
            masteredWordsArray = []
            ElementManager.resetBase()
            NSNotificationCenter.defaultCenter().postNotificationName("reloadBase", object: nil)
            tableView.reloadData()

        }
    }
    
}


    /*

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */





