//
//  filterMenuView.swift
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

class filterMenuView: UIView {


   required init(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
      
      self.roundCorners(.BottomLeft | .BottomRight, radius: 5)
      
   }
   
}
