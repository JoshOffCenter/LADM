//
//  CompetitionItem.swift
//  LADM
//
//  Created by Chance Daniel on 4/25/15.
//  Copyright (c) 2015 MoonBase. All rights reserved.
//

import UIKit

class CompetitionItem {
    
    var objectId, age, division, category, city, day, routineID, name, studio: String!
//    var order: Int!
    var startTime: NSDate!
    var favorited = false
   
    init(objectId: String, age: String, division: String, category: String, city: String, day: String, routineID: String, name: String, studio: String, startTime: NSDate){
        self.objectId = objectId
        self.age = age
        self.division = division
        self.category = category
        self.city = city
        self.day = day
        self.routineID = routineID
        self.name = name
        self.studio = studio
        self.startTime = startTime
//        self.order = order
    }
    
    func dictionaryRepresentation() -> NSDictionary {
        return ["objectId": objectId!, "age": age!, "division":division, "category":category!, "city":city!, "day":day!, "routineID":routineID!, "name": name!, "studio":studio!, "startTime":startTime!]
    }
}
