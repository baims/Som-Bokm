//
//  ElementManager.swift
//  DictionaryTest
//
//  Created by Omar Alibrahim on 8/16/15.
//  Copyright (c) 2015 OMSI. All rights reserved.
//



/*


Read ME !
what this file does ?

classes : as the flow

• E L E M E  N  T          -> ex : [lion : [lionImage,lionThumb,...]]
• C A T E G O R Y         -> ex : [animals , plants , ......]
• R   O    O    T        -> ex : [alphabit , categorization]
• B   A    S    E       -> ex : [root]

To use the base , use prepareDciota.... , it will manage all the dictionaries and arrays inside the base

THIS ELEMENT MANAGER IS TAKING DATA FROM PLIST AND SAVES THEM AS SOON AS USER OPENS THE 

*/


import Foundation
import UIKit

class ElementManager {
    
    enum ElementNameType{
        case Arabic
        case English
    }
    
    class Element : NSObject,  NSCoding
    {
        
        var name            : String? // name in English
        var arName          : String? // name in Arabic
        var categoryName    : String? // under what Category is this element ?
        var rootName        : String? // under what root is this element ?
        var caption         : String? = "" // caption (the third element in the plist )
        var isMastered      : Bool! = false // checks
        var answeredTimes   : Int?
        
        var isNil : Bool? = true
        
        var imageName : String?  {
            get{
                if let _name = name {
                    let _imageName = _name + "Dic"
                    return _imageName
                }
                return nil
            }
        }
        
        var thumbImageName : String? {
            get {
                if let _name = name
                {
                    let _thumbImageName = _name + "_thumb"
                    return _thumbImageName
                }
                return nil
            }
        }
        
        var thumbImageExists : Bool
            {
                if let _ = UIImage(named: thumbImageName!){
                    return true
                }
                return false;
            }
        
        var image : UIImage? {
            get{
                if let _image = UIImage(named: imageName!){
                    return _image
                    
                }
                return nil
            }
        }
        
        var imageExists : Bool
            {
                if let _ = UIImage(named: imageName!){
                    return true
                }
                return false;
        }
        
        var videoName : String? {
            get {
                if let _name = name
                {
                    let _videoName = _name + ""
                    return _videoName
                }
                return nil
            }
        }
        
        var videoExist : Bool {
            get {
                if let tahjee2vidName : String? = NSBundle.mainBundle().pathForResource(videoName, ofType: "mp4")
                {

                    if tahjee2vidName != nil
                    {
                        return true
                    }
                    else
                    {
                        return false
                    }
                }
            }
        }
        
        func printDescreption(){
            print(name            != nil ? " •\(name!): { "                          : "nil"         )
            print(arName          != nil ? "   arabic name    : \(arName!)"           : ""            )
            print(caption         != nil ? "   caption        : \(caption!)"          : ""            )
            print(imageName       != nil ? "   image name     : \(imageName!)"        : "doesnt exist")
            print(thumbImageName  != nil ? "   thumb name     : \(thumbImageName!)"   : "doesnt exist")
            print(videoName       != nil ? "   video name     : \(videoName!)"        : "doesnt exist")
            print(isMastered      != nil ? "   is Mastered    : \(isMastered!)"       : "doesnt exist")
            print(answeredTimes   != nil ? "   ansered times  : \(answeredTimes!)"    : "doesnt exist")
            print(categoryName    != nil ? "   category name  : \(categoryName!)"     : "doesnt exist")
            print(rootName        != nil ? "   root name      : \(rootName!)"         : "doesnt exist")
            print("}")
            
            
        }
        
        /**
        What this code does
        see the plist , if it is string , set that string to name , if it is array , let 0->name , 1-> arName . 2-> capition
        */
        init(_name:AnyObject)
        {

            isNil = false
            
            if _name is String
            {
                name = _name as? String
                arName = _name as? String
            }
            else if _name is NSArray
            {
                var arrayOfElemnt = _name as? [AnyObject]
                name = arrayOfElemnt![0] as? String
                
                if arrayOfElemnt?.count >= 2
                {
                    if let _arName = arrayOfElemnt![1] as? String
                    {
                        arName = _arName
                    }
                }
                if arrayOfElemnt?.count >= 3
                {
                    if let _caption = arrayOfElemnt![2] as? String
                    {
                        caption = _caption
                    }
                }
            }
            
            
        }
        
        
        class func getArabicNameFromEnglish(englishName:String) -> String?
        {
            return Base()[englishName].arName
        }
        
        class func getEnglishNameFromArabic(arabicName:String) -> String?
        {
            return ElementManager.searchForItemWithName(arabicName, base: Base(), nameType: ElementManager.ElementNameType.Arabic).name
        }
        
        required init(coder aDecoder: NSCoder) {
            
            self.name            = aDecoder.decodeObjectForKey("name")           as? String
            self.categoryName    = aDecoder.decodeObjectForKey("categoryName")   as? String
            self.arName          = aDecoder.decodeObjectForKey("arName")         as? String
            self.caption         = aDecoder.decodeObjectForKey("caption")        as? String
            self.isMastered      = aDecoder.decodeObjectForKey("isMastered")     as? Bool
            self.answeredTimes   = aDecoder.decodeObjectForKey("answeredTimes")  as? Int
            self.isNil           = aDecoder.decodeObjectForKey("isNil")          as? Bool
            if let answeredTimes = aDecoder.decodeObjectForKey("answeredTimes")  as? Int
            {
                self.answeredTimes = answeredTimes
            }
            else
            {
                self.answeredTimes = 0
            }
        }
        
        func encodeWithCoder(aCoder: NSCoder)
        {
            aCoder.encodeObject(name,          forKey:"name")
            aCoder.encodeObject(categoryName,  forKey:"categoryName")
            aCoder.encodeObject(arName,        forKey:"arName")
            aCoder.encodeObject(caption,       forKey:"caption")
            aCoder.encodeObject(isMastered,    forKey:"isMastered")
            aCoder.encodeObject(answeredTimes, forKey:"answeredTimes")
            aCoder.encodeObject(isNil        , forKey:"isNil")
        }
        
        override init()
        {
            isNil = true
            super.init()
            // return nil
        }
        
        
    }

    
    
    class Category : NSObject, NSCoding {
        
        var elementsArray : [Element]?
        var categoryName  : String?
        var rootName      : String?
        
        func printDescreption()
        {
            print("   \(categoryName!)  : {")
            for _element in elementsArray!
            {
                print("       \(_element.name!)")
            }
            print("   }")
        }
        
        // elements with their details
        func printDescreptionFull()
        {
            for _element in elementsArray!
            {
                _element.printDescreption()
            }
        }
        
        init(_categoryName : String , _elementsArray : [Element])
        {
            self.elementsArray = _elementsArray
            self.categoryName  = _categoryName
        }
        
        
        required init(coder aDecoder: NSCoder)
        {
            if let elementArray  = aDecoder.decodeObjectForKey("elementsArray") as? [Element] {
                self.elementsArray = elementArray
            }
            if let categoryName  = aDecoder.decodeObjectForKey("categoryName2") as? String{
                self.categoryName = categoryName
            }
            if let rootName = aDecoder.decodeObjectForKey("rootName2")     as? String
            {
                self.rootName = rootName
            }
        }
        
        func encodeWithCoder(aCoder: NSCoder)
        {
            aCoder.encodeObject(elementsArray,  forKey:"elementsArray")
            aCoder.encodeObject(categoryName,   forKey:"categoryName2")
            aCoder.encodeObject(rootName,       forKey:"rootName2")
            
        }
    }
    
    class Root: NSObject,NSCoding {
        var rootName : String?
        var categoriesArray : [Category]?
        
        func printDescreption(){
            print("\(rootName!): {")
            for category in categoriesArray!{
                category.printDescreption()
            }
            print("}")
            
            
        }
        
        func printDisprectiveDescreption(){
            print("\(rootName!): {")
            for category in categoriesArray!{
                category.printDescreptionFull()
            }
            print("}")
            
            
        }
        
        init(_categoriesArray:[Category] , _rootName:String){
            categoriesArray = _categoriesArray
            rootName        = _rootName
        }
        
        
        subscript (categoryName : String) -> Category {
            var counter = 0
            var category : Category?
            for cat in categoriesArray!{
                let name = cat.categoryName
                
                if categoryName == name{
                    // names matches ~ get index
                    category =  categoriesArray![counter]
                    
                }
                
                counter++
                
            }
            // C R A S H
            if category == nil {
                print("No such Category named \(categoryName)")
            }
            return category!
        }
        
        
        required init(coder aDecoder: NSCoder) {
            if let rootName = aDecoder.decodeObjectForKey("rootName") as? String
            {
                self.rootName = rootName
            }
            if let categoriesArray = aDecoder.decodeObjectForKey("categoriesArray") as? [Category]
            {
                self.categoriesArray = categoriesArray
            }
        }
        
        func encodeWithCoder(aCoder: NSCoder) {
            aCoder.encodeObject(rootName,  forKey:"rootName")
            aCoder.encodeObject(categoriesArray,   forKey:"categoriesArray")
            
        }
    }
    
    // ••••••••••••••••••••••••••••••••••••••
    // ••••••••••  B   A   S   E   ••••••••••
    
    class Base : NSObject, NSCoding{
        var exists      : Bool! = false
        var rootArray   : [Root]?
        
        func printDescreption()
        {
            for root in rootArray!{
                root.printDescreption()
            }
            
        }
        func printDisprectiveDescreption()
        {
            for root in rootArray!{
                root.printDisprectiveDescreption()
            }
            
        }
        
        init(_rootArray:[Root]){
            rootArray = _rootArray
        }
        
        override init(){
            super.init()
            
            if ElementManager.checkNewPlistUpdate("Dictionary_1") == false
            {
            if let data = NSUserDefaults.standardUserDefaults().objectForKey("Base") as? NSData
            {
                let unarc = NSKeyedUnarchiver(forReadingWithData: data)
                let newBase = unarc.decodeObjectForKey("root") as! Base
                self.rootArray = newBase.rootArray
            }
            }
            else
            {
                rootArray = ElementManager.prepareItemsOfDataBase().rootArray
                NSUserDefaults.standardUserDefaults().setObject(NSKeyedArchiver.archivedDataWithRootObject(self), forKey: "Base")
            }
        }
        
        
        subscript (elementName : String) -> Element{
            // searching
            let base = Base(_rootArray: rootArray!)
            
            
            return ElementManager.searchForItemWithName(elementName, base: base)
        }
        
        
        // Saving Data
        
        func sync()
        {
            
            NSUserDefaults.standardUserDefaults().setObject(NSKeyedArchiver.archivedDataWithRootObject(self), forKey: "Base")
            if let data = NSUserDefaults.standardUserDefaults().objectForKey("Base") as? NSData
            {
                let unarc = NSKeyedUnarchiver(forReadingWithData: data)
                let newBase = unarc.decodeObjectForKey("root") as! Base
                NSUserDefaults.standardUserDefaults().setObject(NSKeyedArchiver.archivedDataWithRootObject(newBase), forKey: "Base")
                
            }
        }
        required init(coder aDecoder: NSCoder) {
            
            
            if let rootArray = aDecoder.decodeObjectForKey("rootArray") as? [Root] {
                self.rootArray = rootArray
            }
        }
        
        func encodeWithCoder(aCoder: NSCoder) {
            aCoder.encodeObject(self.rootArray, forKey: "rootArray")
        }
        
    }

    // MARK: - For QuizVC , showing only questions for elements has video

    class func  getElementsWithVideos() -> [Element]
    {
        let array = getAllElementsFromBase()
        var array2 : [Element] = []
//        var counter = 0
        for i in array
        {
            if i.videoExist == true
            {
               array2.append(i)
            }
//            counter++
        }
        return array2
    }
    
    class func getAllElementsFromBase(base:Base?=Base()) -> [Element]{

        func names()->[String]{
            var ar : [String]!
            for i in getAllElementsFromBase()
            {
                ar.append(i.name!)
            }
            return ar
        }
        
        
        var allElementArray : [Element] = []
        for _root in base!.rootArray!
        {
            for _category in _root.categoriesArray!
            {
                for _element in _category.elementsArray!
                {
                    
                    allElementArray.append(_element)
                    
                }
            }
        }
        for i in allElementArray{
            print(i.name!)
        }
        return allElementArray
    }
    
    enum ReturnTypeForElementManager {
        case Root,Category,Element
    }
   
    class func getAllElementsFromBase(base:Base?=Base() , returnType : ReturnTypeForElementManager) -> [NSObject]{
        
        func names()->[String]{
            var ar : [String]!
            for i in getAllElementsFromBase()
            {
                ar.append(i.name!)
            }
            return ar
        }
        
        var allRootsArray       : [Root]     = []
        var allCateogriesArray  : [Category] = []
        var allElementArray     : [Element]  = []
        
        for _root in base!.rootArray!
        {
            allRootsArray.append(_root)
            for _category in _root.categoriesArray!
            {
                allCateogriesArray.append(_category)
                for _element in _category.elementsArray!
                {
                    allElementArray.append(_element)
                }
            }
        }
        for i in allElementArray{
            print(i.name!)
        }
        
        switch returnType{
        case .Root :
            return allRootsArray
        case .Category :
            return allCateogriesArray
        case .Element :
            return allElementArray
        }
    }
    
    
    class func searchForItemWithName(name:String , base:Base,nameType : ElementNameType?=nil) -> Element{
        
        for _root in base.rootArray!
        {
            for _category in _root.categoriesArray!
            {
                for _element in _category.elementsArray!
                {
                    if nameType == .English || nameType == nil
                    {
                        
                        if let elementName = _element.name
                        {
                            if name == elementName
                            {
                                _element.isNil = false
                                return _element
                            }
                        }
                    }
                        
                    else if nameType == .Arabic
                    {
                        if let elementName = _element.arName
                        {
                            if name == elementName
                            {
                                _element.isNil = false
                                return _element
                            }
                        }
                    }
                    
                }
                
            }
        }
        
        let nil_element = Element()
        //        println("search result : nil")
        return nil_element
    }
    
    //    class func searchProccess(text:String,base:Base) -> ([Element],Bool){
    //        let array = ElementManager.getArrayyOfElementsWithPrefix(text, base: base)
    //        var status = false
    //
    //        println("-----------------")
    //        for i in array{
    //            println(i.name!)
    //
    //        }
    //        // get the element
    //        if let str = ElementManager.Element.getEnglishNameFromArabic(text){
    //            var el = base[str]
    //            println("^^^^^^^^^")
    //
    //            if !el.isNil!
    //            {
    //                el.printDescreption()
    //                status = true
    //            }
    //        }
    //        return (array,status)
    //    }
    
    class func getArrayyOfElementsWithPrefix(prefix:String , base:Base) -> [Element]{
        var arrayOfSuggestedElements: [Element] = []
        for _root in base.rootArray!
        {
            for _category in _root.categoriesArray!
            {
                for _element in _category.elementsArray!
                {
                    if let elementName = _element.arName // if name exists
                    {
                        if elementName.hasPrefix(prefix)
                        {
                            arrayOfSuggestedElements.append(base[_element.name!]) // Change This to get elemnt
                        }
                        
                    }
                }
                
            }
        }
        
        
        return arrayOfSuggestedElements
    }
    
    
    /**
        THE MAIN FUNCTION initilize the base with deafult values from the plist
     */
    
    class func prepareItemsOfDataBase()-> Base {
        /*
        •  Preparing for Root dictionaries
        •  pulling data from plisst
        •  converting to a swift dictionaries
        */
        let plistName = "Dictionary_1"
        let path : String? = NSBundle.mainBundle().pathForResource(plistName, ofType: "plist")
        let baseDictionary = NSDictionary(contentsOfFile: path!)
        let baseDictionarySwift = baseDictionary as! [String : [String :[AnyObject]]]
        //println(baseDictionarySwift)
        
        
        /*
        P r e p a r i n g
        •   Root
        •   Category
        •   Element
        */
        
        var rootArray       : [Root]!     = [Root]()
        var categorysArray  : [Category]!
        var elementsArray   : [Element]!  // initlised inside
        
        
        
        /*
        • Unrapping    ROOT •
        */
        for (rootName , rootDictionary) in baseDictionarySwift{
            categorysArray  = [Category]()
            /*
            • Unrapping Category •
            */
            for (categoryName , categoryArray) in rootDictionary
            {
                elementsArray  = [Element]()
                /*
                *
                • Unrapping  ELEMENT •
                */
                for elementName in categoryArray{
                    //println("   \(elementName)")
                    let element :  Element = Element(_name: elementName)
                    element.categoryName   = categoryName
                    element.rootName       = rootName
                    elementsArray.append(element)
                    
                }
                
                //println("====")
                let category : Category = Category(_categoryName: categoryName, _elementsArray: elementsArray)
                categorysArray.append(category)
                
                
            }
            
            let root = Root(_categoriesArray: categorysArray ,_rootName: rootName)
            rootArray.append(root)
            //println("---------------------")
            
            
        }
        let base : Base? = Base(_rootArray:rootArray)
        
        return base!
        
        
    }
    
    
    
    class func checkNewPlistUpdate(plistName: String) -> Bool{
        let def = NSUserDefaults.standardUserDefaults()
        let path : String? = NSBundle.mainBundle().pathForResource(plistName, ofType: "plist")
        let baseDictionary = NSDictionary(contentsOfFile: path!)

        if def.objectForKey("dictionary.plist") == nil // nothing in the userDaufault
        {
            def.setObject(baseDictionary, forKey: "dictionary.plist")
            return true
        }
        else // user default exixsts
        {
            if let dictionaryOfPlist = baseDictionary
            {
                if def.objectForKey("dictionary.plist") as? NSDictionary == dictionaryOfPlist // dictionary in userdefault identical to the current dictionary
                {
                    //print("Dictionary has not changed")
                    return false
                }
                else // dictionary in user default doenst match the current dictionary
                {

                    print("dictionary has changed !")
                    def.setObject(dictionaryOfPlist, forKey: "dictionary.plist")
                    return true

                }
            }
        }
        return false
    }
    
    
}