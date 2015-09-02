//
//  ElementsScrollView.swift
//  StoryTelling
//
//  Created by Bader Alrshaid on 7/21/15.
//  Copyright (c) 2015 Bader Alrshaid. All rights reserved.
//

import UIKit

class ElementsScrollView: UIScrollView {
    
    let numberOfElements = 12
    let heightOfElement  = 90
    let widthOfElement   = 66
    
    var elementsOnscreen = [ElementImageView]()
    
    var elementsImageName = ["boyElement", "girlElement", "boyElement", "girlElement", "boyElement", "girlElement", "boyElement", "girlElement", "boyElement", "girlElement", "boyElement", "girlElement"]

    func addElements()
    {
        let heightOfContentSize = CGFloat( numberOfElements*heightOfElement + (heightOfElement/3)*(numberOfElements+1) )
        self.contentSize = CGSizeMake(116, heightOfContentSize)
        
        for i in 0..<elementsImageName.count
        {
            let yPosition = (heightOfElement/3)*(i+1) + (heightOfElement*(i))
            
            let elementButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
            elementButton.frame = CGRectMake(29, CGFloat(yPosition), CGFloat(widthOfElement), CGFloat(heightOfElement))
            elementButton.center.x = self.contentSize.width/2
            elementButton.addTarget(self, action: "elementTapped:", forControlEvents: UIControlEvents.TouchUpInside)
            elementButton.imageView?.contentMode = .ScaleAspectFit
            
            elementButton.setImage(UIImage(named: elementsImageName[i]), forState: UIControlState.Normal)
            elementButton.accessibilityIdentifier = elementsImageName[i]

            self.addSubview(elementButton)
        }
    }
    
    func elementTapped(sender : UIButton)
    {
        let superView = self.superview!
        let image     = sender.imageForState(.Normal)! // getting the image of the button
        let element   = ElementImageView(image: image)
        
        element.frame.size = CGSizeMake(image.size.width, image.size.height)
        element.center     = superView.center
        element.image?.accessibilityIdentifier = sender.accessibilityIdentifier
        
        superView.addSubview(element)

        // add it to the array
        elementsOnscreen.append(element)
    }

}
