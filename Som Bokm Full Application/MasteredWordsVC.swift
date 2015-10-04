//
//  MasteredWordsVC.swift
//  SomBokmApplication
//
//  Created by Omar Alibrahim on 10/1/15.
//  Copyright © 2015 Baims. All rights reserved.
//

import Foundation

extension CategoriesVC : UIAlertViewDelegate{
/*
    Bader change Alert
*/
    @IBAction func clearAllWords(sender:UIButton)
    {
        let alert = UIAlertController(title: "تحذير!", message: "سيتم مسح جميع الكلمات من قائمة الكلمات المتقنة , هل أنت متأكد ؟", preferredStyle: .Alert)
        let erase = UIAlertAction(title: "امسح", style: .Cancel) { (action) -> Void in
            self.categoryArray = []
            ElementManager.resetBase()

            self.collectionView.reloadData()
        }
        let cancel = UIAlertAction(title: "cancel", style: .Default, handler: nil)
        alert.addAction(erase)
        alert.addAction(cancel)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
  
//    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
//        if buttonIndex == 0 {
//            
//            categoryArray = []
//            ElementManager.resetBase()
//            
//            collectionView.reloadData()
//            
//        }
//    }
}


extension ElementManager {
    class func getMasteredWords()->[ElementManager.Element]
    {
        var mastered : [ElementManager.Element] = []
        print("getMasteredWords { ")
        for element in self.getAllElementsFromBase()
        {
            if element.isMastered! == true{
                print("     " + element.name! + "  IS master\n")
                mastered.append(element)
            }
        }
        print("}")
        print("All mastered words are\(mastered.count)")
        return mastered
    }
}

extension ElementManager{
    class func resetBase(){
        var b = Base()
        b = prepareItemsOfDataBase()
        b.sync()
        print("**restted ")
        b.printDisprectiveDescreption()
    }
}