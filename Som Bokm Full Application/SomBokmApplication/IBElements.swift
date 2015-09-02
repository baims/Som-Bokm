//
//  IBElements.swift
//  SomBokmApplication
//
//  Created by Omar Alibrahim on 8/30/15.
//  Copyright (c) 2015 Baims. All rights reserved.
//

import Foundation

@IBDesignable class CustomTextView : UITextView{
   
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    
    @IBInspectable var borderWidth: CGFloat{
        set {
            layer.borderWidth = newValue
        }
        get{
            return self.layer.borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        set {
            layer.borderColor = newValue?.CGColor
        }
        get{
            let c = UIColor(CGColor: layer.borderColor)
            return c
        }
    }
    
}

@IBDesignable class CustomView : UIView{
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    
    @IBInspectable var borderWidth: CGFloat{
        set {
            layer.borderWidth = newValue
        }
        get{
            return self.layer.borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        set {
            layer.borderColor = newValue?.CGColor
        }
        get{
            let c = UIColor(CGColor: layer.borderColor)
            return c
        }
    }
}