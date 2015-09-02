//
//  DictionaryManager.swift
//  QamosSomBokm
//
//  Created by omar on 7/6/15.
//  Copyright (c) 2015 Baims. All rights reserved.
//


/*


    * This class is just a prototype for the big project 
    * it doesnt have any effect for now 
    * what this class should have : 
        - get all elements in an array and dicitonary
        - get all categories in an array  ansd dictionary
        - get all alphabits in an array and dictionary
        - convert Dictionary to NSDictionary
        - finding and searching 
        -
*/

import UIKit

class DictionaryManager: NSObject {
   
    
    internal var dictionary : Dictionary<String , NSDictionary>{
        get{
            return self.dictionary
        }
        set{
            let dic = dictionary
            self.dictionary = dic
        }
    }
    
    override init (){
        super.init()
        let path : String! = NSBundle.mainBundle().pathForResource("Dictionary", ofType: "plist")
        
        if let dicFromPlist = NSDictionary(contentsOfFile: path){
            dictionary = dicFromPlist as! Dictionary<String, NSDictionary>
        }
    }
    
    class func dictionaryFromNSDictionary(nsdictionary : NSDictionary) -> Dictionary<String , NSDictionary>{
        
        if let convertedDictionary = nsdictionary as? Dictionary<String,NSDictionary>{
        return convertedDictionary
        }
        return Dictionary(minimumCapacity: 0)
    }
    
 
    func getElementDictionary(#name : String) -> Dictionary<String,NSDictionary>{
        if let dic = dictionary[name]{
            
            return dic as! Dictionary<String, NSDictionary>
        }
        
        return dictionary
    }
    
//  ACTIVATED
    /*

    This function takes all elements from all categories and send back all of them in one Dictionary

    */
    class func getAllElementsInDictinoary() -> Dictionary<String,NSDictionary> {
        let path = NSBundle.mainBundle().pathForResource("Dictionary", ofType: "plist")
        
        var dictionaryOfAllElements : Dictionary<String,NSDictionary>= [:]
        
        if let DictionaryFromPlist : Dictionary = NSDictionary(contentsOfFile: path!) as? Dictionary<String,NSDictionary>
        {
            
            if let categories = DictionaryFromPlist["categories"] as? Dictionary<String,NSDictionary>
            {
                
                for (keyOfCategory , specificCategory) in categories
                {
                    //                    println("Dictionary Name : \(keyOfCategory) contents: \n\(specificCategory)")
                    
                    for (elementName , elementDictionary) in specificCategory
                    {
                        //                        println("Dictionary Name : \(elementName) contents: \n\(elementDictionary)")
                        
                        dictionaryOfAllElements[elementName as! String] = elementDictionary as? NSDictionary
                        
                    }
                    
                }
                
            }
            
        }
        return dictionaryOfAllElements
    }
    

}



struct element {
    
    var elementName : String = ""
    
}


//
//
//func prepareItemsInDictionary(){
//    //** ELement Image
//    
//    if let imageOfElementInDictionary : String = elementDictionary.objectForKey("image") as? String
//    {  elementImage.image = UIImage(named:imageOfElementInDictionary)}
//    
//    //** ELement Caption
//    if let captionOfElementInDictionary : String = elementDictionary.objectForKey("caption") as? String
//    {   elementCaption = captionOfElementInDictionary }
//    
//    //** ELement tahjee2 Video Name from Dictionary
//    if let SIVideoOfElementInDictionary : String = elementDictionary.objectForKey("SI_video") as? String
//    {   tahjee2VideoName = SIVideoOfElementInDictionary }
//    
//    
//    ////** alphabitaclally video Player NO NEED FOR NOW ,
//    //        WE SUBSITITUTE IT WITH THE ALPHABITACALY Class
//    //
//    //        if let SpellingVideoOfElementInDictionary : String = elementDictionary.objectForKey("spelling_video") as? String
//    //            {   spellingVideoName = SpellingVideoOfElementInDictionary }
//    
//    
//    //Element Name in ARABIC
//    
//    if let nameOfElementInDictionary : String = elementDictionary.objectForKey("name") as? String{
//        elementName = nameOfElementInDictionary
//        //here we change the word with respect of the name of the images of the hands
//        spellingVideoPlayer     = AlphabitAnimator(word: nameOfElementInDictionary)
//        lettersVideoPlayer      = AlphabitAnimator(word: nameOfElementInDictionary)
//        
//        spellingVideoPlayer.suffix = "SI"
//        lettersVideoPlayer.suffix  = "a"
//        elementNameLabel.text   = nameOfElementInDictionary
//        
//        println("THE NAME OF THE ELEMENT IS \(nameOfElementInDictionary)")
//    }
//    else{
//        elementName = dictionaryName
//    }
//    
//    // Get the tahjee2 Video from the bundle
//    if let tahjee2vidName : String? = NSBundle.mainBundle().pathForResource(tahjee2VideoName, ofType: "mp4"){
//        if tahjee2vidName != nil{
//            elementHasTahjee2Video = true
//            println("\n\n\n********\n\n\nDoes have a video\n\n\(tahjee2vidName)")
//            
//        }  else{
//            elementHasTahjee2Video = false
//            println("\n\n\n********\n\n\nDoesnt have a video\n\n\n*********\n\n\n")
//        }
//        
//    }
//    //CAPTION
//    
//    if let caption : String? = elementDictionary.objectForKey("caption") as? String
//    {
//        captionLabel.text = caption
//    }
//    
//}
//
//override func viewWillDisappear(animated: Bool) {
//    
//    
//    spellingVideoPlayer.frame.origin.x = 1000
//    lettersVideoPlayer.frame.origin.x = 1000
//    
//}
