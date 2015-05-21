//
//  ScheduleItem.swift
//  LADM
//
//  Created by Josh Carter on 5/20/15.
//  Copyright (c) 2015 MoonBase. All rights reserved.
//

import UIKit

class ScheduleItem {
    
    let group,time,faculty,event,day:String!
    var info = "No Extra Information"
    
    init(group:String,time:String, faculty:String, event:String, info:String, day:String)
    {
        self.group = group
        self.time = time
        self.faculty = faculty
        self.event = event
        if !info.isEmpty {
            self.info = info
        }
        self.day = day
    }
}
