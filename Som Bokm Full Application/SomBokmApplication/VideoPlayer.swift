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
    private var videoFrame : CGRect?
    
    override init(contentURL url: NSURL!)
    {
        super.init(contentURL: url)
    }
    
    init(name : String! , withFrame frame : CGRect!)
    {
        videoFrame = frame
        videoName = name!
        
        if let path = NSBundle.mainBundle().pathForResource(videoName, ofType: "mp4")
        {
            let url = NSURL.fileURLWithPath(path)
                
            super.init(contentURL: url)
                
            self.view.frame = frame
            self.scalingMode = MPMovieScalingMode.Fill
            self.fullscreen = true
            self.controlStyle = MPMovieControlStyle.None
            self.movieSourceType = .File
            self.repeatMode = MPMovieRepeatMode.One
            self.view.opaque = true
            self.view.hidden = false
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
        stop()
        
        if let path = NSBundle.mainBundle().pathForResource(videoName, ofType: "mp4")
        {
            let url = NSURL.fileURLWithPath(path)
            
            self.contentURL = url
            self.stop()
            self.play()
            
        }
    }
}



