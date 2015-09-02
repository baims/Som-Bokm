//
//  ImageAnimator.swift
//  alphabitic
//
//  Created by Omar on 6/27/15.
//  Copyright (c) 2015 Baims. All rights reserved.
//

import UIKit

class AlphabitAnimator: UIImageView {
    
    var animationImage = UIImage()
    var wordOfElement : String!
    var suffix : String?
    init(word: String){
        super.init(image: UIImage(CGImage: nil))
        wordOfElement = word
        suffix = ""
        self.contentMode = UIViewContentMode.ScaleAspectFit
        
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentMode = UIViewContentMode.ScaleAspectFit
    }
    
    //Function animates the input word images
    func animateImageAlphabitacally(word:String!){
        
        var count = 0.0
        var images = [UIImage]()
        
        for c in word {
            println(c)
            count++
            
            
            
            
            let imageName = "\(c)" + suffix!  + ".png"
            if let imageOfAlphabatic = UIImage(named: imageName){
                images.append(imageOfAlphabatic)
                
            }
        }
        
        
        
        self.animationImages = images
        let durationOfCounter = 1.0 * count
        self.animationDuration = NSTimeInterval(durationOfCounter)
        self.animationRepeatCount = -1
        
        self.startAnimating()
        
        
        
        
        
    }
    
    func play(){
        animateImageAlphabitacally(wordOfElement)
    }
    
    
    
}
