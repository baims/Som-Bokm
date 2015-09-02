//
//  AppDelegate.swift
//  SomBokmApplication
//
//  Created by Omar on 6/13/15.
//  Copyright (c) 2015 Baims. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        var arrayOfKeys = NSArray() // array of categories KEYS only ,ex. ["animals","plants","names"...]
        var arrayOfKeysLetters = NSArray() // array of alphabit KEYS only ,ex. ["A","B","C"...]
        var updatedArrayOfKeys = NSArray()
        var categoryDictionary = NSDictionary() //Dictionary of Categories ONLY without alphabit
        var alphabitDictionary = NSDictionary() //Dictionary of alphabit ONLY without category
        
        var updatedDictionary = NSDictionary()
        
        var selectedIndexPath : NSIndexPath!    //index for collection view to know which item was selected in segue
        //This will bey (key : String , value: Tuple(String,String)) that will store both arabic name and english
        var dictionaryOfElements : [String:(categoryType:String,nameInArabic:String)] = Dictionary()
        /*shows all elements from all categories ex.
        [Key : Name in english , Value : (categoryType , name in arabic)]
        
        */
        var elementName     : String?       //will transfer to the elementVC when *SEARCHING* to get the key from Dictionary
        var dictionaryName  : String?       //will transfer to the elementVC when *SEARCHING* to push the elementDictionary
        var dictionaryKey   : String?
        
        
        var def = NSUserDefaults.standardUserDefaults()
        
        // Override point for customization after application launch.
        
        if let pathForPlist = NSBundle.mainBundle().pathForResource("Dictionary", ofType: "plist"){
            
            if let dictionaryForPlist = NSDictionary(contentsOfFile: pathForPlist){
                // CAtegoies
                if let categories: NSDictionary? = dictionaryForPlist.objectForKey("categories") as? NSDictionary{
                    categoryDictionary =  categories!
                    
                    def.setValue(categoryDictionary, forKey: "categoryDictionary")
                    
                    if let arrayOfCategories = categories?.allKeys{
                        arrayOfKeys = NSArray(array: arrayOfCategories)
                        
                        def.setValue(arrayOfKeys, forKey: "arrayOfKeys")
                        
                    }
                }
                ///ALPHABIT
                
                if let alphabiticLettersDictionary: NSDictionary? = dictionaryForPlist.objectForKey("alphabit") as? NSDictionary{
                    alphabitDictionary =  alphabiticLettersDictionary!
                    
                    if let arrayOfCategories = alphabiticLettersDictionary?.allKeys{
                        // sort the array accendingly
                        let sortedAlphabiticArray = arrayOfCategories.sorted { $1.localizedCaseInsensitiveCompare($0 as! String) == NSComparisonResult.OrderedDescending }
                        //                    println(sortedAlphabiticArray)
                        arrayOfKeysLetters = NSArray(array: sortedAlphabiticArray)
                        
                    }
                }
                
            }
            
            
            // preparing For Search
            // another if let To convert NSDictionary to swift Dictionaty aand then do the for in
            
            if let dict = NSDictionary(dictionary: categoryDictionary) as? Dictionary<String, NSDictionary> {
                //  c : catagory
                for (ckey ,cDic ) in dict
                {
                    let categDictionary = cDic as? Dictionary<String,NSDictionary>
                    //  e : element
                    for (eKey , eDic) in categDictionary!
                    {
                        let name   = eDic.objectForKey("name") as! String
                        let dicKey = ckey
                        dictionaryOfElements.updateValue((name,dicKey), forKey: eKey)
                        
                    }
                }
                
                println("^^^^^^^^^^^^\n\(dictionaryOfElements)")
                // dic is anyObject should be unrapped
                
                
                
            }
            
        }
        
        def.synchronize()
        
        
        
        // Realm Migration
        setSchemaVersion(2, Realm.defaultPath, { migration, oldSchemaVersion in
            if oldSchemaVersion < 2 {
                // The enumerate(_:_:) method iterates
                // over every Scene object stored in the Realm file
                migration.enumerate(Scene.className()) { oldObject, newObject in
                    // combine name fields into a single field
                    newObject!["isEditable"] = false
                }
                
                migration.enumerate(StoryTelling.className()) { oldObject, newObject in
                    // combine name fields into a single field
                    newObject!["telling"]    = false
                    newObject!["reading"]    = false
                    newObject!["completing"] = false
                }
            }
        })
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

