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


*/


import Foundation
import UIKit

class ElementManager {
    
    enum ElementNameType{
        case Arabic
        case English
    }
    
    class Element
    {
        
        var name            : String?
        var arName          : String?
        var categoryName    : String?
        var rootName        : String?
        var caption         : String? = ""
        var isMastered      : Bool! = false
        
        var isNil : Bool?
        
        var imageName : String?  {
            get{
                if let _name = name {
                    let _imageName = _name + "Big"
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
        
        var image : UIImage? {
            get{
                if let _image = UIImage(named: imageName!){
                    return _image
                    
                }
                return nil
            }
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
        
        
        
        func printDescreption(){
            println(name            != nil ? " •\(name!): { "                          : "nil"         )
            println(arName          != nil ? "   arabic name    : \(arName!)"           : ""            )
            println(caption         != nil ? "   caption        : \(caption!)"          : ""            )
            println(imageName       != nil ? "   image name     : \(imageName!)"        : "doesnt exist")
            println(thumbImageName  != nil ? "   thumb name     : \(thumbImageName!)"   : "doesnt exist")
            println(videoName       != nil ? "   video name     : \(videoName!)"        : "doesnt exist")
            println(isMastered      != nil ? "   is Mastered    : \(isMastered!)"       : "doesnt exist")
            println(categoryName    != nil ? "   category name  : \(categoryName!)"     : "doesnt exist")
            println(rootName        != nil ? "   root name      : \(rootName!)"         : "doesnt exist")
            println("}")
            
            
        }
        
        init(_name:AnyObject){
            isNil = false
            
            if _name is String {
                name = _name as? String
            }
            else if _name is NSArray{
                var arrayOfElemnt = _name as? [AnyObject]
                name = arrayOfElemnt![0] as? String
                
                if arrayOfElemnt?.count >= 2{
                    if let _arName = arrayOfElemnt![1] as? String
                    {
                        arName = _arName
                    }
                }
                if arrayOfElemnt?.count >= 3{
                    if let _caption = arrayOfElemnt![2] as? String
                    {
                        caption = _caption
                    }
                }
            }
        }
        
        class func getArabicNameFromEnglish(englishName:String) -> String?{
            return Base()[englishName].arName
        }
        
        class func getEnglishNameFromArabic(arabicName:String) -> String?{
            return ElementManager.searchForItemWithName(arabicName, base: Base(), nameType: ElementManager.ElementNameType.Arabic).name
        }
        
        init(){
            isNil = true
            // return nil
        }
        
    }
    
    
    class Category {
        
        var elementsArray : [Element]?
        var categoryName  : String?
        var rootName      : String?
        
        func printDescreption(){
            println("   \(categoryName!)  : {")
            for _element in elementsArray! {
                println("       \(_element.name!)")
            }
            println("   }")
        }
        
        // elements with their details
        func printDescreptionFull(){
            for _element in elementsArray! {
                _element.printDescreption()
            }
        }
        
        init(_categoryName : String , _elementsArray : [Element]){
            elementsArray = _elementsArray
            categoryName  = _categoryName
        }
        
    }
    
    class Root {
        var rootName : String?
        var categoriesArray : [Category]?
        
        func printDescreption(){
            println("\(rootName!): {")
            for category in categoriesArray!{
                category.printDescreption()
            }
            println("}")
            
            
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
                println("No such Category named \(categoryName)")
            }
            return category!
        }
    }
    
    // ••••••••••••••••••••••••••••••••••••••
    // ••••••••••  B   A   S   E   ••••••••••
    
    class Base {
        var exists      : Bool! = false
        var rootArray   : [Root]?
        
        func printDescreption()
        {
            for root in rootArray!{
                root.printDescreption()
            }
            
        }
        
        init(_rootArray:[Root]){
            rootArray = _rootArray
        }
        init(){
            rootArray = ElementManager.prepareItemsOfDataBase().rootArray
        }
        
        
        //        func getCategoriesArray() -> [Category]{
        //
        //        }
        //
        subscript (elementName : String) -> Element{
            // searching
            let base = Base(_rootArray: rootArray!)
            
            
            return ElementManager.searchForItemWithName(elementName, base: base)
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
    
    
    // -------- THE MAIN FUNCTION
    
    
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
                    var element :  Element = Element(_name: elementName)
                    element.categoryName   = categoryName
                    element.rootName       = rootName
                    elementsArray.append(element)
                    
                }
                
                //println("====")
                var category : Category = Category(_categoryName: categoryName, _elementsArray: elementsArray)
                categorysArray.append(category)
                
                
            }
            
            var root = Root(_categoriesArray: categorysArray ,_rootName: rootName)
            rootArray.append(root)
            //println("---------------------")
            
            
        }
        var base : Base? = Base(_rootArray:rootArray)
        
        // T E S T I N G
        
        //    if let _base = base {
        //        _base.rootArray![0].categoriesArray![0].elementsArray![0].isMastered = true
        //
        //        let element1 = _base["hammer"]
        //        element1.isMastered = true
        //        _base.printDescreption()
        //        _base["lion"].isMastered = true
        //
        //        //println(base["lion"].isMastered)
        //
        //    }
        
        return base!
        
        
    }
    
}