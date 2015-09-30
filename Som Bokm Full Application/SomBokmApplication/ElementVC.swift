//
//  ElementVC.swift
//  QamosSomBokm
//
//  Created by Omar on 6/26/15.
//  Copyright (c) 2015 Baims. All rights reserved.
//

/*

This class shows the element that was chosen by the user such as lion or Ahmad and it shows the following

* Element Picture
* Element Name
* Element Description
* Element video word expression
* Element video word alphabitacallly
* sounds for tapping
* Animation for the transition  between th ealphabitacllay and expression


** This VC is taking time for unknonw reason to load , it should be fixed
*/

import UIKit
import MediaPlayer

class ElementVC: UIViewController {
    
    var element : ElementManager.Element?
    //    var dictionaryName    = String()
    
    @IBOutlet weak var elementNameLabel : UILabel!
    @IBOutlet weak var elementImage     : UIImageView!
    @IBOutlet weak var captionLabel     : UILabel!
    
    var elementCaption    : String?
    var elementName       : String?
    var elementImageFrame : CGRect! // the first frame of the element image to check if it did move
    
    var elementInItsPosition   = true
    var tahjee2InItsPosition   = false
    var spellingInItsPosition  = false
    var elementHasTahjee2Video = false
    
    var tahjee2VideoPlayer : VideoPlayer?
    var tahjee2VideoName   : String?
    var tahjee2Frame       = CGRect()
    
    
    var spellingVideoPlayer : AlphabitAnimator!
    var spellingVideoFrame  = CGRect()
    
    
    var lettersVideoPlayer : AlphabitAnimator!
    var lettersVideoFrame  = CGRect()
    
    
    
    
    
    
    @IBAction func spellingShow(sender: AnyObject) {
        
        spellingVideoPlayer.play()
        lettersVideoPlayer.play()
        
        UIView.animateWithDuration(0.4, delay: 0.0,options: UIViewAnimationOptions.BeginFromCurrentState, animations: { () -> Void in
            
            self.elementImage.transform = CGAffineTransformMakeTranslation(300, 0)
            self.spellingVideoPlayer.transform = CGAffineTransformMakeTranslation(450, 0)
            self.lettersVideoPlayer.frame.origin.x = self.elementImageFrame.origin.x
            
            self.elementInItsPosition = false
            self.tahjee2VideoPlayer!.transform = CGAffineTransformMakeTranslation(410, 0)
            
            }, completion: nil)
        
        
    }
    
    
    
    @IBAction func tahjee2Show(sender: AnyObject) {
        
        tahjee2VideoPlayer!.play()
        
        if  elementHasTahjee2Video{
            print(elementHasTahjee2Video)
            
            
            
            UIView.animateWithDuration(0.4, delay: 0.0, options:[.BeginFromCurrentState, .CurveEaseInOut], animations: { () -> Void in
                
                self.elementImage.transform = CGAffineTransformMakeTranslation(-300, 0)
                self.tahjee2VideoPlayer!.transform = CGAffineTransformMakeTranslation(-410, 0)
                self.elementInItsPosition = false
                
                self.spellingVideoPlayer.transform = CGAffineTransformMakeTranslation(-450, 0)
                self.lettersVideoPlayer.frame.origin.x = self.spellingVideoFrame.origin.x - CGFloat(150.0)
                
                }, completion: nil)
            }
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareItemsInDictionary()
    }
    
    override func viewWillLayoutSubviews() {
        let bgImageView = UIImageView(image: UIImage(named: "parkLandscapeBG"))
        bgImageView.contentMode = .ScaleAspectFit
        bgImageView.frame = self.view.frame
        self.view.addSubview(bgImageView)
        self.view.sendSubviewToBack(bgImageView)
    }
    override func viewDidAppear(animated: Bool) {
        
        tahjee2Frame = elementImage.frame
        tahjee2Frame.origin.x = self.view.frame.size.width + 50.0
        tahjee2VideoPlayer = VideoPlayer(name: tahjee2VideoName, withFrame: tahjee2Frame)
        self.view.addSubview(tahjee2VideoPlayer!)
        
        spellingVideoFrame = elementImage.frame
        spellingVideoFrame.origin.x =  -400.0
        
        lettersVideoFrame = elementImage.frame
        lettersVideoFrame.origin.x =  -200
        
        
        if let spellingVideoPlayerCopy = spellingVideoPlayer{
            spellingVideoPlayerCopy.frame = spellingVideoFrame
        }
        self.view.addSubview(spellingVideoPlayer)
        
        if let lettersVideoPlayerCopy = lettersVideoPlayer{
            lettersVideoPlayerCopy.frame = lettersVideoFrame
        }
        self.view.addSubview(lettersVideoPlayer)
        
        //        spellingVideoPlayer.wordOfElement = "عمر"
        
        elementImageFrame = elementImage.frame
        
    }
    
    
    
    
    func prepareItemsInDictionary(){
        //** ELement Image
        elementImage.image = element?.image

        elementCaption = element?.caption
        

        tahjee2VideoName = element?.videoName

        if let nameOfElementInDictionary : String = element?.arName != nil ? element?.arName! : element?.name! {
            elementName = nameOfElementInDictionary
            
            //here we change the word with respect of the name of the images of the hands
            spellingVideoPlayer     = AlphabitAnimator(word: nameOfElementInDictionary)
            lettersVideoPlayer      = AlphabitAnimator(word: nameOfElementInDictionary)
            
            spellingVideoPlayer.suffix = "SI"
            lettersVideoPlayer.suffix  = "a"
            elementNameLabel.text   = nameOfElementInDictionary
            
            print("THE NAME OF THE ELEMENT IS \(nameOfElementInDictionary)")
        }
        else{
            elementName = element?.name!
        }
        
        // Get the tahjee2 Video from the bundle
        if let tahjee2vidName : String? = NSBundle.mainBundle().pathForResource(tahjee2VideoName, ofType: "mp4"){
            print(tahjee2VideoName)
            if tahjee2vidName != nil{
                elementHasTahjee2Video = true
                print("\n\n\n********\n\n\nDoes have a video\n\n\(tahjee2vidName)")
                
            }  else{
                elementHasTahjee2Video = false
                print("\n\n\n********\n\n\nDoesnt have a video\n\n\n*********\n\n\n")
            }
            
        }
        //CAPTION
        
        if let caption : String? = element?.caption
        {
            captionLabel.text = caption
        }
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        
        spellingVideoPlayer.frame.origin.x = 1000
        lettersVideoPlayer.frame.origin.x = 1000
        
    }
    
    
    
    @IBAction func backButtonTapped(sender: UIButton)
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
}
