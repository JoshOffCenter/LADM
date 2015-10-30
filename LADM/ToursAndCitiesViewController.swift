//
//  ViewController.swift
//  LADM
//
//  Created by Josh Carter on 4/13/15.
//  Copyright (c) 2015 MoonBase. All rights reserved.
//

import UIKit
import Parse

//var cityData = Dictionary<String,CityData>()
var selectedCity = "Select City"


class ToursAndCitiesViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

   //Transition Manager
    let transitionManager = TransitionManager()
    var menuButtonPressed = false
//    var dataFetcher = DataFetcher()
    var dataManager: DataManager!
    var pickerData = ["Select City"]

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
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var menuButton: UIBarButtonItem!

    @IBOutlet weak var animButton: UIButton!

    
    
//   let pickerData = ["Select City" ,"Santa Rosa", "San Francisco", "Houston", "New York", "Irvine National Finals"]
    
    override func viewDidAppear(animated: Bool) {
        dataManager = DataManager.sharedInstance
    }
   
    override func viewDidLoad() {
      super.viewDidLoad()
      selectCityButton.enabled = false
      selectCityView.cityPickerView.dataSource = self
      selectCityView.cityPickerView.delegate = self
      addBlur()
        buttonShade()
        setupNavBar()
        
        competitionOrderButton.layer.cornerRadius = 5
        scheduleButton.layer.cornerRadius = 5
        competitionResultsButton.layer.cornerRadius = 5
        specialtyAwardsButton.layer.cornerRadius = 5
        
//            self.testButton.setImage(UIImage(named: "HamArrow_00000"), forState: .Normal)
        
//        self.menuButton.setBackgroundImage(UIImage.animatedImageNamed("HamArrow", duration: 1), forState: UIControlState.Normal, barMetrics: UIBarMetrics.Default)
//       self.animButton.setImage(UIImage.animatedImageNamed("HamArrow", duration: 2), forState: UIControlState.Normal)
        
        setupDataManagerNotification()
    
    }
    

    override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
        
    }
   
   @IBAction func menuButtonPressed(sender: AnyObject) {
      menuButtonPressed = true
    

      performSegueWithIdentifier("presentMenuSegue", sender: self)
    
   
    
//    self.menuButton.setBackgroundImage(UIImage.animatedImageNamed("HamArrow", duration: 1), forState: UIControlState.Normal, barMetrics: UIBarMetrics.Default)

    
   }
    
    func setupNavBar() {
        navBar.barTintColor = self.view.backgroundColor
        
        navBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        navBar.shadowImage = UIImage()
        let textAttributes: [String : AnyObject]! = [NSForegroundColorAttributeName : UIColor.whiteColor(), NSFontAttributeName : UIFont(name: "Avenir Next Ultra Light", size: 20)!]
        navBar.titleTextAttributes = textAttributes

    }
    
    func setupDataManagerNotification() {
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "enableSelectCityButton",
            name: "parseLoginCompleted",
            object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "buttonShade",
            name: "changeButtonShade",
            object: nil)
        
        
    }

    @IBAction func schedulePressed(sender: UIButton) {
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("ScheduleViewController") as! ScheduleViewController
        let customSegue = CustomSlideSegue(identifier: "anyid", source: self, destination: vc, shouldUnwind: false)
        customSegue.perform()
    }
    
    @IBAction func specialtyAwardPressed(sender: UIButton) {
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("SpecialtyAwardsViewController") as! SpecialtyAwardsViewController
        let customSegue = CustomSlideSegue(identifier: "anyid", source: self, destination: vc, shouldUnwind: false)
        customSegue.perform()
    }
    
    @IBAction func competitionOrderTouchDown(sender: AnyObject, forEvent event: UIEvent) {
        feedbackAnimation(sender, event: event)
    }
    @IBAction func competitionOrderPressed(sender: AnyObject, event: UIEvent) {
    
      let vc = self.storyboard?.instantiateViewControllerWithIdentifier("CompOrderViewController") as! CompOrderViewController
      let customSegue = CustomSlideSegue(identifier: "anyid", source: self, destination: vc, shouldUnwind: false)
      customSegue.perform()
        feedbackAnimation(sender, event: event)
   }
   
    @IBAction func selectCityPressed(sender: AnyObject, event: UIEvent) {
      animateSelectCityView(false)
        
        for city: PFObject in dataManager.cities {
            if (!pickerData.contains((city.objectForKey("city") as! String))) {
                pickerData.append((city.objectForKey("city") as! String))
            }
        }
        self.selectCityView.cityPickerView.reloadAllComponents()
        
   }
   
   
   @IBAction func selectCityCancelPressed(sender: AnyObject) {
      animateSelectCityView(true)

   }
   
   @IBAction func selectCityDonePressed(sender: AnyObject) {
        citySelectedFromPickerView()
   }
   
    @IBAction func selectCityRowPressed(sender: AnyObject) {
        citySelectedFromPickerView()
    }
    
    func citySelectedFromPickerView() {
        animateSelectCityView(true)
        selectCityButton.setTitle(selectedCity, forState: .Normal)
        selectCityButton.titleLabel?.font = UIFont(name: "AvenirNext-Medium", size: 25)
        selectCityButton.titleLabel?.textAlignment = .Center
//        cityData[selectedCity] = CityData(city: selectedCity.stringByReplacingOccurrencesOfString(" ", withString: "_"))
        
        dataManager.pullCity(selectedCity, vc: self)
        
//        buttonShade()
        
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
      
      UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: [], animations: { () -> Void in
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

    @IBAction func scheduleButtonDown(sender: AnyObject, forEvent event: UIEvent) {
        feedbackAnimation(sender, event: event)
    }

    @IBAction func specialtyAwardsDown(sender: AnyObject, forEvent event: UIEvent) {
        feedbackAnimation(sender, event: event)
    }
    @IBAction func competitionResultsButtonPressed(sender: UIButton) {
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("CompetitionResultsViewController") as! CompetitionResultsViewController
        let customSegue = CustomSlideSegue(identifier: "anyid", source: self, destination: vc, shouldUnwind: false)
        customSegue.perform()
    }
    
    @IBAction func competitionResultsButtonDown(sender: AnyObject, forEvent event: UIEvent) {
        feedbackAnimation(sender, event: event)
    }

    func feedbackAnimation(sender: AnyObject, event: UIEvent) {
        let buttonView = sender as! UIView
        buttonView.clipsToBounds = true
        //buttonView.backgroundColor = UIColor.clearColor()
        if let touch = event.touchesForView(buttonView)?.first as UITouch! {
            let point = touch.locationInView(buttonView)
        
//        self.view.addSubview(buttonView)
        
            let radius: CGFloat = 2.5
            let seed = UIView(frame: CGRectMake(0, 0, 2 * radius, 2 * radius))
            seed.center = point
            seed.alpha = 0.3
            
            seed.backgroundColor = UIColor.lightGrayColor()
            seed.layer.cornerRadius = radius
            buttonView.addSubview(seed)
            
        
            UIView.animateWithDuration(1.3, delay: 0, options: [], animations: { () -> Void in
                let scaleTransform = CGAffineTransformMakeScale(buttonView.frame.width, buttonView.frame.width)
                seed.transform = scaleTransform
                
                UIView.animateWithDuration(0.1, delay: 0.1, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                    seed.alpha = 0
                }, completion: nil)
                
            }) { (finished) -> Void in
                seed.removeFromSuperview()
            }
        }
    }
    
    
//    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
//        let touch = touches.first as! UITouch
//        touchLocation = touch.locationInView(animationView)
//        
//    }
   
   override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      if menuButtonPressed == true {
         let toViewController = segue.destinationViewController 
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
        scheduleButton.enabled = false
        competitionOrderButton.enabled = false
        competitionResultsButton.enabled = false
        specialtyAwardsButton.enabled = false
        if selectedCity == "Select City" {
            return
        }

        if dataManager.scheduleItems.count > 0 {
            scheduleButton.enabled = true
            scheduleButton.setNeedsDisplay()
        }
            
        if dataManager.competitionItems.count > 0 {
            competitionOrderButton.enabled = true
        }
            
        if dataManager.resultItems.count > 0 {
            competitionResultsButton.enabled = true
        }
        
        if dataManager.specialtyItems.count > 0 {
            specialtyAwardsButton.enabled = true
        }
    }
    
    func enableSelectCityButton () {
        selectCityButton.enabled = true
    }
    

}

