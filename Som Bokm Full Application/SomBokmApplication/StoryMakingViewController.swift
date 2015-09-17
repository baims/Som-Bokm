//
//  ViewController.swift
//  StoryTelling
//
//  Created by Bader Alrshaid on 7/16/15.
//  Copyright (c) 2015 Bader Alrshaid. All rights reserved.
//

import UIKit
import RealmSwift

class StoryMakingViewController: UIViewController {
    
    var orderOfSceneInStory : Int!    // to get the right scene and show it ( or save it )
    var dateOfStory         : NSDate! // needed for Story.realm
    var videoUrl            : NSURL?  // needed for Scene.realm - videoURL
    var typeOfRealmString   : String! // needed to adjust the views depending on the type ( telling/reading/completing ) - it has one of these three values: "Telling", "Reading" or "Completing"
    var typeOfRealm         : Object!
    var adminMode           : Bool = false
    var buttonSenderTag     : Int  = 0

    @IBOutlet weak var storyLabel: UILabel!
    @IBOutlet weak var typeStoryContainerView: UIView!
    @IBOutlet weak var videoRecordingContainerView: UIView!
    @IBOutlet weak var searchContainerView: UIView!
    @IBOutlet weak var adminTypeStoryContainerView: UIView!
    @IBOutlet weak var elementsScrollView: ElementsScrollView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var elementsBackgroundImageView: UIImageView!
    @IBOutlet weak var editStoryButton: UIButton!
    @IBOutlet weak var editBackgroundButton: UIButton!
    @IBOutlet weak var nextSceneButton: UIButton!
    @IBOutlet weak var backSceneButton: UIButton!
    @IBOutlet weak var videoButton: UIButton!
    @IBOutlet var searchView: UIView!
    
    var typeStoryViewController      : TypeStoryViewController!
    var videoRecordingViewController : VideoRecordingViewController!
    var adminTypeStoryViewController : TypeReadingStoryViewController!
    var searchViewController         : SearchVC!
    /*
        Omar  For Search View hiding and showing 
    */
    var searchViewFrameOn    :  CGRect!
    var searchViewFrameOff   :  CGRect!
    
    var viewIsLoaded = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.navigationController!.navigationBar.hidden = true
        
        self.elementsScrollView.addElements()
        
        self.backgroundImageView.image?.accessibilityIdentifier = "parkLandscapeBG"
        /*
        ••• O m a r
        
        */
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "setTextOfButtonPressed:", name: "setTextOfButtonPressed", object: nil)
        
          NSNotificationCenter.defaultCenter().addObserver(self, selector: "hideSearchView:", name: "hideSearchView", object: nil)
        
         NSNotificationCenter.defaultCenter().addObserver(self, selector: "showSearchView:", name: "showSearchView", object: nil)
    }
    
    override func viewDidLayoutSubviews()
    {
        if viewIsLoaded == false
        {
            viewIsLoaded = true
            
            if orderOfSceneInStory == 1
            {
                self.backSceneButton.hidden = true
            }
            
            self.checkIfSceneIsSaved()
        }
        
        /*
        Omar Search showing and hiding seting frames
        */
        
        searchViewFrameOn   = searchView.frame
        
        searchView.frame.origin.x = self.view.frame.size.width
        var dif = searchView.frame.origin.x - searchViewFrameOn.origin.x
        searchViewFrameOff = searchView.frame
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "TypeStory"
        {
            typeStoryViewController = segue.destinationViewController as! TypeStoryViewController
            
            typeStoryViewController.story = self.storyLabel.text
        }
        
        else if segue.identifier == "VideoRecording"
        {
            videoRecordingViewController = segue.destinationViewController as! VideoRecordingViewController
            
            videoRecordingViewController.nameOfFile = NSDateFormatter.localizedStringFromDate(NSDate(), dateStyle: .MediumStyle, timeStyle: .ShortStyle)
        }
            
        else if segue.identifier == "AdminTypeStory"
        {
            adminTypeStoryViewController = segue.destinationViewController as! TypeReadingStoryViewController
            adminTypeStoryViewController.adminMode = self.adminMode
        }
            
        else if segue.identifier == "Search"
        {
            searchViewController = segue.destinationViewController as! SearchVC
            searchViewController.storyTellingMode = true
        }
        
        else if segue.identifier == "NextScene"
        {
            self.saveSceneToRealm()
            
            let vc = segue.destinationViewController as! StoryMakingViewController
            vc.orderOfSceneInStory = self.orderOfSceneInStory + 1
            vc.dateOfStory         = self.dateOfStory
            vc.typeOfRealmString   = self.typeOfRealmString
            vc.adminMode           = self.adminMode
        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        if identifier == "NextScene"
        {
            if self.storyLabel.text?.isEmpty == true && self.videoUrl == nil
            {
                let alertView = UIAlertView(title: "اكتب القصة او صورها", message: "يجب عليك كتابة القصة او تسجيلها اولا", delegate: nil, cancelButtonTitle: "حسناً")
                alertView.show()
                
                return false
            }
        }
        
        return true
    }
    
    
    func enableUserInteractionsForAllElements(enable : Bool)
    {
        // disabling/enabling user intercations with elements ( so he can't drag them )
        for element in self.elementsScrollView.elementsOnscreen
        {
            element.userInteractionEnabled = enable
        }
        
        self.elementsScrollView.userInteractionEnabled = enable
    }

    
    @IBAction func typeButtonTapped(sender: UIButton) {
        self.showTypeStoryContainerView()
    }
    
    
    @IBAction func videoButtonTapped(sender: UIButton) {
        self.showVideoRecordingContainerView()
    }
    
    @IBAction func homeButtonTapped(sender: AnyObject) {
//        var save = false
//        
//        if self.storyLabel!.text != "" || self.videoUrl != nil || self.elementsScrollView.elementsOnscreen.count > 0
//        {
//            save = true
//        }
//        
//        self.showExitAlertView(home: true, back: false, saving: save)
        
        if (self.storyLabel!.text != "" || self.videoUrl != nil || self.elementsScrollView.elementsOnscreen.count > 0) && self.typeOfRealmString != "Reading"
        {
            self.showExitAlertView(home: false, back: true)
        }
        else
        {
            self.popToHome()
        }
    }
    
    @IBAction func backButtonTapped(sender: UIButton) {
//        var save = false
//        
//        if self.storyLabel!.text != "" || self.videoUrl != nil || self.elementsScrollView.elementsOnscreen.count > 0
//        {
//            save = true
//        }
//        
//        self.showExitAlertView(home: false, back: true, saving: save)
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    func showExitAlertView(#home: Bool, back: Bool)
    {
//        let homeOrBackString = home == true ? "الخروج" : "الرجوع"
//        let messageString    = saving == true ? "هل تريد حفظ هذه القصة قبل \(homeOrBackString) ؟" : "هل انت متأكد من \(homeOrBackString)"
//        let exitString       = saving == true ? "عدم حفظ القصة" : "نعم"
//    
//        
//        let alertViewController = UIAlertController(title: "تأكيد", message: messageString, preferredStyle: UIAlertControllerStyle.Alert)
//        
//        let saveAndExitAction = UIAlertAction(title: "\(homeOrBackString) مع حفظ القصة", style: UIAlertActionStyle.Default)
//            { (action) -> Void in
//                
//                self.saveSceneToRealm()
//                self.navigationController?.popToRootViewControllerAnimated(true)
//        }
//
//        let exitAction = UIAlertAction(title: exitString, style: UIAlertActionStyle.Default)
//            { (action) -> Void in
//                
//                self.navigationController?.popToRootViewControllerAnimated(true)
//        }
//        
//        let cancelAction = UIAlertAction(title: "عدم \(homeOrBackString)", style: UIAlertActionStyle.Cancel, handler: nil)
//        
//        
//        if saving == true
//        {
//            alertViewController.addAction(saveAndExitAction)
//        }
//        alertViewController.addAction(exitAction)
//        alertViewController.addAction(cancelAction)
//        
//        self.presentViewController(alertViewController, animated: true, completion: nil)
        
        let alertController = UIAlertController(title: "تأكيد", message: "هل انت متأكد من الخروج ؟", preferredStyle: UIAlertControllerStyle.Alert)
        
        let cancelAction = UIAlertAction(title: "لا", style: UIAlertActionStyle.Cancel, handler: nil)
        
        let exitAction = UIAlertAction(title: "نعم", style: UIAlertActionStyle.Default)
            { (action) -> Void in
                
                self.saveSceneToRealm()
                if home == true
                {
                    self.popToHome()
                }
                else if back == true
                {
                    self.popToHome()
                }
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(exitAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func popToHome()
    {
        if self.adminMode == true
        {
            self.navigationController?.popToViewController(self.navigationController!.viewControllers[2] as! UIViewController, animated: true)
        }
        else if self.typeOfRealmString == "Reading" || self.typeOfRealmString == "Completing"
        {
            self.navigationController?.popToViewController(self.navigationController!.viewControllers[1] as! UIViewController, animated: true)
        }
        else
        {
            self.navigationController?.popToRootViewControllerAnimated(true)
        }
    }
}


// TypeStoryContainerView extensions
extension StoryMakingViewController
{
    func showTypeStoryContainerView()
    {
        self.enableUserInteractionsForAllElements(false)
        
        // un-hiding ( animating ) the typeStoryViewController & making it on top of everything
        self.typeStoryContainerView.hidden = false
        self.view.bringSubviewToFront(self.typeStoryContainerView)
        
        // to display the keyboard
        typeStoryViewController.textView.becomeFirstResponder()
    }
    
    // making the opposite of the previous func
    func hideTypeStoryContainerView()
    {
        self.enableUserInteractionsForAllElements(true)
        
        self.typeStoryContainerView.hidden = true
        
        typeStoryViewController.textView.resignFirstResponder() // to hide the keyboard
        
        if self.storyLabel.text != ""
        {
            self.editStoryButton.setImage(UIImage(named: "edit icon - highlighted"), forState: UIControlState.Normal)
        }
        else
        {
            self.editStoryButton.setImage(UIImage(named: "edit icon"), forState: UIControlState.Normal)
        }
    }
}

// VideoRecordingContainerView extensions
extension StoryMakingViewController
{
    func showVideoRecordingContainerView()
    {
        self.enableUserInteractionsForAllElements(false)
        
        self.videoRecordingViewController.camera.start()
        
        if let url = self.videoUrl
        {
            self.videoRecordingViewController.showVideoPreview(url)
        }
    
        self.view.bringSubviewToFront(self.videoRecordingContainerView)
        self.videoRecordingContainerView.hidden = false
    }
    
    func hideVideoRecordingContainerView()
    {
        self.enableUserInteractionsForAllElements(true)
        
        
        self.videoRecordingContainerView.hidden = true
        self.videoRecordingViewController.camera.stop()
    }
    
    func videoHasBeenRecorded(url : NSURL)
    {
        self.videoUrl = url
        
        self.videoButton.setImage(UIImage(named: "video icon - highlighted"), forState: UIControlState.Normal)
    }
}

// AdminTypeReadingStoryViewController extensions
extension StoryMakingViewController
{
    
    // O P E N i n g
    func showSearchView(){
        NSNotificationCenter.defaultCenter().postNotificationName("showKeyboard", object: nil)
        UIView.animateKeyframesWithDuration(0.3, delay: 0.0, options: UIViewKeyframeAnimationOptions.BeginFromCurrentState, animations: { () -> Void in
            
            self.searchView.frame  = self.searchViewFrameOn
            
            }, completion: nil)
        
    }
    
    // C L O S I N G
    func hideSearchView(notification: NSNotification?){
        NSNotificationCenter.defaultCenter().postNotificationName("hideKeyboard", object:nil )
        
        UIView.animateKeyframesWithDuration(0.3, delay: 0.0, options: UIViewKeyframeAnimationOptions.BeginFromCurrentState, animations: { () -> Void in
            
            self.searchView.frame       = self.searchViewFrameOff
            //          self.searchButton.transform = CGAffineTransformRotate(self.searchButton.transform, CGFloat(M_PI/2.0))
            
            
            
            }, completion: nil)
        
    }
    
    func setTextOfButtonPressed(notification: NSNotification){
        let text = notification.object as! String
        println("button pressed has value : \(text)")
        wordIsSelectedFromSearchVC(text)
        
    }
    
    func changeStoryReadingWord(button : UIButton)
    {
        /*** OMAR ***/
        /*** for adminMode = true ***/
        
        // show searchVC
        // send searchVC 'textOfButton'
        // the search bar in searchVC should have the same text as 'textOfButton'
        
        

      
    }
    
    // searchVC will send the new word's dictionary to this function
    func wordIsSelectedFromSearchVC(englishName : String!)
    {
        adminTypeStoryViewController.changeWordButton(englishName, index: nil)
    }
    
    /*** for adminMode == false ***/
    // show the video ?? /*** OMAR ***/
    
// rename thue function and set all the right values
    func showVideo(){
        let elementName = ""
        let element = ElementManager.Base()[elementName]
        let frame = CGRectMake(0, 0, 2, 100) // Change the frame of course
        let videoPlayer = VideoPlayer(name: element.videoName, withFrame: frame)
        self.view.addSubview(videoPlayer.view)
        
    }
}

// Realm stuff
extension StoryMakingViewController
{
    func saveSceneToRealm()
    {
        let realm = Realm()
        
        /*** Story Telling ***/
        var storyTelling = StoryTelling()

        
        let predicate = NSPredicate(format: "date = %@", self.dateOfStory) // dateOfStory checking predicate
        
        
        if realm.objects(StoryTelling).filter(predicate).count == 0 // it's a new story - not editing an old story
        {
            storyTelling.date = self.dateOfStory
            
            switch self.typeOfRealmString
            {
                case "Telling":
                    storyTelling.telling    = true
                
                case "Reading":
                    storyTelling.reading    = true
                
                case "Completing":
                    storyTelling.completing = true
                
                default:
                    break
            }
        }
        else // editing an old story or adding new scenes to a story
        {
            storyTelling = realm.objects(StoryTelling).filter(predicate).first!
        }
        
        
        /*** Scene ***/
        for scene in storyTelling.scenes
        {
            if scene.order == self.orderOfSceneInStory
            {
                if scene.isEditable == false && self.adminMode == true // We don't want to override the current scene of reading/completing story unless we are in Admin Mode
                {
                    realm.write {
                        realm.delete(scene)
                    }
                }
                else // if we're not in admin mode AND this scene is NOT editable, then we don't need to override it
                {
                    return
                }
                
                break
            }
        }
        
        var scene = Scene()
        
        scene.order = self.orderOfSceneInStory
        scene.backgroundImageName = self.backgroundImageView.image?.accessibilityIdentifier
        
        /** making the scene editable or not editable **/
        if (self.typeOfRealmString == "Reading" || self.typeOfRealmString == "Completing") && self.adminMode == true
        {
            scene.isEditable = false
        }
        else
        {
            scene.isEditable = true
        }
    
        /** getting the story and video url of the scene **/
        if let story = self.storyLabel.text
        {
            scene.story = story
        }
        else
        {
            scene.story = nil
        }
        
        if let url = self.videoUrl
        {
            scene.videoUrl = "\(url)"
        }
        else
        {
            scene.videoUrl = ""
        }
        

        
        /*** Element ***/
        for elementOnScreen in self.elementsScrollView.elementsOnscreen
        {
            var element = Element()
            element.positionX = Float(elementOnScreen.frame.origin.x)
            element.positionY = Float(elementOnScreen.frame.origin.y)
            element.imageName = elementOnScreen.image!.accessibilityIdentifier
            
            scene.elements.append(element) // adding every Element to Scene
        }
        
        
        /*** StoryReadingWord ***/
        if ( self.typeOfRealmString == "Reading" || self.typeOfRealmString == "Completing" ) && self.adminMode == true
        {
            for word in self.adminTypeStoryViewController.arrayOfButtons
            {
                if let englishName = (word as! StoryReadingWordButton).englishName
                {
                    var storyReadingWord = StoryReadingWord()
                    storyReadingWord.englishName = englishName
                    storyReadingWord.order       = self.adminTypeStoryViewController.arrayOfButtons.indexOfObject(word)
                    
                    scene.words.append(storyReadingWord)
                }
            }
        }
        
        
        // writing to realm
        realm.write {
            storyTelling.scenes.append(scene)
            
            if realm.objects(StoryTelling).filter(predicate).count == 0 // it's a new story - not editing an old story
            {
                realm.add(storyTelling)
            }
        }
    }
    
    
    func checkIfSceneIsSaved()
    {
        let realm = Realm()
        
        let predicate = NSPredicate(format: "date = %@", self.dateOfStory) // dateOfStory checking predicate
        
        
        if realm.objects(StoryTelling).filter(predicate).count == 1 // saved story
        {
            var storyTelling = realm.objects(StoryTelling).filter(predicate).first!
            
            
            for scene in storyTelling.scenes
            {
                if scene.order == self.orderOfSceneInStory
                {
                    self.showSavedScene(scene)
                    self.removeUnnecessaryViews(scene, numberOfScenes: storyTelling.scenes.count)
                    
                    break
                }
            }
        }
    }
    
    
    func showSavedScene(scene : Scene)
    {
        
        /** showing the words in Reading/Completing story **/
        if scene.words.count > 0
        {
            self.storyLabel.hidden = true
            self.adminTypeStoryContainerView.hidden = false
            
            for word in scene.words
            {
                self.adminTypeStoryViewController.changeWordButton(word.englishName, index: word.order)
            }
        }
        
        // add everything to screen
        self.backgroundImageView.image = UIImage(named: scene.backgroundImageName)
        
        if scene.story! != ""
        {
            self.storyLabel.text = scene.story!
            
            self.editStoryButton.setImage(UIImage(named: "edit icon - highlighted"), forState: UIControlState.Normal)
        }
        
        if scene.videoUrl != ""
        {
            self.videoUrl = NSURL(string: scene.videoUrl!)
            self.videoButton.setImage(UIImage(named: "video icon - highlighted"), forState: UIControlState.Normal)
        }
        
        
        let elements = scene.elements
        
        for elementFromRealm in elements
        {
            let element = ElementImageView(image: UIImage(named: elementFromRealm.imageName))
            element.frame = CGRectMake(CGFloat(elementFromRealm.positionX), CGFloat(elementFromRealm.positionY), element.image!.size.width, element.image!.size.height)
            element.image?.accessibilityIdentifier = elementFromRealm.imageName
            
            self.view.insertSubview(element, aboveSubview: self.backgroundImageView)
            
            // add it to the array
            self.elementsScrollView.elementsOnscreen.append(element)
        }
    }
    
    
    func removeUnnecessaryViews(scene : Scene, numberOfScenes : Int)
    {
        if scene.isEditable == false && self.adminMode == false
        {
            self.editBackgroundButton.hidden        = true
            self.editStoryButton.hidden             = true
            self.elementsBackgroundImageView.hidden = true
            self.elementsScrollView.hidden          = true

            
            if scene.order == numberOfScenes && self.typeOfRealmString == "Reading"
            {
                self.nextSceneButton.hidden = true
            }
            
            if scene.videoUrl! == ""
            {
                self.videoButton.hidden = true
            }

            self.enableUserInteractionsForAllElements(false)
        }
    }
}