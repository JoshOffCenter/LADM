//
//  CompetitionItemSection.swift
//  LADM
//
//  Created by Chance Daniel on 2/17/16.
//  Copyright © 2016 MoonBase. All rights reserved.
//

import UIKit

class CompetitionItemSection {
    let day: String!
    var competitionItems = [CompetitionItem]()
    init(day: String, firstItem: CompetitionItem) {
        self.day = day
        competitionItems.append(firstItem)
    }
}