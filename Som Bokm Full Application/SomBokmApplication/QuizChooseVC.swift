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

class QuizChooseVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet var picker: UIPickerView!
    
    @IBOutlet var numberField: UITextField!
    @IBOutlet var collectionView: UICollectionView!
    
    var numberOfQuestions = 0
    var gameType : GameType!
    var pickerValues = [Int]()
    
    override func viewDidLoad() {
        let bgImageView = UIImageView(image: UIImage(named: "parkLandscapeBG"))
        bgImageView.contentMode = .ScaleAspectFit
        bgImageView.frame = self.view.frame
        self.view.addSubview(bgImageView)
        self.view.sendSubviewToBack(bgImageView)
        
        super.viewDidLoad()
        
        for i in 1...30 {
            pickerValues.append(i)
        }
        
        picker.delegate = self
        picker.dataSource = self
    }
    
    @IBAction func FreeGame(sender: UIButton) {
        gameType = GameType.Free
        self.performSegueWithIdentifier("2quiz", sender: self)
    }
    
    @IBAction func Done(sender: UIButton)
    {
            gameType = GameType.Limited
            self.performSegueWithIdentifier("2quiz", sender: self)
    }
    
    
    /*
    • • • • • • • • • • • • • • • • • • • • • • • • • • • • • •
                        P I C K E R   V I E W
    • • • • • • • • • • • • • • • • • • • • • • • • • • • • • •
    */
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerValues.count
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return String(stringInterpolationSegment: pickerValues[row])
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
            numberOfQuestions = pickerValues[row]
    }
    
    /*
        • • • • • • • • • • • • • • • • • • • • • • • • • • • • • • 
                    C O L L E C T I O N   V  I E W
        • • • • • • • • • • • • • • • • • • • • • • • • • • • • • •
    */

    
    
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

