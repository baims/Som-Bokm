//
//  VideoPlayer.swift
//  AVPlayerKit
//
//  Created by Omar Alibrahim on 9/19/15.
//  Copyright © 2015 OMSI. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class VideoPlayer: UIView, AVPlayerViewControllerDelegate {
    
    let moviePlayerController = AVPlayerViewController()
    var aPlayer = AVPlayer()
    var videoName    : String!
    var repeatEnabled : Bool? = false
    var pipEnabled    : Bool? = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)

    }

    convenience init () {
        self.init(frame:CGRectZero)
    }
    
    init(name: String!, withFrame frame: CGRect!){
        super.init(frame: frame)
        videoName   = name
        prepareForPlay()
//        self.play()
    }
    init(name: String!){
        super.init(coder: NSCoder())!
        videoName   = name
        prepareForPlay()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func prepareForPlay()
    {
        if let url = NSBundle.mainBundle().URLForResource(videoName, withExtension: "mp4") {
            aPlayer = AVPlayer(URL: url)
        }
        
        moviePlayerController.player = aPlayer
        moviePlayerController.view.frame = CGRectMake(0, 0, self.frame.width, self.frame.height)
        moviePlayerController.updateViewConstraints()
        moviePlayerController.view.sizeToFit()
        moviePlayerController.videoGravity = AVLayerVideoGravityResizeAspectFill
        moviePlayerController.showsPlaybackControls = pipEnabled!
        if #available(iOS 9.0, *) {
            moviePlayerController.delegate = self
        } else {
            // Fallback on earlier versions
        }
    
        
        self.addSubview(moviePlayerController.view)
    }
    
    func playerViewControllerShouldAutomaticallyDismissAtPictureInPictureStart(playerViewController: AVPlayerViewController) -> Bool {
        return true
    }
    func playerViewControllerWillStartPictureInPicture(playerViewController: AVPlayerViewController) {
        self.hidden = true
    }
    func playerViewControllerDidStopPictureInPicture(playerViewController: AVPlayerViewController) {
        self.hidden = false
    }
    
    
    
    func play(){

        aPlayer.play()

        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didPlayToEndTime", name: AVPlayerItemDidPlayToEndTimeNotification, object: aPlayer.currentItem)

    }
    

    func didPlayToEndTime(){
        print("didPlayToEndTime")
        repeatEnabled == true ? repeatVideo() : stop()
    }

    func repeatVideo(){
        aPlayer.seekToTime(kCMTimeZero)
        aPlayer.play()
    }
    
    func stop(){
        aPlayer.pause()
    }
    
var touchesCount = 0
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if moviePlayerController.showsPlaybackControls == false
        {
            touchesCount%2 == 0 ?     stop() : play()
           touchesCount++
            
        }
    }
    

    
}
