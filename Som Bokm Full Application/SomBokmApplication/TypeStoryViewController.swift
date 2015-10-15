//
//  TypeStoryViewController.swift
//  StoryTelling
//
//  Created by Bader Alrshaid on 7/21/15.
//  Copyright (c) 2015 Bader Alrshaid. All rights reserved.
//

import UIKit

class TypeStoryViewController: UIViewController {

    var story : String!
    
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.textView.text = story
    }
    
    @IBAction func submitStory(sender: UIButton) {
        let superview = self.parentViewController as! StoryMakingViewController
        
        superview.storyLabel.text = self.textView.text
        superview.storyLabel.sizeToFit()
        superview.hideTypeStoryContainerView()
    }
}
