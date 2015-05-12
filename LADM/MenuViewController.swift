//
//  MenuViewController.swift
//  LADM
//
//  Created by Chance Daniel on 4/27/15.
//  Copyright (c) 2015 MoonBase. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    
    //Contact Menu Constraints
    @IBOutlet weak var contactMenuConstraintHorizontalCenter: NSLayoutConstraint!
    @IBOutlet weak var contactMenuConstraintVerticalCenter: NSLayoutConstraint!
    
    //Button Constraints
    @IBOutlet weak var phoneButtonConstraintTop: NSLayoutConstraint!
    @IBOutlet weak var phoneButtonConstraintCenter: NSLayoutConstraint!
    
    @IBOutlet weak var emailButtonConstraintBottom: NSLayoutConstraint!
    @IBOutlet weak var emailButtonConstraintCenter: NSLayoutConstraint!
   
   @IBOutlet weak var tourCitiesButton: UIButton!
   @IBOutlet weak var tourCitiesLabel: UILabel!
   
   @IBOutlet weak var eventFeedButton: UIButton!
   @IBOutlet weak var eventFeedLabel: UILabel!
   
   @IBOutlet weak var contactButton: UIButton!
   @IBOutlet weak var contactLabel: UILabel!
   
   @IBOutlet weak var socialMediaButton: UIButton!
   @IBOutlet weak var socialMediaLabel: UILabel!
    
    @IBOutlet weak var contactMenu: ContactMenu!
    @IBOutlet weak var phoneButton: UIButton!
    @IBOutlet weak var emailButton: UIButton!
    
    var contactMenuOpen = false
    
    override func viewDidLoad() {
        contactMenu.removeFromSuperview()
    }
    
    
    @IBAction func back(sender: AnyObject) {
        if contactMenuOpen == false {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        else {
            closeContactMenu()
        }
        
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
    
    @IBAction func contactButtonPressed(sender: AnyObject) {
        setupContactMenu()
        let scaleDown = CGAffineTransformMakeScale(0.75, 0.75)
        let scaleUp = CGAffineTransformMakeScale(1, 1)
        contactMenu.transform = scaleDown
        UIView.animateWithDuration(2, delay: 0, usingSpringWithDamping: 0.25, initialSpringVelocity: 10, options: nil, animations: { () -> Void in
            self.contactMenu.transform = scaleUp
        }, completion: nil)
        contactMenuOpen = true
        
    }
    
    func closeContactMenu() {
        let scaleDown = CGAffineTransformMakeScale(0.75, 0.75)

        UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 10, initialSpringVelocity: 5, options: nil, animations: { () -> Void in
                self.contactMenu.transform = scaleDown
                self.contactMenu.alpha = 0
        }) { (finished) -> Void in
            if finished {
                self.contactMenu.removeFromSuperview()
                self.contactMenu.alpha = 1
                self.contactMenuOpen = false
            }
        }

        
    }
    
    func setupContactMenu() {
        self.view.addSubview(contactMenu)
        contactMenu.frame = CGRectMake(0, 0, 300, 350)
        self.view.addConstraints([contactMenuConstraintHorizontalCenter, contactMenuConstraintVerticalCenter])
    }
   

   
   override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
   }
   

   @IBAction func unwindToMainViewController(sender: UIStoryboardSegue) {
      self.dismissViewControllerAnimated(true, completion: nil)
   }
   
}
