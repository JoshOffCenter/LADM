//
//  ScheduleItemSection.swift
//  LADM
//
//  Created by Josh Carter on 11/2/15.
//  Copyright © 2015 MoonBase. All rights reserved.
//

import UIKit

class ScheduleItemSection {
    let group: String!
    var scheduleItems = [ScheduleItem]()
    init(group: String, firstItem: ScheduleItem) {
        self.group = group
        scheduleItems.append(firstItem)
    }
}


