//
//  QuizChooseVC.swift
//  SomBokmApplication
//
//  Created by Omar Alibrahim on 8/30/15.
//  Copyright (c) 2015 Baims. All rights reserved.
//

enum GameType {
    case Free
    case Limited
}


import UIKit

class QuizChooseVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    
    
    @IBOutlet var numberField: UITextField!
    @IBOutlet var collectionView: UICollectionView!
    
    var numberOfQuestions = 0
    var gameType : GameType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }
    @IBAction func FreeGame(sender: UIButton) {
        gameType = GameType.Free
        self.performSegueWithIdentifier("2quiz", sender: self)
    }
    
    @IBAction func Done(sender: UIButton) {
        if numberField.text.toInt() == nil{
            UIAlertView(title: "WARNING", message: "Please Enter valid number", delegate: nil, cancelButtonTitle: "OK").show()
        }
        else
        {
            numberOfQuestions = numberField.text.toInt()!
            gameType = GameType.Limited
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
    
    
    @IBAction func backButtonTapped(sender: UIButton)
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        var vc = segue.destinationViewController as! QuizVC
        vc.numberOfQuestions = numberOfQuestions
        vc.gameType = gameType
    }
    
    
}

