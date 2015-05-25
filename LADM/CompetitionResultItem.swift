//
//  CompetitionResultItem.swift
//  LADM
//
//  Created by Chance Daniel on 5/23/15.
//  Copyright (c) 2015 MoonBase. All rights reserved.
//


import UIKit

class CompetitionResultItem {
    
    let division, award, category, routine, studio: String!
    
    init(division: String, award: String, category: String, routine: String, studio: String){
        self.division = division
        self.award = award
        self.category = category
        self.routine = routine
        self.studio = studio
    }
    
    func equals(item: CompetitionResultItem) -> Bool{
        return(self.division == item.division) && (self.award == item.award) && (self.category == item.category) && (self.routine == item.routine) && (self.studio == item.studio)
    }
    
}
