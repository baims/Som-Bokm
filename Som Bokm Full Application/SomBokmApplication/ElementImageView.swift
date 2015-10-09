//
//  ElementImageView.swift
//  StoryTelling
//
//  Created by Bader Alrshaid on 7/22/15.
//  Copyright (c) 2015 Bader Alrshaid. All rights reserved.
//

import UIKit

class ElementImageView: UIImageView, UIGestureRecognizerDelegate {

    var lastLocation:CGPoint = CGPointMake(0, 0)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(image: UIImage!)
    {
        super.init(image: image)
        
        self.userInteractionEnabled = true // to allow dragging
        
        
        let pinchRecognizer  = UIPinchGestureRecognizer(target:self, action:"handlePinch:")
        let rotateRecognizer = UIRotationGestureRecognizer(target:self, action:"handleRotate:")
        let panRecognizer    = UIPanGestureRecognizer(target:self, action:"detectPan:")
        
        pinchRecognizer.delegate  = self
        rotateRecognizer.delegate = self
        panRecognizer.delegate    = self
        
        self.gestureRecognizers = [panRecognizer,pinchRecognizer,rotateRecognizer]
    }
    
    func detectPan(recognizer:UIPanGestureRecognizer) {
        let translation  = recognizer.translationInView(self.superview!)
        
        var x = lastLocation.x + translation.x
        var y = lastLocation.y + translation.y
        
        
        /*** Making sure that elements CANNOT cross the bottom bar and the left bar ***/
        if x-(self.frame.width/2) < 116
        {
            x = 116+(self.frame.width/2)
        }
        else if x+(self.frame.width/2) > self.superview!.frame.width
        {
            x = self.superview!.frame.width-(self.frame.width/2)
        }
        
        if y-(self.frame.height/2) < 0
        {
            y = self.frame.height/2
        }
        else if y+(self.frame.height/2) > self.superview!.frame.height-101
        {
            y = self.superview!.frame.height-(self.frame.height/2)-101
        }
        
        // moving the element to a new position
        self.center = CGPointMake(x, y)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // Promote the touched view
        self.superview?.bringSubviewToFront(self)
        
        // Remember original location
        lastLocation = self.center
    }
    
    func handlePinch(recognizer : UIPinchGestureRecognizer) {
        if let view = recognizer.view {
            view.transform = CGAffineTransformScale(view.transform,
                recognizer.scale, recognizer.scale)
            recognizer.scale = 1
        }
    }
    
    func handleRotate(recognizer : UIRotationGestureRecognizer) {
        if let view = recognizer.view {
            view.transform = CGAffineTransformRotate(view.transform, recognizer.rotation)
            recognizer.rotation = 0
        }
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
