//
//  ViewController.swift
//  LADM
//
//  Created by Josh Carter on 4/13/15.
//  Copyright (c) 2015 MoonBase. All rights reserved.
//

import UIKit

class ToursAndCitiesViewController: UIViewController {

   //Transition Manager
   let transitionManager = TransitionManager()
   var menuButtonPressed = false
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
   @IBAction func menuButtonPressed(sender: AnyObject) {
      menuButtonPressed = true
      performSegueWithIdentifier("presentMenuSegue", sender: self)
      
   }

   @IBAction func competitionOrderPressed(sender: AnyObject) {
      let vc = self.storyboard?.instantiateViewControllerWithIdentifier("CompOrderViewController") as! CompOrderViewController
      let customSegue = CustomSlideSegue(identifier: "anyid", source: self, destination: vc, shouldUnwind: false)
      customSegue.perform()
   }
   
   
   override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      if menuButtonPressed == true {
         let toViewController = segue.destinationViewController as! UIViewController
         toViewController.transitioningDelegate = self.transitionManager
         menuButtonPressed = false
      }
   }
   
   override func segueForUnwindingToViewController(toViewController: UIViewController, fromViewController: UIViewController, identifier: String?) -> UIStoryboardSegue {
      return CustomSlideSegue(identifier: identifier, source: fromViewController, destination: toViewController, shouldUnwind: true)
   }
   
   @IBAction func unwindToTourCitiesViewController(sender: UIStoryboardSegue) {
//      self.dismissViewControllerAnimated(true, completion: nil)
      
   }


}

