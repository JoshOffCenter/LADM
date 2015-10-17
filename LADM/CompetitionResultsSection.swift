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
    var competitionItems = [ResultItem]()
    init(div: String, firstItem: ResultItem) {
        division = div
        competitionItems.append(firstItem)
    }
    
//    func sort () {
//        competitionItems.sortInPlace({$0.order < $1.order})
//    }
    
}
