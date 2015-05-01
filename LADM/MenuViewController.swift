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
    
    @IBAction func back(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
   
   @IBAction func tourCitesAndDatesPressed(sender: AnyObject) {
      let menuVC = self
      if let presenter = self.presentingViewController {
         if presenter.isKindOfClass(ToursAndCitiesViewController){
            self.dismissViewControllerAnimated(true, completion: nil)
         }
         else {
            let pVC = self.presentingViewController
            self.dismissViewControllerAnimated(true, completion: { () -> Void in
               pVC!.performSegueWithIdentifier("unwindToTourCities", sender: pVC)
            })

         }
      
      }
      
   }
   
//   func getInstanceOfExistingViewController(child: UIViewController, classKey: AnyClass) -> UIViewController? {
//      
//      var vc = UIViewController()
//      if let parent = child.presentingViewController {
//         if parent.isKindOfClass(classKey){
//            vc = parent
//         }
//         else {
//            vc = getInstanceOfExistingViewController(parent, classKey: classKey)!
//         }
//      }
//      else {
//      }
//      return vc
//   }
   
   override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//      self.dismissViewControllerAnimated(false, completion: nil)
   }
   

   @IBAction func unwindToMainViewController(sender: UIStoryboardSegue) {
      // bug? exit segue doesn't dismiss so we do it manually...
      self.dismissViewControllerAnimated(true, completion: nil)
   }
   
}
