//
//  MenuViewController.swift
//  LADM
//
//  Created by Chance Daniel on 4/27/15.
//  Copyright (c) 2015 MoonBase. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
   
   
   @IBOutlet weak var tourCitiesButton: UIButton!
   @IBOutlet weak var tourCitiesLabel: UILabel!
   
   @IBOutlet weak var eventFeedButton: UIButton!
   @IBOutlet weak var eventFeedLabel: UILabel!
   
   @IBOutlet weak var contactButton: UIButton!
   @IBOutlet weak var contactLabel: UILabel!
   
   @IBOutlet weak var socialMediaButton: UIButton!
   @IBOutlet weak var socialMediaLabel: UILabel!
   

   @IBAction func unwindToMainViewController(sender: UIStoryboardSegue) {
      // bug? exit segue doesn't dismiss so we do it manually...
      self.dismissViewControllerAnimated(true, completion: nil)
   }
   
}
