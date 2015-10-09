//
//  BackgroundManager.swift
//  SomBokmApplication
//
//  Created by Omar Alibrahim on 10/8/15.
//  Copyright © 2015 Baims. All rights reserved.
//

import Foundation
import UIKit

class BackgroundManager{
    
    
    func getEelementOfScene(sceneName:String) -> [String]
    {
        var elementsArray : [String] = []
        for i in backgroundsInBundle()
        {
            if sceneName == i
            {
                var c = 1 // your start point of naming
                var nameOfImage = i+"\(c)"
                while NSBundle.mainBundle().pathExistsWithName(type: "png", name: nameOfImage)
                {
                    elementsArray.append(nameOfImage)
                    c++
                    nameOfImage = i+"\(c)"
                }
                return elementsArray
            }
            else
            {
                print("you Background : \(sceneName) Doesnt Exist!")
            }
        }
        print("No elements found for bg named: \(sceneName)")
        return []
    }
 
    
    
    
    func backgroundsInBundle() -> [String]
    {
            
            let arrayOfImagesWithSuffix_BG = NSBundle.mainBundle().recursivePathsForResources(type: "png",suffix : "BG")
            //        print(arrayOfImagesWithSuffix_BG)
            
            var backgroundsNames : [String] = []
            for i in arrayOfImagesWithSuffix_BG as! [String]
            {
                let bgName  = (i.characters.split{$0 == "_"}.map(String.init))[0] // choosed 0 to take •••BEFORE••• the " _ "
                backgroundsNames.append(bgName)
            }
            
            return backgroundsNames
            
    }
    
    
    
    
    
}


/**
    •••••••••••••••••••••••••••••••••
    •••••••••••••••••••••••••••••••••
    ••••••     READ  ME      ••••••••
    •••••••••••••••••••••••••••••••••
    •••••••••••••••••••••••••••••••••

Extension to NSBundle 

       ••• I provided Another one with same name for suffix
        recursivePathsForResources(type type: String,prefix:String) -> [NSString]
        {
            get you all elements in mainBundle with  prefix and type
        }


        pathExistsWithName(type type: String,name:String) -> Bool
        {
            Checks if the name plugged is •EXACTLY• same in bundle
        }


// ENJOY ^__^
*/


extension NSBundle {
    
    
    func recursivePathsForResources(type type: String,prefix:String) -> [NSString] {
        
        // Enumerators are recursive
        let enumerator = NSFileManager.defaultManager().enumeratorAtPath(bundlePath)
        var filePaths = [String]()
        
        while let filePath = enumerator?.nextObject() as? String {
            
            if NSURL(fileURLWithPath: filePath).pathExtension == type {
                
                //print(NSURL(fileURLWithPath: filePath).URLByDeletingPathExtension)
                
                let url = NSURL(fileURLWithPath: filePath).URLByDeletingPathExtension
                var path = url?.path
                path!.removeAtIndex(path!.startIndex)
                if (path?.hasPrefix(prefix) == true)
                {
                    
                    filePaths.append(path!)
                }
            }
        }
        
        return filePaths
    }
    
    func pathExistsWithName(type type: String,name:String) -> Bool {
        
        // Enumerators are recursive
        let enumerator = NSFileManager.defaultManager().enumeratorAtPath(bundlePath)
        
        while let filePath = enumerator?.nextObject() as? String {
            
            if NSURL(fileURLWithPath: filePath).pathExtension == type {
                
                //print(NSURL(fileURLWithPath: filePath).URLByDeletingPathExtension)
                
                let url = NSURL(fileURLWithPath: filePath).URLByDeletingPathExtension
                var path = url?.path
                path!.removeAtIndex(path!.startIndex)
                if (path! == name)
                {
                    return true
                }
            }
        }
        
        return false
    }
    
/*
        Provided function for SUFFIX
*/
    func recursivePathsForResources(type type: String,suffix:String) -> [NSString] {
        
        // Enumerators are recursive
        let enumerator = NSFileManager.defaultManager().enumeratorAtPath(bundlePath)
        var filePaths = [String]()
        
        while let filePath = enumerator?.nextObject() as? String {
            
            if NSURL(fileURLWithPath: filePath).pathExtension == type {
                
                //print(NSURL(fileURLWithPath: filePath).URLByDeletingPathExtension)
                
                let url = NSURL(fileURLWithPath: filePath).URLByDeletingPathExtension
                var path = url?.path
                path!.removeAtIndex(path!.startIndex)
                if (path?.hasSuffix(suffix) == true)
                {
                    
                    filePaths.append(path!)
                }
            }
        }
        
        return filePaths
    }
}