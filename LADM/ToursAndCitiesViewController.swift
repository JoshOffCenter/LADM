//
//  ViewController.swift
//  LADM
//
//  Created by Josh Carter on 4/13/15.
//  Copyright (c) 2015 MoonBase. All rights reserved.
//

import UIKit

class ToursAndCitiesViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

   //Transition Manager
   let transitionManager = TransitionManager()
   var menuButtonPressed = false
   
   @IBOutlet weak var selectCityButton: UIButton!
   
   @IBOutlet weak var selectCityView: SelectCityView!
   
   
   var selectedCity = "Select City"
   
   let pickerData = ["Select City" ,"Santa Rosa", "San Francisco", "Houston", "New York"]
   
    override func viewDidLoad() {
      super.viewDidLoad()
      selectCityView.cityPickerView.dataSource = self
      selectCityView.cityPickerView.delegate = self
      addBlur()
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
   
   @IBAction func selectCityPressed(sender: AnyObject) {
      animateSelectCityView(false)
   }
   
   
   @IBAction func selectCityCancelPressed(sender: AnyObject) {
      animateSelectCityView(true)

   }
   
   @IBAction func selectCityDonePressed(sender: AnyObject) {
      animateSelectCityView(true)
      selectCityButton.setTitle(selectedCity, forState: .Normal)
      selectCityButton.titleLabel?.font = UIFont(name: "AvenirNext-Medium", size: 25)
      selectCityButton.titleLabel?.textAlignment = .Center
   }
   
   @IBAction func selectCityRowPressed(sender: AnyObject) {
      animateSelectCityView(true)
      selectCityButton.setTitle(selectedCity, forState: .Normal)
      selectCityButton.titleLabel?.font = UIFont(name: "AvenirNext-Medium", size: 25)
      selectCityButton.titleLabel?.textAlignment = .Center
   }
   
   
   func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
      return 1
   }
   
   func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
      return pickerData.count
   }
   
   func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
      return pickerData[row]
   }
   
   func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
      
      selectedCity = pickerData[row]
   }
   
   
   
   func addBlur() {
      let blurEffect: UIBlurEffect = UIBlurEffect(style: .Light)
      let blurView: UIVisualEffectView = UIVisualEffectView(effect: blurEffect)
//      blurView.setTranslatesAutoresizingMaskIntoConstraints(false)
      blurView.frame = CGRectMake(0, 0, selectCityView.bounds.width, selectCityView.bounds.height + 50)
//      blurView.frame = selectCityView.bounds
      selectCityView.insertSubview(blurView, atIndex: 0)
   }
   
   func animateSelectCityView(shouldSlideOff: Bool) {
      var slideDirection: CGAffineTransform!
      if shouldSlideOff == true {
          slideDirection = CGAffineTransformMakeTranslation(0, 10)
      }
      else {
          slideDirection = CGAffineTransformMakeTranslation(0, -selectCityView.frame.height + 20)
      }
      
      UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: nil, animations: { () -> Void in
            self.selectCityView.transform = slideDirection
      }, completion: nil)
      
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

