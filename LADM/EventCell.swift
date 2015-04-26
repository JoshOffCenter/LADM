//
//  eventCell.swift
//  LADM
//
//  Created by Chance Daniel on 4/25/15.
//  Copyright (c) 2015 MoonBase. All rights reserved.
//

import UIKit

class EventCell: UITableViewCell {
   
   @IBOutlet weak var timeLabel: UILabel!
   @IBOutlet weak var performanceTitleLabel: UILabel!
   
   @IBOutlet weak var studioLabel: UILabel!
   @IBOutlet weak var ageLabel: UILabel!
   @IBOutlet weak var categoryLabel: UILabel!
   @IBOutlet weak var divisionLabel: UILabel!
   
   
   //Constraints
   @IBOutlet weak var studioConstraintLeft: NSLayoutConstraint!
   @IBOutlet weak var studioConstraintRight: NSLayoutConstraint!
   @IBOutlet weak var studioConstraintTop: NSLayoutConstraint!
   
   @IBOutlet weak var ageConstraintCenter: NSLayoutConstraint!
   @IBOutlet weak var ageConstraintLeft: NSLayoutConstraint!
   @IBOutlet weak var ageConstraintRight: NSLayoutConstraint!
   
   @IBOutlet weak var categoryConstraintCenter: NSLayoutConstraint!
   @IBOutlet weak var categoryConstraintTop: NSLayoutConstraint!
   @IBOutlet weak var categoryConstraintBottom: NSLayoutConstraint!
   @IBOutlet weak var categoryConstraintCenterY1: NSLayoutConstraint!
   @IBOutlet weak var categoryConstraintCenterY2: NSLayoutConstraint!
   
   @IBOutlet weak var divisionConstraintLeft: NSLayoutConstraint!
   @IBOutlet weak var divisionConstraintRight: NSLayoutConstraint!
   
   
   
   
   @IBOutlet weak var favoriteButton: UIButton!
   
   @IBAction func favoriteButtonPressed(sender: AnyObject) {
      if favoriteButton.selected == true {
         favoriteButton.selected = false
      }
      else {
         favoriteButton.selected = true
      }
   }
}
