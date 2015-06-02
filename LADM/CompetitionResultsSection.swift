//
//  CompetitionResultsSection.swift
//  LADM
//
//  Created by Josh Carter on 6/2/15.
//  Copyright (c) 2015 MoonBase. All rights reserved.
//

import UIKit

class CompetitionResultsSection {
    
    let division: String!
    var competitionItems = [CompetitionResultItem]()
    init(div: String, firstItem: CompetitionResultItem) {
        division = div
        competitionItems.append(firstItem)
    }
    
}
