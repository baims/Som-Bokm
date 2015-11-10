//
//  ElementsScrollView.swift
//  StoryTelling
//
//  Created by Bader Alrshaid on 7/21/15.
//  Copyright (c) 2015 Bader Alrshaid. All rights reserved.
//

import UIKit

class ElementsScrollView: UIScrollView {
    
   // let numberOfElements = 12
    let heightOfElement  = 90
    let widthOfElement   = 66
    
    var elementsOnscreen = [ElementImageView]()
    
    var elementsImageNames = ["boyElement", "girlElement","bigSisElement","boyGElement","girl1Element","boy1Element","momElement","manElement","girlGElement","womenElement","papa3oodElement","girl2Element","GrandMaElement"]
    
    
    func update(bgName : String)
    {
        self.updateElementNames(bgName)
    }
    
    func updateElementNames(bgName : String)
    {
        elementsImageNames = ["boyElement", "girlElement","bigSisElement","boyGElement","girl1Element","boy1Element","momElement","manElement","girlGElement","womenElement","papa3oodElement","girl2Element","GrandMaElement"]
        
        
        let elementsOfBackground = self.getElementsOfBackground(bgName)
        
        for backgroundElement in elementsOfBackground
        {
            elementsImageNames.append(backgroundElement)
        }
        
        
        self.resetAllElements()
    }
    
    func resetAllElements()
    {
        self.deleteElements()
        self.addElements()
    }
    
    func deleteElements()
    {
        for subview in self.subviews
        {
            subview.removeFromSuperview()
        }
    }

    func addElements()
    {
        let heightOfContentSize = CGFloat( ( elementsImageNames.count * heightOfElement ) + (heightOfElement/3) * (elementsImageNames.count+1) )
        self.contentSize = CGSizeMake(116, heightOfContentSize)
        
        for i in 0..<elementsImageNames.count
        {
            let yPosition = (heightOfElement/3)*(i+1) + (heightOfElement*(i))
            
            let elementButton = UIButton(type: .Custom)
            elementButton.frame = CGRectMake(29, CGFloat(yPosition), CGFloat(widthOfElement), CGFloat(heightOfElement))
            elementButton.center.x = self.contentSize.width/2
            elementButton.addTarget(self, action: "elementTapped:", forControlEvents: UIControlEvents.TouchUpInside)
            elementButton.imageView?.contentMode = .ScaleAspectFit
            
            elementButton.setImage(UIImage(named: elementsImageNames[i]), forState: UIControlState.Normal)
            elementButton.accessibilityIdentifier = elementsImageNames[i]

            self.addSubview(elementButton)
        }
    }
    
    
    func getElementsOfBackground(bgName : String!) -> [String]!
    {
        var elements = [String]()

        
        for i in 1...100
        {
            let fileName = bgName + "\(i)" + ".png"
            
            if let _ = UIImage(named: fileName)
            {
                elements.append(fileName)
            }
            else
            {
                break
            }
        }
        
        return elements
    }
    
    
    func elementTapped(sender : UIButton)
    {
        if let image = sender.imageForState(.Normal)
        {
            let superView = self.superview!
            let image     = image // getting the image of the button
            let element   = ElementImageView(image: image)
        
            element.frame.size = CGSizeMake(image.size.width, image.size.height)
            element.center     = superView.center
            element.image?.accessibilityIdentifier = sender.accessibilityIdentifier
        
            superView.addSubview(element)

            // add it to the array
            elementsOnscreen.append(element)
        }
    }

}
