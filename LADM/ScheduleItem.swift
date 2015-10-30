//
//  ScheduleItem.swift
//  LADM
//
//  Created by Josh Carter on 5/20/15.
//  Copyright (c) 2015 MoonBase. All rights reserved.
//

import UIKit

class ScheduleItem: NSObject {
    
    var objectId, group, faculty, city, day, event, extraInfo : String!
    var startTime: NSDate!
    var endTime: NSDate?
//    var order: Int?
    
    
    init(objectId: String, group: String, faculty: String, city: String, day: String, event: String, startTime: NSDate, endTime: NSDate?, extraInfo: String) {
        self.objectId = objectId
        self.group = group
        self.faculty = faculty
        self.city = city
        self.day = day
        self.event = event
        self.startTime = startTime
        self.endTime = endTime
        self.extraInfo = extraInfo
//        self.order = order
    }
    
    func dictionaryRepresentation() -> NSDictionary {
        if (endTime != nil) {
            return ["objectId": objectId!, "group": group!, "faculty":faculty!, "city":city!, "day":day!, "event":event!, "startTime":startTime!, "endTime":endTime!, "extraInfo":extraInfo!]
        }
        return ["objectId": objectId!, "group": group!, "faculty":faculty!, "city":city!, "day":day!, "event":event!, "startTime":startTime!, "extraInfo":extraInfo!]

    }
}
