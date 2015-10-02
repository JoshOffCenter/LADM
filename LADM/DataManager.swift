//
//  DataManager.swift
//  LADM
//
//  Created by Chance Daniel on 10/1/15.
//  Copyright © 2015 MoonBase. All rights reserved.
//

import UIKit
import Parse

class DataManager: NSObject {
    static let sharedInstance = DataManager()
    
    var cities = [PFObject]()
    var scheduleItems = [ScheduleItem]()
    var competitionItems = [CompetitionItem]()
    var resultItems = [ResultItem]()
    var specialtyItems = [SpecialtyItem]()
    
    

    
    override init () {
        super.init()
        fetchAllCities()
    }
    
    func fetchAllCities() {
        //Returns City Objects
        //
        //        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        //        delegate.login()
        
        PFCloud.callFunctionInBackground("checkAllCities", withParameters:[:]) {
            result, error in
            if error == nil {
                let array = result as! [PFObject]
                for object: PFObject in array {
                                        if (object.objectForKey("uploaded") != nil && (object.objectForKey("uploaded") as! Int != 0)) {
                    self.cities.append(object)
                                        }
                }
            }
        }
    }
    
    func pullCity(name:String, vc: ToursAndCitiesViewController) {
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
            }
            vc.buttonShade()
        }
    }
    
    
    func createScheduleItemsFromObjects(objects: [PFObject]) {
        scheduleItems.removeAll()
        for object: PFObject in objects {
            let scheduleItem = ScheduleItem(objectID: object.objectId!, age: object.objectForKey("age") as! String, faculty: object.objectForKey("faculty") as! String, city: object.objectForKey("city") as! String, day: object.objectForKey("day") as! String, event: object.objectForKey("event") as! String, time: object.objectForKey("time") as! String, extraInfo: object.objectForKey("extraInfo") as! String, order: object.objectForKey("order") as! Int)
            scheduleItems.append(scheduleItem)
        }
    }
    
    func createCompetitionItemsFromObjects(objects: [PFObject]) {
        competitionItems.removeAll()
        for object: PFObject in objects {
            let competitionItem = CompetitionItem(objectID: object.objectId!, age: object.objectForKey("age") as! String, category: object.objectForKey("category") as! String, city: object.objectForKey("city") as! String, day: object.objectForKey("day") as! String, routineIDAndName: object.objectForKey("routineIdAndName") as! String, studio: object.objectForKey("studio") as! String, time: object.objectForKey("time") as! String, order: object.objectForKey("order") as! Int)
            competitionItems.append(competitionItem)
        }
    }
    
    func createSpecialtyItemsFromObjects(objects: [PFObject]) {
        specialtyItems.removeAll()
        for object: PFObject in objects {
            let specialtyItem = SpecialtyItem(objectID: object.objectId!, age: object.objectForKey("age") as! String, award: object.objectForKey("award") as! String, city: object.objectForKey("city") as! String, piece: object.objectForKey("piece") as! String, studio: object.objectForKey("studio") as! String)
            specialtyItems.append(specialtyItem)
        }
    }
    
    func createResultItemsFromObjects(objects: [PFObject]) {
        resultItems.removeAll()
        for object: PFObject in objects {
            let resultItem = ResultItem(objectID: object.objectId!, ageDIV: object.objectForKey("ageDiv") as! String, award: object.objectForKey("award") as! String, category: object.objectForKey("category") as! String, city: object.objectForKey("city") as! String, routine: object.objectForKey("routine") as! String)
            resultItems.append(resultItem)
        }
    }
    
    
    
    

}
