//
//  QuizChooseVC.swift
//  SomBokmApplication
//
//  Created by Omar Alibrahim on 8/30/15.
//  Copyright (c) 2015 Baims. All rights reserved.
//

import UIKit

class QuizChooseVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {

    
    @IBOutlet var numberField: UITextField!
    @IBOutlet var collectionView: UICollectionView!

    var numberOfQuestions = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func Done(sender: UIButton) {
        if numberField.text.toInt() == nil{
            UIAlertView(title: "WARNING", message: "Please Enter valid number", delegate: nil, cancelButtonTitle: "OK").show()
        }
        else
        {
            numberOfQuestions = numberField.text.toInt()!
            self.performSegueWithIdentifier("2quiz", sender: self)
        }
//        
//        if let i =  numberField.text.toInt() {
//        }
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("co", forIndexPath: indexPath) as! UICollectionViewCell
        
        
        
        return cell
    }

    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      
        var vc = segue.destinationViewController as! QuizVC
        vc.numberOfQuestions = numberOfQuestions
    }
    

}
