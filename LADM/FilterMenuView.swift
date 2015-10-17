//
//  FilterMenuView.swift
//  LADM
//
//  Created by Chance Daniel on 4/26/15.
//  Copyright (c) 2015 MoonBase. All rights reserved.
//

import UIKit
import Foundation

extension UIView {
   func roundCorners(corners:UIRectCorner, radius: CGFloat) {
      let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
      let mask = CAShapeLayer()
    self.layer.masksToBounds = true
      mask.path = path.CGPath
      self.layer.mask = mask
   }
   
   
}

class FilterMenuView: UIView {
    
    let dataManager = DataManager.sharedInstance

   @IBOutlet weak var filterByLabel: UILabel!
   @IBOutlet weak var filterDividerLabel: UILabel!
   @IBOutlet weak var filterMenuButton: UIButton!
    
    @IBOutlet weak var filterStudioLabel: UILabel!
    @IBOutlet weak var filterAgeLabel: UILabel!
    @IBOutlet weak var filterCategoryLabel: UILabel!
    @IBOutlet weak var filterDayLabel: UILabel!
    
    
//    var studios = ["Any Studio"] + cityData[selectedCity]!.studios
//    var ages = ["Any Age"] + cityData[selectedCity]!.ages
//    var categories = ["Any Category"] + cityData[selectedCity]!.categories
    var studios = ["Any Studio"]
    var ages = ["Any Age"]
    var categories = ["Any Category"]
    var days = ["Any Day"]//,"Friday","Saturday","Sunday"]
    
    var counter = ["Studios": 0, "Ages": 0, "Categories": 0, "Days":0]

   

   required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
    
    dataManager.populateFilterMenu()
    
    studios = ["Any Studio"] + dataManager.studios
    ages = ["Any Age"] + dataManager.ages
    categories = ["Any Category"] + dataManager.categories
    days = ["Any Day"] + dataManager.days
    
    
//      self.layer.cornerRadius = 10
//      self.roundCorners(.BottomLeft, radius: 5)
//        self.roundCorners(UIRectCorner.BottomRight, radius: 5)
    
   }
    
    func copyLabel(label: UILabel) -> UILabel {
        let newLabel = UILabel()
        newLabel.text = label.text
        newLabel.font = label.font
        newLabel.textColor = label.textColor
        newLabel.shadowColor = label.shadowColor
        newLabel.textAlignment = label.textAlignment
        newLabel.lineBreakMode = label.lineBreakMode
        newLabel.numberOfLines = label.numberOfLines
        newLabel.adjustsFontSizeToFitWidth = label.adjustsFontSizeToFitWidth
        newLabel.minimumScaleFactor = label.minimumScaleFactor
        newLabel.preferredMaxLayoutWidth = label.preferredMaxLayoutWidth
        newLabel.frame = label.frame
        return newLabel
    }
   
    
    @IBAction func changeFilter (sender:UIButton) {
//        filterAgeButton.titleLabel!.numberOfLines = 3
//        filterAgeButton.titleLabel!.textAlignment = .Center

//        switch sender.titleLabel!.text!
        var dummyLabel = UILabel()
        var oldLabel = UILabel()
        var transitionForward = Bool()
        
        switch sender.restorationIdentifier!{
            case "StudioButtonRight":
                counter["Studios"]!++
                dummyLabel = copyLabel(filterStudioLabel)
                oldLabel =  filterStudioLabel
                break
            case "StudioButtonLeft":
                counter["Studios"]!--
                dummyLabel = copyLabel(filterStudioLabel)
                oldLabel = filterStudioLabel
                break
            case "AgeButtonRight":
                counter["Ages"]!++
                dummyLabel = copyLabel(filterAgeLabel)
                oldLabel = filterAgeLabel
                break
            case "AgeButtonLeft":
                counter["Ages"]!--
                dummyLabel = copyLabel(filterAgeLabel)
                oldLabel = filterAgeLabel
                break
            case "CategoryButtonRight":
                counter["Categories"]!++
                dummyLabel = copyLabel(filterCategoryLabel)
                oldLabel = filterCategoryLabel
                break
            case "CategoryButtonLeft":
                counter["Categories"]!--
                dummyLabel = copyLabel(filterCategoryLabel)
                oldLabel = filterCategoryLabel
                break
            case "DayButtonRight":
                counter["Days"]!++
                dummyLabel = copyLabel(filterDayLabel)
                oldLabel = filterDayLabel
                break
            case "DayButtonLeft":
                dummyLabel = copyLabel(filterDayLabel)
                oldLabel = filterDayLabel
                counter["Days"]!--
                
                break
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
        
        let dummyOff: CGAffineTransform!
        let oldOff: CGAffineTransform!
        
        if (sender.restorationIdentifier?.rangeOfString("Right") != nil) {
            transitionForward = true
        }
        else {
            transitionForward = false
        }
        
        if transitionForward == true {
            dummyOff = CGAffineTransformMakeTranslation(50, 0)
            oldOff = CGAffineTransformMakeTranslation(-50, 0)
        }
        else {
            dummyOff = CGAffineTransformMakeTranslation(-50, 0)
            oldOff = CGAffineTransformMakeTranslation(50, 0)
        }
        
        
        let cp = dummyLabel.center.y
        
        self.addSubview(dummyLabel)
        
        oldLabel.transform = oldOff
        oldLabel.alpha = 0
        
        switch oldLabel.text! {
        case "\(filterStudioLabel.text!)":
            oldLabel.text = self.studios[self.counter["Studios"]! % self.studios.count]
            break
        case "\(filterAgeLabel.text!)":
            oldLabel.text = self.ages[self.counter["Ages"]! % self.ages.count]
            break
        case "\(filterCategoryLabel.text!)":
            oldLabel.text = self.categories[self.counter["Categories"]! % self.categories.count]
            break
        case "\(filterDayLabel.text!)":
            oldLabel.text = self.days[self.counter["Days"]! % self.days.count]
            break
        default: break
        }
        

        
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.1, options: [], animations: { () -> Void in
            dummyLabel.transform = dummyOff
            dummyLabel.alpha = 0
            
            oldLabel.transform = CGAffineTransformIdentity
            oldLabel.alpha = 1
            
//            oldLabel.text = dummyLabel.text
            
        }) { (finished) -> Void in
            if finished {
                dummyLabel.removeFromSuperview()
            }
        }
        
        
        
//        filterStudioLabel.text = studios[counter["Studios"]! % studios.count]
//        filterAgeLabel.text = ages[counter["Ages"]! % ages.count]
//        filterCategoryLabel.text = categories[counter["Categories"]! % categories.count]
//        filterDayLabel.text = days[counter["Days"]! % 3]
        
        
    
        


        
    }
    
   
}
