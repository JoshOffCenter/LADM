//
//  CompEvent.swift
//  LADM
//
//  Created by Chance Daniel on 4/25/15.
//  Copyright (c) 2015 MoonBase. All rights reserved.
//

import UIKit

class CompEventItem {
   let time: String
   let performanceTitle: String
   let favorited: Bool
   let studio: String
   let age: String
   let category: String
   let division: String
   
   init(time: String, performanceTitle: String, studio: String, age: String, category: String, division: String){
      self.time = time
      self.performanceTitle = performanceTitle
      self.studio = studio
      self.age = age
      self.category = category
      self.division = division
      favorited = false
   }
}
