//
//  SpecialtyAwardSection.swift
//  LADM
//
//  Created by Josh Carter on 5/30/15.
//  Copyright (c) 2015 MoonBase. All rights reserved.
//

import UIKit

class SpecialtyAwardSection {

    let age: String!
    var specialtyItems = [SpecialtyItem]()
    init(a: String, firstItem: SpecialtyItem) {
        age = a
        specialtyItems.append(firstItem)
    }
    
}
