//
//  SpecialtyAwardItem.swift
//  LADM
//
//  Created by Chance Daniel on 5/25/15.
//  Copyright (c) 2015 MoonBase. All rights reserved.
//

import UIKit

class SpecialtyAwardItem {
    
    let division, award, piece, studio: String!
    
    init(division: String, award: String, piece: String, studio: String){
        self.division = division
        self.award = award
        self.piece = piece
        self.studio = studio
    }
    
    func equals(item: SpecialtyAwardItem) -> Bool{
        return(self.division == item.division) && (self.award == item.award) && (self.piece == item.piece) && (self.studio == item.studio)
    }
    
}
