//
//  ScheduleItem.swift
//  LADM
//
//  Created by Josh Carter on 5/20/15.
//  Copyright (c) 2015 MoonBase. All rights reserved.
//

import UIKit

class ScheduleItem {
    
    var objectID, age, faculty, city, day, event, time, extraInfo : String!
    var order: Int?
    
    init(objectID: String, age: String, faculty: String, city: String, day: String, event: String, time: String, extraInfo: String, order: Int) {
        self.objectID = objectID
        self.age = age
        self.faculty = faculty
        self.city = city
        self.day = day
        self.event = event
        self.time = time
        self.extraInfo = extraInfo
        self.order = order
    }
}
