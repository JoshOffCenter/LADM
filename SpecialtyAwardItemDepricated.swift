//
//  SpecialtyAwardItem.swift
//  LADM
//
//  Created by Josh Carter on 5/12/15.
//  Copyright (c) 2015 MoonBase. All rights reserved.
//

import UIKit

class SpecialtyAwardItemDepricated {
    let age: String!
    let awards: [Dictionary<String,Dictionary<String,String>>]!
    
    init(age:String, awards: [Dictionary<String,Dictionary<String,String>>]) {
        self.age = age
        self.awards = awards
    }
}
