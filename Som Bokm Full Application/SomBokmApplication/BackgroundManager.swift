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
    
    
    var allStBGsURL : [NSURL]{
        get{
            return NSBundle().recursivePathsForResources(type : "jpg")
        }
    }
    
    
    
    
}

extension NSBundle {
    
    func recursivePathsForResources(type type: String) -> [NSURL] {
        
        // Enumerators are recursive
        let enumerator = NSFileManager.defaultManager().enumeratorAtPath(bundlePath)
        var filePaths = [NSURL]()
        
        while let filePath = enumerator?.nextObject() as? String {
            
            if NSURL(fileURLWithPath: filePath).pathExtension == type {
                filePaths.append(bundleURL.URLByAppendingPathComponent(filePath))
            }
        }
        
        return filePaths
    }
}