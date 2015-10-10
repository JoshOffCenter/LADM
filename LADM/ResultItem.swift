//
//  CompetitionResultItem.swift
//  LADM
//
//  Created by Chance Daniel on 5/23/15.
//  Copyright (c) 2015 MoonBase. All rights reserved.
//


import UIKit

class ResultItem {
    
    let objectId, age, award, category, city, division, routine, studio : String!
    let order : Int!
    
    init(objectId: String, age: String, award: String, category: String, city: String, order: Int, division: String, routine: String, studio: String){
       self.objectId = objectId
        self.age = age
        self.award = award
        self.category = category
        self.city = city
        self.order = order
        self.division = division;
        self.routine = routine
        self.studio = studio
    }
    
//    func equals(item: CompetitionResultItem) -> Bool{
//        return(self.division == item.division) && (self.award == item.award) && (self.category == item.category) && (self.routine == item.routine) && (self.studio == item.studio)
//    }
    
}
