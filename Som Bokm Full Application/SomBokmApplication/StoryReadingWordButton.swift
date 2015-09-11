//
//  StoryReadingWordButton.swift
//  SomBokmApplication
//
//  Created by Bader Alrshaid on 9/10/15.
//  Copyright (c) 2015 Baims. All rights reserved.
//

import UIKit

class StoryReadingWordButton: UIButton {

    var englishName : String?
    
    var text : String!
        {
        get {
            return self.titleForState(.Normal)
        }
        
        set {
            self.setTitle(newValue, forState: .Normal)
        }
    }
    
    func getTextOfWord() -> String!
    {
        /*** OMAR ***/
        return ""
    }
    
    func getVideoPathOfWord() -> String!
    {
        /*** OMAR ***/
        return ""
    }
    
    /*
    /*** OMAR ***/
        write other functions here so we can access everything faster
    */

}
