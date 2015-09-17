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
    let base        = ElementManager.Base()
    
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
        let arabicName = base[englishName!].arName!
        return arabicName
    }
    
    func getVideoPathOfWord() -> String!
    {
        /*** OMAR ***/
        let videoName = base[englishName!].videoName!
        return videoName
    }
    
    /*
    /*** OMAR ***/
        write other functions here so we can access everything faster
        Shno y3nee ?
    */

}
