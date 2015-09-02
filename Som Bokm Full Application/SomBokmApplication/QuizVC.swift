 //
//  ViewController.swift
//  Quiz-somBokm
//
//  Created by Omar on 7/3/15.
//  Copyright (c) 2015 OMSI. All rights reserved.
//
 

import UIKit

class QuizVC: UIViewController {
// number of times the word should be answered to get matered in the word
    let masteredConstant = 1
    
    @IBOutlet weak var videoContainer: UIView! // container to get the frame from it  
    
// Buttons of the images will be shown for the user to tap 
    /*
            multi touch should be disabled for these buttons
    */
    @IBOutlet weak var image1: UIButton!
    @IBOutlet weak var image2: UIButton!
    @IBOutlet weak var image3: UIButton!
    @IBOutlet weak var image4: UIButton!
    @IBOutlet var resultPage : UIImageView!
    @IBOutlet var resultLabel: UILabel!
    @IBOutlet var blurView: UIVisualEffectView!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var resultView: UIView!
    
    var correctionImage = UIImageView()
    
    var rightAnswerIndex = 0
    var rightAnswerElement  : NSDictionary?
    var rightAnswerKey      : String = ""
    
    // array that holds buttons of the answers
    var elementsImages = [UIButton]()
    
    // Dictionary with all elements without any categorization ( all keys )
    var dictionaryOfAllElements = [String : NSDictionary]()
    
    var tahjee2VideoPlayer : VideoPlayer?
    var tahjee2VideoName  = ""
    
    var masteredWords = [String]()
    
    var numberOfQuestions  = Int() //To Change
    var gameCount = 0
    var rightAnsweredTimes = Int()
    
    
    /*  ******************************************
    
                        Did Load
    
        ******************************************
    */
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.view.bringSubviewToFront(resultPage)
        self.view.bringSubviewToFront(resultLabel)
// all elements now and its prpoerties are in this dictionary
        dictionaryOfAllElements = DictionaryManager.getAllElementsInDictinoary()
        
        elementsImages = [self.image1, self.image2 , self.image3 , self.image4]
        
        for i in elementsImages{
            i.contentMode = UIViewContentMode.ScaleAspectFill
        }
        
        play()
        
        self.image1.contentMode = UIViewContentMode.ScaleAspectFit
    }
    
    
    
    /*  ******************************************
    
                PLAY
        is each time the question shows
    
    ******************************************
    */
    
    
    
    
    
    func play(){

        // Array that includes dictionaries of 4 elements only i.e [أسد,طاووس,نمر ,جمل]
        var randomElementsForChoices  = NSMutableArray()
        
        // arrayoOfKeys is all elements names in one array i.e : أسد,طاووس,نمر ...
        let allElementsOfCategories = dictionaryOfAllElements.keys.array

        // get shuffled random numbers in an array for the buttons  , ar : is an array contains numbers from 0 to 3
        var ar  = [Int]()
        for var k = 0 ; k < 4 ; k++ {
            ar.append(k)
        }


        var shuffledElements = shuffle(allElementsOfCategories,size: allElementsOfCategories.count)
        var shuffledNumbers  = shuffle(ar,size: ar.count)
        
        
        for (var i = 0 ; i < 4 ; i++)
            {
            var randomNum = shuffledNumbers[i]
            randomElementsForChoices.addObject(shuffledElements[randomNum])
            }
        
        for (var j=0 ; j < allElementsOfCategories.count ; j++){
            // counting j
            }
        
        
        //Here are the names of the images that will be displayed in the four buttons
        let namesOfImages = [
            (randomElementsForChoices[0] as! String) + "Big",
            (randomElementsForChoices[1] as! String) + "Big",
            (randomElementsForChoices[2] as! String) + "Big",
            (randomElementsForChoices[3] as! String) + "Big"]
        
        
        // showing images in the buttons randomly
 
        for (var i=0 ; i<4 ; i++){
            
            var j: Int = shuffledNumbers[i] // <- should be a random number  generator
            
            let elementImage : UIButton = (elementsImages[j])
            // chnaged to set image from set
            elementImage.setBackgroundImage(UIImage(named: namesOfImages[j]), forState: UIControlState.Normal)
            elementImage.tag = j+1 // set the tag to the random number
// when the first random number is generated , let this be the right answer , its index is not 0 , it is random number 
// for example let's say the computer generated 2,3,1,0 , ( rightAnswerIndex = 2 )
            if i==0 {
                rightAnswerIndex = j
            }
        }
        
        // the Answered Element
        rightAnswerKey = randomElementsForChoices.objectAtIndex(rightAnswerIndex) as! String
        rightAnswerElement = dictionaryOfAllElements[rightAnswerKey]
        
        
//        println(rightAnswerElement)
        
        if let SIVideoOfElementInDictionary : String = rightAnswerElement!.objectForKey("SI_video") as? String
        {   tahjee2VideoName = SIVideoOfElementInDictionary }
        
        

        
        

        tahjee2VideoPlayer?.videoName = tahjee2VideoName
        tahjee2VideoPlayer?.replay()


    }
    
    
    
    
    /*  ******************************************
    
                Did Appear
    
    ******************************************
    */
    
    
    
    
    override func viewDidAppear(animated: Bool) {
        /*
        NOTES :
        I have moved the preparing frame for tahjee2 video process to Here so i can get the exact frame from the layout after proceeding the layout , so it can get its real layout
        
        */
        
        tahjee2VideoPlayer = VideoPlayer(name: tahjee2VideoName, withFrame: videoContainer.frame)
        self.view.addSubview(tahjee2VideoPlayer!.view)
        tahjee2VideoPlayer?.play()
        
    
        prepareCorrectionImage()
        self.view.addSubview(correctionImage)
    }
    
    
    func prepareCorrectionImage(){
        
        correctionImage.frame.size = CGSizeMake(400, 400)
        correctionImage.center = self.view.center
        correctionImage.hidden = true

    }
    
    
    // When Answerring
    /*
    
    Ths function should contain the following
    
    * checks if the pressed button has index as the video showing
    * if wrong answer , The right answer pops up animtingly , or shake or whatever , (*does some animation)
    * if right answer ->{
    - counts number of answered word from the dictionary and save it in NSUserDefaults
    - checks the mastered word list  , if the counter >= 5  -> Get MASTERED
    - when clicking quickly on two answers , once shows 'x' then shows tick , the tick doesnt show
    }
    
    */
    
    
    /*  ******************************************
    
        ACTION :    IMAGE PRESSED
    
        when The Image is preessed shows true or false , checks mastered , go to next question
    
    ******************************************
    */
    
    var def = NSUserDefaults.standardUserDefaults()

    @IBAction func imagePressed(sender: UIButton)
    {
        prepareCorrectionImage()
        self.gameCount++

        if sender.tag == rightAnswerIndex + 1 {
            
            /*  ******************************************
            
                            Right Answer ****
            
                ******************************************
            */
            
            
            rightAnsweredTimes++ // Aug 29
            
            correctionImage.image = UIImage(named: "rightImage")
            correctionImage.hidden = false
            
            
            
            
            
            
            if let _rightAnswerElement = self.rightAnswerElement{
                var copyOfRightAnswerElement = NSMutableDictionary(dictionary: _rightAnswerElement)
                var key = "answeredTimes"
                let name: String? = _rightAnswerElement.objectForKey("name") as? String
                println("before answering : ")
                //                println((dictionaryOfAllElements[randomElementsForChoices.objectAtIndex(rightAnswerIndex) as! String]!.objectForKey(key))!)
                var count = copyOfRightAnswerElement.objectForKey(key) as! Int
                count++
                
                
                /* Comments :
                
                ** when the user get Mastered , the alert should be immediatly after he presses the button
                ** should save the dictuinary in UserDefaults ,
                
                ******  Change number of times the word should be answered here  ****
                
                */
                var masteredAlready = false
                
                if let wordsArray = def.objectForKey("MasteredWordsArray") as? [String]{
                    println("there are some variables added to The Defaults")
                    
                    masteredWords = wordsArray
                for s in wordsArray
                {
                    println("OMSILALA")
                    println(s)
                    if name! == s{
                        println("\(name) element is mastered already\n\n")
                        masteredAlready = true
                    }
                }
                }
                
                if masteredAlready{
                // just skip the else
                    println("MASTERED HUHH")
                }
                else if count == masteredConstant {
                        
                    masteredWords.append(name!)
                    def.setObject (masteredWords, forKey: ("MasteredWordsArray"))
                    def.synchronize()

                    
                    //                                    let alert = UIAlertView(title: "You have mastered This word!", message: "Conrgratulation , you have mastered the word\(name!)", delegate: self, cancelButtonTitle: "Done")
                    //                                    alert.alertViewStyle = UIAlertViewStyle.PlainTextInput
                    //                                    alert.show()
                    
                    let blackView = UIView(frame: self.view.frame)
                    blackView.backgroundColor = UIColor.blackColor()
                    blackView.alpha = 0.0
                    blackView.userInteractionEnabled = true
                    self.view.addSubview(blackView)
                    
                    
                    
                    let starView = UIImageView(frame: CGRectMake(self.view.center.x, self.view.center.y, 220.0, 220.0))
                    starView.center = self.view.center
                    starView.image = UIImage(named:"star")
                    self.view.addSubview(starView)
                    starView.alpha  = 0.0
                    println("\n****Mastered****\n")
                    
                    
                    UIView.animateWithDuration(0.4, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                        blackView.alpha = 0.4
                        starView.alpha = 1.0
                        
                        }, completion: { (f : Bool) -> Void in
                        

                            UIView.animateWithDuration(0.4, animations: { () -> Void in
                                blackView.alpha = 0.0
                                starView.alpha = 0.0
                                
                            })
                            
                    })
                    
                }
                
                copyOfRightAnswerElement.setValue(count, forKey: key)
                copyOfRightAnswerElement.setValue(true, forKey: "isMastered")
                println("copyOfRightAnswerElement : \(copyOfRightAnswerElement)\n count is : \(count)")
                self.dictionaryOfAllElements[self.rightAnswerKey] = copyOfRightAnswerElement
                
                println("after answering ")
                self.rightAnswerElement = copyOfRightAnswerElement
                println(self.dictionaryOfAllElements[self.rightAnswerKey])
                
            }
            
                      
            UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.BeginFromCurrentState, animations: { () -> Void in
                
                UIView.animateWithDuration(0.1, animations: { () -> Void in
                    self.correctionImage.alpha = 1
                })
                
                self.correctionImage.frame.size = CGSizeMake(self.correctionImage.frame.size.width / 3.0, self.correctionImage.frame.size.height / 3.0)
                self.correctionImage.center = sender.center
                
                }, completion: { (finished : Bool) -> Void in
                    
                    
                    
                    UIView.animateWithDuration(0.4, animations: { () -> Void in
                        self.correctionImage.alpha = 0.0
                        
                        }, completion: { (finished : Bool) -> Void in
                            

                                
                             self.prepareCorrectionImage()

                            
                            UIView.animateWithDuration(0.3, animations: { () -> Void in
                                /*
                                animating all images and buttons to go out and in to make transitions between two quesions
                                */

                                for i in self.elementsImages{
                                  i.alpha = 0.0
                                }
                                self.tahjee2VideoPlayer?.view.alpha = 0.0
                                
                                }, completion: { (f:Bool) -> Void in
                                
// After Hiding
                                  UIView.animateWithDuration(0.2, animations: { () -> Void in
                                    
// Showing Elemetns after hiding to another question
                            
                                    for i in self.elementsImages{
                                        i.alpha = 1.0
                                    }
                                    self.tahjee2VideoPlayer?.view.alpha = 1.0

                                    
                                  })
                                    
                                    
                                    if self.gameIsOver(){
                                        println("Game Over!")
                                        // Show result
                                        self.showResult()
                                        
                                    }
                                    else{
                                        self.play()
                                    }
                                   
                                    
                            })
                    })
            })
        }
        

/*
 ••••••••••••••••••••••••••••••••
            Wrong Answer
 ••••••••••••••••••••••••••••••••
 */
        if (!(sender.tag == rightAnswerIndex + 1)) {
// wrong answer

            correctionImage.image = UIImage(named: "falseImage")
            correctionImage.hidden = false
            
            UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.BeginFromCurrentState, animations: { () -> Void in
                
                UIView.animateWithDuration(0.1, animations: { () -> Void in
                    self.correctionImage.alpha = 1
                })
                
                self.correctionImage.frame.size = CGSizeMake(self.correctionImage.frame.size.width / 3.0, self.correctionImage.frame.size.height / 3.0)
                self.correctionImage.center = sender.center

                }, completion: { (finished : Bool) -> Void in

                    
                    UIView.animateWithDuration(0.4, animations: { () -> Void in
                        self.correctionImage.alpha = 0.0
                        
                        }, completion: { (finished : Bool) -> Void in
                            
                            
                            
                            self.prepareCorrectionImage()
                            
                            
                            UIView.animateWithDuration(0.3, animations: { () -> Void in
                                /*
                                animating all images and buttons to go out and in to make transitions between two quesions
                                */
                                
                                for i in self.elementsImages{
                                    i.alpha = 0.0
                                }
                                self.tahjee2VideoPlayer?.view.alpha = 0.0
                                
                                }, completion: { (f:Bool) -> Void in
                                    
                                    // After Hiding
                                    UIView.animateWithDuration(0.2, animations: { () -> Void in
                                        
                                        // Showing Elemetns after hiding to another question
                                        
                                        for i in self.elementsImages{
                                            i.alpha = 1.0
                                        }
                                        self.tahjee2VideoPlayer?.view.alpha = 1.0
                                        
                                        
                                    })
                                    
                                    
                                    if self.gameIsOver(){
                                        println("Game Over!")
                                        // Show result
                                        self.showResult()
                                        
                                    }
                                    else{
                                        self.play()
                                    }
                                    
                                    
                            })
                    })
               
                    

                    
            })
            
            
        //    println("Right Answer has index : \(rightAnswerIndex+1)")
            let button = self.view.viewWithTag(rightAnswerIndex+1) as! UIButton
            
        // right anwer shakes ANIMATION
            let animation = CABasicAnimation(keyPath: "position")
            animation.duration = 0.04
            animation.repeatCount = 4
            animation.autoreverses = true
            animation.fromValue = NSValue(CGPoint: CGPointMake(button.center.x - 10, button.center.y))
            animation.toValue = NSValue(CGPoint: CGPointMake(button.center.x + 10, button.center.y))
            button.layer.addAnimation(animation, forKey: "position")
      
            
            
        }
        
        
    }
    

    
    func gameIsOver() -> Bool {
        if gameCount >= numberOfQuestions{
            // gameOver
            
            
            return true
        }
        
        return false
        
    }
    
    func showResult(){

        // Hide all Questions
        
//        self.view.bringSubviewToFront(blurView)
//        self.view.bringSubviewToFront(resultPage)
//        self.view.bringSubviewToFront(resultLabel)
//        self.view.bringSubviewToFront(backButton)

//        blurView.alpha = 0.0
//        blurView.hidden    = false

        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.blurView.alpha = 1.0
            self.resultView.transform = CGAffineTransformMakeTranslation(0, -800)
        })

        
        resultLabel.text   = String("\(rightAnsweredTimes) / \(numberOfQuestions)")
        
        
    }

    @IBAction func backButtonTapped(sender: UIButton)
    {
        let alertViewController = UIAlertController(title: "تأكيد", message: "هل انت متأكد من الخروج ؟", preferredStyle: UIAlertControllerStyle.Alert)
        
        let exitAction = UIAlertAction(title: "خروج", style: UIAlertActionStyle.Default)
            { (action) -> Void in
            self.navigationController?.popViewControllerAnimated(true)
        }
        
        let cancelAction = UIAlertAction(title: "الغاء", style: UIAlertActionStyle.Cancel, handler: nil)
        
        alertViewController.addAction(exitAction)
        alertViewController.addAction(cancelAction)
        
        self.presentViewController(alertViewController, animated: true, completion: nil)
    }

    @IBAction func homeButtonTapped(sender: UIButton)
    {
        let alertViewController = UIAlertController(title: "تأكيد", message: "هل انت متأكد من الخروج ؟", preferredStyle: UIAlertControllerStyle.Alert)
        let exitAction = UIAlertAction(title: "خروج", style: UIAlertActionStyle.Default)
            { (action) -> Void in
                self.navigationController?.popToRootViewControllerAnimated(true)
        }
        
        let cancelAction = UIAlertAction(title: "الغاء", style: UIAlertActionStyle.Cancel, handler: nil)
        
        alertViewController.addAction(exitAction)
        alertViewController.addAction(cancelAction)
        
        self.presentViewController(alertViewController, animated: true, completion: nil)
    }
    
    
/*
        SHUFFLE FUNCTION : is a function that inputs an array , and it shuffled it , so we get array of random numbers unrepeatidly
    
*/
    
    func shuffle<C: MutableCollectionType where C.Index == Int>(var list: C, size : Int) -> C {


        let count = size
        
        for i in 0..<(count - 1) {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            swap(&list[i], &list[j])
        }
        return list
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let id = "toMastered"
        let vc : MasteredWordVCViewController = segue.destinationViewController as! MasteredWordVCViewController
        

            vc.masteredWordsArray = masteredWords

        
        
    }
}

