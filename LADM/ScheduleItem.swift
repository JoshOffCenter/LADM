//
//  ScheduleItem.swift
//  LADM
//
//  Created by Josh Carter on 5/20/15.
//  Copyright (c) 2015 MoonBase. All rights reserved.
//

import UIKit

class ScheduleItem: NSObject {
    
    var objectId, age, faculty, city, day, event, time, extraInfo : String!
    var order: Int?
    
    
    init(objectId: String, age: String, faculty: String, city: String, day: String, event: String, time: String, extraInfo: String, order: Int) {
        self.objectId = objectId
        self.age = age
        self.faculty = faculty
        self.city = city
        self.day = day
        self.event = event
        self.time = time
        self.extraInfo = extraInfo
        self.order = order
    }
    
    func dictionaryRepresentation() -> NSDictionary {
        return ["objectId": objectId!, "age": age!, "faculty":faculty!, "city":city!, "day":day!, "event":event!, "time":time!, "extraInfo":extraInfo!, "order": order!]
    }
}
