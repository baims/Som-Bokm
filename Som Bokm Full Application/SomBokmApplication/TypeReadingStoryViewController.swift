//
//  TypeReadingStoryViewController.swift
//  SomBokmApplication
//
//  Created by Bader Alrshaid on 9/10/15.
//  Copyright (c) 2015 Baims. All rights reserved.
//

import UIKit

class TypeReadingStoryViewController: UIViewController {
    
    var adminMode = false

    @IBOutlet weak var word1Button: StoryReadingWordButton!
    @IBOutlet weak var word2Button: StoryReadingWordButton!
    @IBOutlet weak var word3Button: StoryReadingWordButton!
    @IBOutlet weak var word4Button: StoryReadingWordButton!
    @IBOutlet weak var word5Button: StoryReadingWordButton!
    
    var arrayOfButtons = NSArray()
    var buttonIndex = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        arrayOfButtons = [word1Button, word2Button, word3Button, word4Button, word5Button]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func wordButtonTapped(sender: StoryReadingWordButton)
    {
        buttonIndex = arrayOfButtons.indexOfObject(sender)
        let parentViewController = self.parentViewController as! StoryMakingViewController
        
        if adminMode == true
        {
            parentViewController.changeStoryReadingWord(sender.text)
        }
        else if adminMode == false
        {
            // do something else
            // show the video ?? /*** OMAR ***/
        }
    }
    
    // to change the text, video url and dictionary of buttons
    func changeWordButton(englishName : String!, index : Int?)
    {
        if index != nil
        {
            self.buttonIndex = index!
        }
        
        let wordButton = arrayOfButtons[self.buttonIndex] as! StoryReadingWordButton
        wordButton.englishName = englishName
        wordButton.text       = wordButton.getTextOfWord()
    }
    
    
    func removeUnnecessaryWordButtons()
    {
        if adminMode == false
        {
            for wordButton in arrayOfButtons
            {
                if (wordButton as! StoryReadingWordButton).englishName == nil
                {
                    (wordButton as! StoryReadingWordButton).hidden = true
                }
                else
                {
                    (wordButton as! StoryReadingWordButton).hidden = false
                }
            }
        }
    }
}