//
//  ViewController.swift
//  LADM
//
//  Created by Josh Carter on 4/13/15.
//  Copyright (c) 2015 MoonBase. All rights reserved.
//

import UIKit
var cityData = Dictionary<String,CityData>()
var selectedCity = "Select City"


class ToursAndCitiesViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

   //Transition Manager
    let transitionManager = TransitionManager()
    var menuButtonPressed = false
    var dataFetcher = DataFetcher()
    let pickerData = ["Select City"] + DataFetcher().getCities()

    @IBOutlet weak var scheduleButton: UIButton!
    @IBOutlet weak var competitionOrderButton: UIButton!
    @IBOutlet weak var competitionResultsButton: UIButton!
    @IBOutlet weak var specialtyAwardsButton: UIButton!
    
   @IBOutlet weak var selectCityButton: UIButton!
   @IBOutlet weak var selectCityView: SelectCityView!
   @IBOutlet weak var dismissButton: UIButton!
   
   @IBOutlet weak var dismissButtonConstraintLeft: NSLayoutConstraint!
   @IBOutlet weak var dismissButtonConstraintTop: NSLayoutConstraint!
   @IBOutlet weak var dismissButtonConstraintRight: NSLayoutConstraint!
   @IBOutlet weak var dismissButtonConstraintBottom: NSLayoutConstraint!
   
    
//   let pickerData = ["Select City" ,"Santa Rosa", "San Francisco", "Houston", "New York", "Irvine National Finals"]
   
    override func viewDidLoad() {
      super.viewDidLoad()
      selectCityView.cityPickerView.dataSource = self
      selectCityView.cityPickerView.delegate = self
      addBlur()
        buttonShade()
        
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
      cityData[selectedCity] = CityData(city: selectedCity.stringByReplacingOccurrencesOfString(" ", withString: "_"))
        buttonShade()
   }
   
   @IBAction func selectCityRowPressed(sender: AnyObject) {
      animateSelectCityView(true)
      selectCityButton.setTitle(selectedCity, forState: .Normal)
      selectCityButton.titleLabel?.font = UIFont(name: "AvenirNext-Medium", size: 25)
      selectCityButton.titleLabel?.textAlignment = .Center
      cityData[selectedCity] = CityData(city: selectedCity.stringByReplacingOccurrencesOfString(" ", withString: "_"))
        buttonShade()
   }
    
   
   
   @IBAction func dismissButtonPressed(sender: AnyObject) {
      animateSelectCityView(true)
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
         self.dismissButton.removeFromSuperview()
      }
      else {
          slideDirection = CGAffineTransformMakeTranslation(0, -selectCityView.frame.height + 20)
      }
      
      UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: nil, animations: { () -> Void in
            self.selectCityView.transform = slideDirection
      }, completion: nil)
      
      if shouldSlideOff == false {
         self.view.insertSubview(dismissButton, belowSubview: selectCityView)

         self.view.addConstraints([dismissButtonConstraintLeft, dismissButtonConstraintRight, dismissButtonConstraintTop, dismissButtonConstraintBottom])
         
      }
      else {
         self.dismissButton.removeFromSuperview()
      }
      
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

      
   }
    
    func buttonShade() {
        if selectedCity == "Select City" {
            competitionOrderButton.enabled = false
            competitionResultsButton.enabled = false
            specialtyAwardsButton.enabled = false
            scheduleButton.enabled = false
            return
        }
        var cd = cityData[selectedCity]
        if cd!.competitionSchedule.count == 0 {
            competitionOrderButton.enabled = false
        }
        else{
            competitionOrderButton.enabled = true
        }
        if cd!.dailySchedule.count == 0 {
            scheduleButton.enabled = false
        }
        else {
            scheduleButton.enabled = true
        }
        if cd!.specialtyAwards.count == 0 {
            specialtyAwardsButton.enabled = false
        }
        else {
            specialtyAwardsButton.enabled = true
        }
        if cd!.competitionResults.count == 0 {
            competitionResultsButton.enabled = false
        }
        else {
            competitionResultsButton.enabled = true
        }
    }
    

}

