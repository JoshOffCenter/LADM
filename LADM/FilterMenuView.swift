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
   @IBOutlet weak var filterAgeButton: UIButton!
   @IBOutlet weak var filterCategoryButton: UIButton!
   @IBOutlet weak var filterDivisionButton: UIButton!
   @IBOutlet weak var filterFavoritesButton: UIButton!
   @IBOutlet weak var filterMenuButton: UIButton!


   

   required init(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
      
      self.roundCorners(.BottomLeft | .BottomRight, radius: 5)
      
   }
   
}
