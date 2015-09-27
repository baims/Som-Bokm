//
//  Videoself.swift
//  gestureTest
//
//  Created by Omar on 6/26/15.
//  Copyright (c) 2015 Baims. All rights reserved.
//

/*
*This calss is for the video of the word in Dictionary that will display word by SL not the letters

*The initilizer takes 2 arguments , videoName and its frame

*/

import UIKit
import MediaPlayer

class VideoPlayer: MPMoviePlayerController
{
    var videoName : String?
    var repetiveVideoMode : Bool!
    func resetVideoName(videoName:String){
        self.videoName = videoName
        
        if let path = NSBundle.mainBundle().pathForResource(videoName, ofType: "mp4")
        {
            print("path is \(path)")
            let url = NSURL.fileURLWithPath(path)
            super.contentURL = url
        }
            
        else
        {
            print("No such video file with name \(videoName)")
            super.contentURL = nil

        }
    }
    
    private var videoFrame : CGRect?
    
    override init(contentURL url: NSURL!)
    {
        super.init(contentURL: url)
    }
    
    init(name : String! , withFrame frame : CGRect!)
    {
        videoFrame = frame
        videoName = name!
        repetiveVideoMode = true
        if let path = NSBundle.mainBundle().pathForResource(videoName, ofType: "mp4")
        {
            print("path is \(path)")
            let url = NSURL.fileURLWithPath(path)
                
            super.init(contentURL: url)
                
            self.view.frame = frame
            self.scalingMode = MPMovieScalingMode.Fill
            self.fullscreen = true
            self.controlStyle = MPMovieControlStyle.None
            self.movieSourceType = .File
            self.repeatMode = repetiveVideoMode==true ? .One : .None
            self.view.opaque = true
            self.view.hidden = false
            
            if repetiveVideoMode == false{
                self.repeatMode = .None
            }
        }
            
        else
        {
            super.init(contentURL: nil)
        }
    }

    func pressed(){
        replay()
    }
    
    
   

    func replay(){
        
        if repetiveVideoMode == true {
        stop()
        
        if let path = NSBundle.mainBundle().pathForResource(videoName, ofType: "mp4")
        {
            let url = NSURL.fileURLWithPath(path)
            
            self.contentURL = url
            self.stop()
            self.play()
            
        }
        }
        else{
            self.stop()

            self.view.hidden = true
        }
    }
}



