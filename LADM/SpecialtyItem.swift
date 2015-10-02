//
//  SpecialtyItem.swift
//  LADM
//
//  Created by Chance Daniel on 5/25/15.
//  Copyright (c) 2015 MoonBase. All rights reserved.
//

import UIKit

class SpecialtyItem {
    
    var objectID, age, award, city, piece, studio: String!
    
    init(objectID: String, age: String, award: String, city: String, piece: String, studio: String){
        self.objectID = objectID
        self.age = age
        self.award = award
        self.city = city
        self.piece = piece
        self.studio = studio
    }
    
//    func equals(item: SpecialtyAwardItem) -> Bool{
//        return(self.division == item.division) && (self.award == item.award) && (self.piece == item.piece) && (self.studio == item.studio)
//    }
    
}
