//
//  VideoRecordingViewController.swift
//  StoryTelling
//
//  Created by Bader Alrshaid on 7/23/15.
//  Copyright (c) 2015 Bader Alrshaid. All rights reserved.
//

import UIKit
import AVFoundation
import Darwin

class VideoRecordingViewController: UIViewController {
    
    @IBOutlet weak var snapButton: UIButton!
    @IBOutlet weak var switchCamerasButton: UIButton!
    @IBOutlet weak var cancelRecordingButton: UIButton!
    @IBOutlet weak var useRecordingButton: UIButton!
    @IBOutlet weak var retakeVideoButton: UIButton!
    
    var camera        : LLSimpleCamera!
    var avPlayer      : AVPlayer?
    var avPlayerLayer : AVPlayerLayer?
    
    var nameOfFile : String! // will be sent through parentViewController in -prepareForSegue

    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        /*** Initializing Camera ***/
        // create camera vc
        self.camera = LLSimpleCamera(quality: AVCaptureSessionPresetHigh, position: CameraPositionFront, videoEnabled: true)
        
        // attach to a view controller
        self.camera.attachToViewController(self, withFrame: self.view.frame)
        
        // you probably will want to set this to true, if you are going view the image outside iOS.
        self.camera.fixOrientationAfterCapture = true;
        
        // take the required actions on a device change
        self.camera.onDeviceChange = {
            camera, device in
            
            print("Device changed");
            
            // device changed, check if flash is available
            if self.camera.isFlashAvailable() == true
            {
                // unhide flashButton
                
                if self.camera.isFlashOn() == true
                {
                    // flashButton.selected = false
                }
                else
                {
                    // flashButton.selected = true
                }
                
            }
            else
            {
                // hide flashButton
            }
            
        }
        
        var error : NSError?
        
        self.camera.onError = {
            (camera, error : NSError?) in
            
            print("Camera error: \(error)")
            
            if error?.domain == LLSimpleCameraErrorDomain
            {
                if error?.code == 10 || error?.code == 11
                {
                    let alert = UIAlertView(title: "no permission", message: "We need permission for the camera", delegate: self, cancelButtonTitle: "Ok")
                    alert.show()
                }
            }
            
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // snap button to capture image
        self.snapButton.layer.cornerRadius = self.snapButton.frame.width / 2.0
        self.snapButton.layer.borderColor = UIColor.whiteColor().CGColor
        self.snapButton.layer.borderWidth = 2.0
        self.snapButton.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
        self.snapButton.layer.shouldRasterize = true
        
        // positioning the camera view
        self.camera.view.frame = self.view.frame
        self.camera.view.transform = CGAffineTransformMakeRotation(CGFloat(3*M_PI/2));
        
        // hiding un-needed buttons
        self.useRecordingButton.hidden = true
        self.retakeVideoButton.hidden  = true
    }
    
    
    func applicationDocumentsDirectory() -> NSURL!
    {
        return NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).last as! NSURL
    }
    
}

// Buttons
extension VideoRecordingViewController
{
    @IBAction func switchCamerasButtonTapped(sender: UIButton)
    {
        self.camera.togglePosition()
    }
    
    
    @IBAction func snapButtonTapped(sender: UIButton)
    {
        if self.camera.recording == false {
            self.switchCamerasButton.hidden   = true
            self.cancelRecordingButton.hidden = true
            
            self.snapButton.layer.borderColor = UIColor.redColor().CGColor
            self.snapButton.backgroundColor = UIColor.redColor().colorWithAlphaComponent(0.5)
            
            
            // maximum duration of recording
            self.camera.movieFileOutput.maxRecordedDuration = CMTimeMake(5, 1);
            
            // start recording
            let outputURL = self.applicationDocumentsDirectory().URLByAppendingPathComponent(nameOfFile).URLByAppendingPathExtension("mov")

            
            self.camera.startRecordingWithOutputUrl(outputURL)
        }
        else {
            self.endRecording()
        }
    }
    
    
    func endRecording()
    {
        var error : NSError?
        
        self.camera.stopRecording {
            (camera, url, error) in
            
            self.snapButton.layer.borderColor = UIColor.whiteColor().CGColor
            self.snapButton.backgroundColor   = UIColor.whiteColor().colorWithAlphaComponent(0.5)
            
            // telling the parentViewController that the video has been recorded
            let parentViewController      = self.parentViewController as! StoryMakingViewController
            parentViewController.videoHasBeenRecorded(url)
            
            
            self.showVideoPreview(url)
        }
    }
    
    func showVideoPreview(url : NSURL)
    {
        self.snapButton.hidden            = true
        self.switchCamerasButton.hidden   = true
        self.cancelRecordingButton.hidden = true
        self.retakeVideoButton.hidden     = false
        self.useRecordingButton.hidden    = false
        
        
        self.avPlayer = nil // making sure that avPlayer does NOT exist so i can initialize it again
        self.avPlayer = AVPlayer(URL: url)
        self.avPlayer?.actionAtItemEnd = .None
        
        self.avPlayerLayer = nil
        self.avPlayerLayer = AVPlayerLayer(player: self.avPlayer!)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "playerItemDidReachEnd:", name: AVPlayerItemDidPlayToEndTimeNotification, object: self.avPlayer?.currentItem)
        
        self.avPlayerLayer!.frame = self.view.frame
        self.avPlayerLayer!.transform = CATransform3DConcat(CATransform3DMakeRotation(CGFloat(M_PI/2), 0, 0, 1.0), CATransform3DMakeScale(-1.9, 1.9, 1))
        
        
        self.view.layer.insertSublayer(self.avPlayerLayer, atIndex: 1)
        self.camera.view.hidden = true
        
        self.avPlayer?.play()
    }
    
    func playerItemDidReachEnd(notification : NSNotification)
    {
        let playerItem = notification.object as! AVPlayerItem
        playerItem.seekToTime(kCMTimeZero)
    }
    
    
    // The video is actually saved but here we only hide the VideoRecordingViewController
    @IBAction func hide(sender: UIButton)
    {
        let superView = self.parentViewController as! StoryMakingViewController
        superView.hideVideoRecordingContainerView()
        
        self.snapButton.hidden            = false
        self.switchCamerasButton.hidden   = false
        self.cancelRecordingButton.hidden = false
        self.retakeVideoButton.hidden     = true
        self.useRecordingButton.hidden    = true
        
        self.camera.view.hidden = false
        
        if let avplayer = self.avPlayer
        {
            /*** Remove video preview here ***/
            self.avPlayer!.pause()
            self.avPlayerLayer!.removeFromSuperlayer()
            self.avPlayer = nil
        }
    }

    
    @IBAction func retakeVideoButtonTapped(sender: UIButton)
    {
        self.snapButton.hidden            = false
        self.switchCamerasButton.hidden   = false
        self.cancelRecordingButton.hidden = false
        self.retakeVideoButton.hidden     = true
        self.useRecordingButton.hidden    = true
        
        self.camera.view.hidden = false
        
        /*** Remove video preview here ***/
        self.avPlayer?.pause()
        self.avPlayerLayer?.removeFromSuperlayer()
    }
}