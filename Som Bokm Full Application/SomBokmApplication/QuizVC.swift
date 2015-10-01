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
    
    var gameType : GameType!
    
    var correctionImage = UIImageView()
    
    var rightAnswerIndex = 0
//    var rightAnswerElement  : NSDictionary?
    var rightAnswerElement  : ElementManager.Element?
    var rightAnswerKey      : String = ""
    
    // array that holds buttons of the answers
    var elementsImages = [UIButton]()
    
    // Dictionary with all elements without any categorization ( all keys )
    var dictionaryOfAllElements = [String : NSDictionary]()
    var arrayOfAllElements : [ElementManager.Element] = []
    
    var tahjee2VideoPlayer : VideoPlayer?
    var tahjee2VideoName  = ""
    
    var masteredWords = [String]()
    
    var numberOfQuestions  = Int() //To Change
    var gameCount = 0
    var rightAnsweredTimes = Int()
    
    
    var base : ElementManager.Base!
    
    /*  ******************************************
    
    Did Load
    
    ******************************************
    */
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // all elements now and its prpoerties are in this dictionary
        /*
        Change the dictionary of what elements shows on screen
        */
        dictionaryOfAllElements = DictionaryManager.getAllElementsInDictinoary()
        base = ElementManager.Base()
        arrayOfAllElements = ElementManager.getAllElementsFromBase(base)
        
        elementsImages = [self.image1, self.image2 , self.image3 , self.image4]
        
        for i in elementsImages{
            i.contentMode = UIViewContentMode.ScaleAspectFill
        }
        
        play()
        
        self.image1.contentMode = UIViewContentMode.ScaleAspectFit
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadBase:", name: "reloadBase", object: nil)
    }
    
    func reloadBase(notification : NSNotification){
        if base != ElementManager.Base()
        {
            print("Base Has new version")
            dictionaryOfAllElements = DictionaryManager.getAllElementsInDictinoary()
            base = ElementManager.Base()
            arrayOfAllElements = ElementManager.getAllElementsFromBase(base)
        }
        else{
            print("Base Hasnt updated")
        }
    }
    
    
    
    
    /*  ******************************************
    
        L A Y O U T S
    
    ******************************************
    */
    
    
    
    
    override func viewDidAppear(animated: Bool) {
        tahjee2VideoPlayer = VideoPlayer(name: tahjee2VideoName, withFrame: videoContainer.frame)
        self.view.addSubview(tahjee2VideoPlayer!)
        tahjee2VideoPlayer?.play()
        
        
        prepareCorrectionImage()
        self.view.addSubview(correctionImage)
    }
    
    
    
    
    
    /*  ******************************************
    
    ACTION :    IMAGE PRESSED
    
    when The Image is preessed shows true or false , checks mastered , go to next question
    
    ******************************************
    */
    
    
    @IBAction func imagePressed(sender: UIButton)
    {
        prepareCorrectionImage()
        
        // Disabling all buttons when touch
        gameType != GameType.Free ? enableButtons(false) : enableButtons(true)
        /*
        ••••••••••••••••••••••••••••••••
        Right Answer
        ••••••••••••••••••••••••••••••••
        */
        
        if sender.tag == rightAnswerIndex + 1
        {
            rightAnsweredTimes++ // Aug 29 counting right answer for summary sheet
            
            correctionImage.image = UIImage(named: "rightImage")
            correctionImage.hidden = false

            rightAnswerElement?.answeredTimes?++
            self.checkMaster(rightAnswerElement!)
            
            /// Show Tick
            
            self.showCorrectionImage(sender,answered: true)
        }
        
        
        /*
        ••••••••••••••••••••••••••••••••
        Wrong Answer
        ••••••••••••••••••••••••••••••••
        */
        if (!(sender.tag == rightAnswerIndex + 1)) {
            
            correctionImage.image = UIImage(named: "falseImage")
            correctionImage.hidden = false
            
            self.showCorrectionImage(sender, answered: false)
            
            //  println("Right Answer has index : \(rightAnswerIndex+1)")
            let button = self.view.viewWithTag(rightAnswerIndex+1) as! UIButton
            
            shakeRightAnswer(button)
            
        }
        
        
    }
    
    
    @IBAction func reply(sender:UIButton){
        
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.blurView.alpha = 0.0
            self.resultView.alpha = 0.0
            }) { (f:Bool) -> Void in
                self.blurView.hidden = true
                self.resultView.hidden = true
        }
        rightAnsweredTimes = 0
        gameCount = 0
        play()
    }
    
    @IBAction func backButtonTapped(sender: UIButton)
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    
    /*
    SHUFFLE FUNCTION : is a function that inputs an array , and it shuffled it , so we get array of random numbers unrepeatidly
    
    */
    
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let toMasterId = "toMastered"
        if segue.identifier == toMasterId{
            let vc : MasteredWordVCViewController = segue.destinationViewController as! MasteredWordVCViewController

        }
        else if segue.identifier == "fromQuizToCategories"  {
            let vc : CategoriesVC = segue.destinationViewController as! CategoriesVC
            vc.masterMode = true
        }
        
        
        
        
    }
 }
 


 
 /*
 
 The Game
 PLay fucntion (whole game)/ showing shuffleing questions in random ways
 */
 extension QuizVC{

    func play(){
        
        enableButtons(true)
        self.gameCount++
        
        // Array that includes dictionaries of 4 elements only i.e [أسد,طاووس,نمر ,جمل] will shown on buttons
        var randomElementsForChoices  : [ElementManager.Element] = []
        // get shuffled random numbers in an array for the buttons  , ar : is an array contains numbers from 0 to 3
        var randomNumbersArray  = [Int]()
        // var shuffledElements  = shuffle(allElementsOfCategories ,size:  allElementsOfCategories.count)
        var _shuffledElements = arrayOfAllElements.shuffle()

        
        for var k = 0 ; k < 4 ; k++ {
            randomNumbersArray.append(k)
        }

        
        var shuffledNumbers  = randomNumbersArray.shuffle()
        
        
        for (var i = 0 ; i < 4 ; i++)
        {
            let randomNum = shuffledNumbers[i]
            randomElementsForChoices.append(_shuffledElements[randomNum]) // OMsilala
        }
        
        for (var j=0 ; j < arrayOfAllElements.count ; j++){
            // counting j
        }
        
        
        
        // showing images in the buttons randomly
        
        for (var i=0 ; i<4 ; i++){
            
            let j : Int = shuffledNumbers[i] // <- should be a random number  generator
            
            let elementImage : UIButton = (elementsImages[j])
            // chnaged to set image from set
            elementImage.setBackgroundImage(UIImage(named:randomElementsForChoices[j].imageName!), forState: UIControlState.Normal)
            elementImage.tag = j+1 // set the tag to the random number
            // when the first random number is generated , let this be the right answer , its index is not 0 , it is random number
            // for example let's say the computer generated 2,3,1,0 , ( rightAnswerIndex = 2 )
            if i==0 {
                rightAnswerIndex = j
            }
        }
        
        // the Answered Element
        rightAnswerKey = randomElementsForChoices[rightAnswerIndex].name!
        // rightAnswerElement = dictionaryOfAllElements[rightAnswerKey]//
        rightAnswerElement = base[rightAnswerKey]
        
        
        //        println(rightAnswerElement)
        
        if let SIVideoOfElementInDictionary : String = rightAnswerElement?.videoName
        {   tahjee2VideoName = SIVideoOfElementInDictionary }
        
        
        
        
        tahjee2VideoPlayer?.videoName = tahjee2VideoName
        tahjee2VideoPlayer?.repeatVideo()
    }
    
    
 }