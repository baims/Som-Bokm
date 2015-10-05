//
//  AdminViewController.swift
//  SomBokmApplication
//
//  Created by Bader Alrshaid on 8/20/15.
//  Copyright (c) 2015 Baims. All rights reserved.
//

import UIKit

class AdminViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonTapped(sender: UIButton)
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "StoryTelling"
        {
            let vc = segue.destinationViewController as! SavedStoriesCollectionViewController
            vc.typeOfRealmString = "Telling"
            vc.adminMode         = true
        }
        else if segue.identifier == "StoryReading"
        {
            let vc = segue.destinationViewController as! SavedStoriesCollectionViewController
            vc.typeOfRealmString = "Reading"
            vc.adminMode         = true
        }
        else if segue.identifier == "StoryCompleting"
        {
            let vc = segue.destinationViewController as! SavedStoriesCollectionViewController
            vc.typeOfRealmString = "Completing"
            vc.adminMode         = true
        }
        else if segue.identifier == "fromAdminToCategories"
        {
            let vc = segue.destinationViewController as! CategoriesVC
            vc.masterMode = true
        }
    }
}
