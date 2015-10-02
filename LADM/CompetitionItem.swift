//
//  CompetitionItem.swift
//  LADM
//
//  Created by Chance Daniel on 4/25/15.
//  Copyright (c) 2015 MoonBase. All rights reserved.
//

import UIKit

class CompetitionItem {
    
    var objectID, age, category, city, day, routineIDAndName, studio, time: String!
    var order: Int!
    var favorited = false
   
    init(objectID: String, age: String, category: String, city: String, day: String, routineIDAndName: String, studio: String, time: String, order: Int){
        self.objectID = objectID
        self.age = age
        self.category = category
        self.city = city
        self.day = day
        self.routineIDAndName = routineIDAndName
        self.studio = studio
        self.time = time
        self.order = order
    }
}
