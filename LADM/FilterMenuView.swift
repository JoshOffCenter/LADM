//
//  FilterMenuView.swift
//  LADM
//
//  Created by Chance Daniel on 4/26/15.
//  Copyright (c) 2015 MoonBase. All rights reserved.
//

import UIKit
extension UIView {
   func roundCorners(corners:UIRectCorner, radius: CGFloat) {
      let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
      let mask = CAShapeLayer()
      mask.path = path.CGPath
      self.layer.mask = mask
   }
   
   
}

class FilterMenuView: UIView {

   @IBOutlet weak var filterByLabel: UILabel!
   @IBOutlet weak var filterDividerLabel: UILabel!
   @IBOutlet weak var filterMenuButton: UIButton!
    
    @IBOutlet weak var filterStudioLabel: UILabel!
    @IBOutlet weak var filterAgeLabel: UILabel!
    @IBOutlet weak var filterCategoryLabel: UILabel!
    @IBOutlet weak var filterDayLabel: UILabel!


    
    var studios = ["Any Studio"] + cityData[selectedCity]!.studios
    var ages = ["Any Age"] + cityData[selectedCity]!.ages
    var categories = ["Any Category"] + cityData[selectedCity]!.categories
    var days = ["Any Day","Friday","Saturday"]
    
    var counter = ["Studios": 0, "Ages": 0, "Categories": 0, "Days":0]




   

   required init(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
      
      self.roundCorners(.BottomLeft | .BottomRight, radius: 5)
    
   }
   
    
    @IBAction func changeFilter (sender:UIButton) {
//        filterAgeButton.titleLabel!.numberOfLines = 3
//        filterAgeButton.titleLabel!.textAlignment = .Center

//        switch sender.titleLabel!.text!
        switch sender.restorationIdentifier!{
            case "StudioButtonRight": counter["Studios"]!++
            case "StudioButtonLeft": counter["Studios"]!--
            case "AgeButtonRight": counter["Ages"]!++
            case "AgeButtonLeft": counter["Ages"]!--
            case "CategoryButtonRight": counter["Categories"]!++
            case "CategoryButtonLeft": counter["Categories"]!--
            case "DayButtonRight": counter["Days"]!++
            case "DayButtonLeft": counter["Days"]!--
        default: break
        }
        
        if counter["Studios"]! < 0 {
            counter["Studios"] = studios.count - 1
        }
        if counter["Ages"]! < 0 {
            counter["Ages"] = ages.count - 1
        }
        if counter["Categories"]! < 0 {
            counter["Categories"] = categories.count - 1
        }
        if counter["Days"]! < 0 {
            counter["Days"] = 2
        }
        
        filterStudioLabel.text = studios[counter["Studios"]! % studios.count]
        filterAgeLabel.text = ages[counter["Ages"]! % ages.count]
        filterCategoryLabel.text = categories[counter["Categories"]! % categories.count]
        filterDayLabel.text = days[counter["Days"]! % 3]
    
        


        
    }
    
   
}
