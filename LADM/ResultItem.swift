//
//  CompetitionResultItem.swift
//  LADM
//
//  Created by Chance Daniel on 5/23/15.
//  Copyright (c) 2015 MoonBase. All rights reserved.
//


import UIKit

class ResultItem {
    
    let objectID, ageDIV, award, category, city, routine : String!
    
    init(objectID: String, ageDIV: String, award: String, category: String, city: String, routine: String){
       self.objectID = objectID
        self.ageDIV = ageDIV
        self.award = award
        self.category = category
        self.city = city
        self.routine = routine
    }
    
//    func equals(item: CompetitionResultItem) -> Bool{
//        return(self.division == item.division) && (self.award == item.award) && (self.category == item.category) && (self.routine == item.routine) && (self.studio == item.studio)
//    }
    
}
