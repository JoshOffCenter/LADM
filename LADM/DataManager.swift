//
//  DataManager.swift
//  LADM
//
//  Created by Chance Daniel on 10/1/15.
//  Copyright © 2015 MoonBase. All rights reserved.
//

import UIKit
import Parse
import Bolts

class DataManager: NSObject {
    var reach: Reachability?
    var networkStatus: NetworkStatus!
    
    var lastUpdate: NSDate!

    static let sharedInstance = DataManager()
    
    var cities = [PFObject]()
    var scheduleItems = [ScheduleItem]()
    var competitionItems = [CompetitionItem]()
    var resultItems = [ResultItem]()
    var specialtyItems = [SpecialtyItem]()
    
    
    var studios = [String]()
    var ages = [String]()
    var categories = [String]()
    var days = [String]()
    
    var favorites:NSMutableArray = []
    
    var parseLoggedIn = false
    

    
    override init () {
        super.init()
        setupParse()
        handleReachablity()
        fetchAllCities()
    }
    
    func handleReachablity() {
        //Allocate a reachability object
        self.reach = Reachability.reachabilityForInternetConnection()
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "reachabilityChanged:",
            name: kReachabilityChangedNotification,
            object: nil)

        
        self.reach!.startNotifier()
        networkStatus = self.reach?.currentReachabilityStatus()
        if (networkStatus != NetworkStatus.NotReachable) {
            login()
        }
    }

    
    func reachabilityChanged(notification: NSNotification) {
        if self.reach!.isReachableViaWiFi() || self.reach!.isReachableViaWWAN() {
            print("Service avalaible!!!")
            if self.parseLoggedIn {
                fetchAllCities()
            } else {
                login()
            }
        } else {
            print("No service avalaible!!!")
        }
        networkStatus = self.reach?.currentReachabilityStatus()
    }
    
    func setupParse() {
        Parse.enableLocalDatastore()
        
        
        // Initialize Parse.
        Parse.setApplicationId("EBNRrSOrKvzwmeSBkRd4tZm3soLienluMDPF1jOU", clientKey: "hJ8fFl1vLvtJX43sCfO1mdHT27HzfNjg9NIgWmbp")
        
        
        
//        login()
//        if self.parseSetup {
//            fetchAllCities()
//        }
    }
    
    func login () {
        PFUser.logOut()
        
        PFUser.logInWithUsernameInBackground((UIDevice.currentDevice().identifierForVendor?.UUIDString)!, password:"LADM") {
            (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                // Do stuff after successful login.
                print("Login Successful")
                NSNotificationCenter.defaultCenter().postNotificationName("parseLoginCompleted", object: nil)
                self.parseLoggedIn = true
            } else {
                // The login failed. Check error to see why.
                print("Try signup")
                
                self.signUp()
            }
        }
    }
    
    func signUp() {
        let user = PFUser()
        user.username = UIDevice.currentDevice().identifierForVendor?.UUIDString
        user.password = "LADM"
        
        user.signUpInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in
            if let error = error {
                let errorString = error.userInfo["error"] as? NSString
                print(errorString)
                // Show the errorString somewhere and let the user try again.
                self.parseLoggedIn = false
            } else {
                // Hooray! Let them use the app now.
                print("Signup Successful")
                NSNotificationCenter.defaultCenter().postNotificationName("parseLoginCompleted", object: nil)

                self.parseLoggedIn = true
            }
        }
    }

    
    func fetchAllCities() {
        //Returns City Objects
        
        if (networkStatus != NetworkStatus.NotReachable) {
        
            PFCloud.callFunctionInBackground("checkAllCities", withParameters:[:]) {
                result, error in
                if error == nil {
                    let array = result as! [PFObject]
                    for object: PFObject in array {
                        
                        if (object.objectForKey("uploaded") != nil ) {
                            self.lastUpdate = object.objectForKey("uploaded") as! NSDate
                            self.cities.append(object)
                            
                            
                        }
                    }
                    PFObject.pinAllInBackground(self.cities)
                }
            }
        }
        else {
                
            print("Error")
            let query = PFQuery(className: "CityDate")
            query.fromLocalDatastore()
            query.whereKeyExists("city")
            query.findObjectsInBackground().continueWithBlock {
                (task: BFTask!) -> AnyObject in
                if let error = task.error {
                    print("Error: \(error)")
                    return task
                }
                
                print("Retrieved \(task.result.count)")
                let array = task.result as! [PFObject]
                
                dispatch_async(dispatch_get_main_queue()) { [unowned self] in
                    NSNotificationCenter.defaultCenter().postNotificationName("parseLoginCompleted", object: nil)
                    self.cities = array

                }
                

                return task
                
            }
            
        }
    }
    
    func pullCity(name:String, vc: ToursAndCitiesViewController) {
        if name != "Select City" {
            if networkStatus != NetworkStatus.NotReachable {
                PFCloud.callFunctionInBackground("pullCity", withParameters: ["city" : name]) {
                    result, error in
                    if error == nil {
                        
                        //Handle Schedule Items
                        self.createScheduleItemsFromObjects(result!.objectForKey("scheduleItems") as! [PFObject])
                        
                        //Handle Competition Items
                        self.createCompetitionItemsFromObjects(result!.objectForKey("competitionItems") as! [PFObject])
                        
                        //Handle Specialty Items
                        self.createSpecialtyItemsFromObjects(result!.objectForKey("specialtyItems") as! [PFObject])
                        
                        //Handle Result Items
                        self.createResultItemsFromObjects(result!.objectForKey("resultItems") as! [PFObject])
                        
                        vc.buttonShade()
                    }
                }
            } else {
            
                let scheduleItemQuery = PFQuery(className: "ScheduleItem")
                scheduleItemQuery.fromLocalDatastore()
                //query.whereKeyExists("name")
                scheduleItemQuery.findObjectsInBackground().continueWithBlock {
                    (task: BFTask!) -> AnyObject in
                    if let error = task.error {
                        print("Error: \(error)")
                        return task
                    }
                    print("Retrieved \(task.result.count)")
                    let array = task.result as! [PFObject]
                    self.createScheduleItemsFromObjects(array)
                    self.changeButtonShade()
                    return task
                }
                
                let competitionItemQuery = PFQuery(className: "CompetitionItem")
                competitionItemQuery.fromLocalDatastore()
                //query.whereKeyExists("name")
                competitionItemQuery.findObjectsInBackground().continueWithBlock {
                    (task: BFTask!) -> AnyObject in
                    if let error = task.error {
                        print("Error: \(error)")
                        return task
                    }
                    print("Retrieved \(task.result.count)")
                    let array = task.result as! [PFObject]
                    self.createCompetitionItemsFromObjects(array)
                    self.changeButtonShade()
                    return task
                }
                
                let specialtyItemQuery = PFQuery(className: "SpecialtyItem")
                specialtyItemQuery.fromLocalDatastore()
                //query.whereKeyExists("name")
                specialtyItemQuery.findObjectsInBackground().continueWithBlock {
                    (task: BFTask!) -> AnyObject in
                    if let error = task.error {
                        print("Error: \(error)")
                        return task
                    }
                    print("Retrieved \(task.result.count)")
                    let array = task.result as! [PFObject]
                    self.createSpecialtyItemsFromObjects(array)
                    self.changeButtonShade()
                    return task
                }

                let resultItemQuery = PFQuery(className: "ResultItem")
                resultItemQuery.fromLocalDatastore()
                //query.whereKeyExists("name")
                resultItemQuery.findObjectsInBackground().continueWithBlock {
                    (task: BFTask!) -> AnyObject in
                    if let error = task.error {
                        print("Error: \(error)")
                        return task
                    }
                    print("Retrieved \(task.result.count)")
                    let array = task.result as! [PFObject]
                    self.createResultItemsFromObjects(array)
                    self.changeButtonShade()
                    return task
                }
            }
        }
        changeButtonShade()
    }
    
    func changeButtonShade() {
        dispatch_async(dispatch_get_main_queue()) { [unowned self] in
            NSNotificationCenter.defaultCenter().postNotificationName("changeButtonShade", object: nil)
        }
    }
    
    
    func createScheduleItemsFromObjects(objects: [PFObject]) {
        scheduleItems.removeAll()
        PFObject.pinAllInBackground(objects)
        for object: PFObject in objects {
            let scheduleItem = ScheduleItem(objectId: object.objectId!, group: object["group"] as! String, faculty: object["faculty"] as! String, city: object["city"] as! String, day: object["day"] as! String, event: object["event"] as! String, startTime: object["startTime"] as! NSDate, endTime: object["endTime"] as! NSDate?, extraInfo: object["extraInfo"] as! String)
            
            
            scheduleItems.append(scheduleItem)
        }
    }
    
    func createCompetitionItemsFromObjects(objects: [PFObject]) {
        competitionItems.removeAll()
        PFObject.pinAllInBackground(objects)
        for object: PFObject in objects {
            
            if object["age"].lowercaseString != "fill" {
                let competitionItem = CompetitionItem(objectId: object.objectId!, age: object["age"] as! String, division: object["division"] as! String, category: object["category"] as! String, city: object["city"] as! String, day: object["day"] as! String, routineID: object["routineID"] as! Int, name: object["name"] as! String, studio: object["studio"] as! String, startTime: object["startTime"] as! NSDate)
                competitionItems.append(competitionItem)

            }
            
        }
    }
    
    func createSpecialtyItemsFromObjects(objects: [PFObject]) {
        specialtyItems.removeAll()
        PFObject.pinAllInBackground(objects)
        for object: PFObject in objects {
            let specialtyItem = SpecialtyItem(objectId: object.objectId!, age: object.objectForKey("age") as! String, award: object.objectForKey("award") as! String, city: object.objectForKey("city") as! String, piece: object.objectForKey("piece") as! String, studio: object.objectForKey("studio") as! String)
            specialtyItems.append(specialtyItem)
        }
    }
    
    func createResultItemsFromObjects(objects: [PFObject]) {
        resultItems.removeAll()
        PFObject.pinAllInBackground(objects)
        for object: PFObject in objects {
            let resultItem = ResultItem(objectId: object.objectId!, age: object.objectForKey("age") as! String, award: object.objectForKey("award") as! String, category: object.objectForKey("category") as! String, city: object.objectForKey("city") as! String, rank: object.objectForKey("rank") as! Int, division: object.objectForKey("division") as! String, routine: object.objectForKey("routine") as! String, studio: object.objectForKey("studio") as! String)
            resultItems.append(resultItem)
        }
    }
    
    func filterItemsWithDictionary(items: [AnyObject], dictionary: NSDictionary) -> [AnyObject] {
        var x = 0;

        if let unfilteredItems = items as? [ScheduleItem] {
            let filteredItems: NSMutableArray = []
            
            for item in unfilteredItems {
                filteredItems.addObject(item)
            }
            
            for key in dictionary.allKeys {
                for item in unfilteredItems {
                    x++;
                    let schedItem = item
                    if let string = schedItem.dictionaryRepresentation().objectForKey(key) as? String {
                        if (string != dictionary.objectForKey(key) as! String){
                            filteredItems.removeObject(schedItem)
                        }
                    }
                }
            }
            filteredItems.count
            return filteredItems as [AnyObject]
        }
        
        if let unfilteredItems = items as? [CompetitionItem] {
            let filteredItems: NSMutableArray = []
            
//            for var i = 0; i < 10; i++ {
//                filteredItems.append(unfilteredItems[i])
//            }
            
            for item in unfilteredItems {
                filteredItems.addObject(item)
//                print(item.routineID)
//                print(item.name)
            }
            
            for key in dictionary.allKeys {
                for item in unfilteredItems {
                    x++;
                    let compItem = item
                    if let string = compItem.dictionaryRepresentation().objectForKey(key) as? String {
                        if (!dictionary.objectForKey(key)!.containsString("Any ") && string != dictionary.objectForKey(key) as! String){
                            filteredItems.removeObject(compItem)
                        }
                    }
                }
            }
            filteredItems.count
            return filteredItems as [AnyObject]
        }
        
        
        return []
    }
    
    
    func populateFilterMenu() {
        for item in competitionItems {
            if !studios.contains(item.studio) {
                studios.append(item.studio)
            }
            if !categories.contains(item.category) {
                categories.append(item.category)
            }
            if !ages.contains(item.age) {
                ages.append(item.age)
            }
            if !days.contains(item.day){
                days.append(item.day)
            }
        }
    }
    
 
    
    
    

}
