//
//  SpecialtyAwardSection.swift
//  LADM
//
//  Created by Josh Carter on 5/30/15.
//  Copyright (c) 2015 MoonBase. All rights reserved.
//

import UIKit

class SpecialtyAwardSection {

    let division: String!
    var specialtyItems = [SpecialtyAwardItem]()
    init(div: String, firstItem: SpecialtyAwardItem) {
        division = div
        specialtyItems.append(firstItem)
    }
    
}
