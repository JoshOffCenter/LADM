//
//  CompOrderViewController.swift
//  LADM
//
//  Created by Chance Daniel on 4/25/15.
//  Copyright (c) 2015 MoonBase. All rights reserved.
//

import UIKit
import Darwin

class CompOrderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
   //Table View
   @IBOutlet weak var tableView: UITableView!
   
   //Filter Menu
   @IBOutlet weak var filterMenuView: FilterMenuView!
//   let filterMenuView = filterMenuView as! FilterMenuView
//   @IBOutlet weak var filterMenuConstraintLeft: NSLayoutConstraint!
//   @IBOutlet weak var filterMenuConstraintRight: NSLayoutConstraint!
   
   var filterMenuExpanded = false
   

   
   //Dismiss Button
   @IBOutlet weak var dismissButton: UIButton!
   @IBOutlet weak var dismissButtonConstraintLeft: NSLayoutConstraint!
   @IBOutlet weak var dismissButtonConstraintTop: NSLayoutConstraint!
   @IBOutlet weak var dismissButtonConstraintRight: NSLayoutConstraint!
   @IBOutlet weak var dismissButtonConstraintBottom: NSLayoutConstraint!
   
    @IBOutlet weak var invisibleFilterButton: UIButton!
    
    //Navigation Bar
    @IBOutlet weak var navBar: UINavigationBar!
    
   
   var compEvents = [CompEventItem]()
   var selectedIndexPath: NSIndexPath? = nil
   var lastSelectedIndexPath: NSIndexPath? = nil
   var cellExpanded = false
   
   override func viewWillAppear(animated: Bool) {

        fillData()
    
   }
   
   //Transition Manager
   let transitionManager = TransitionManager()

   
   override func viewDidLoad() {
      

      tableView.estimatedRowHeight = 80.0;
    setupNavBar()
        setupGestures()

   }
   override func viewDidAppear(animated: Bool) {
      tableView.reloadData()
   }
    
    func setupNavBar() {
        navBar.barTintColor = self.filterMenuView.backgroundColor
        
        navBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        navBar.shadowImage = UIImage()
        let textAttributes = NSMutableDictionary(capacity:1)
        textAttributes.setObject(UIColor.whiteColor(), forKey: NSForegroundColorAttributeName)
        textAttributes.setObject(UIFont(name: "Avenir Next Ultra Light", size: 20)!, forKey: NSFontAttributeName)
        navBar.titleTextAttributes = textAttributes as [NSObject : AnyObject]
        
    }

    
    func fillData() {
        var data = cityData[selectedCity]!.competitionSchedule
        for (var i = 1; i < data.count;i++) {
            var number = data[String(i)]!
            var eventItem = CompEventItem(time: number["Time"]!, performanceTitle: number["Routine ID and Name"]!, studio: number["Studio Name"]!, age: number["Age"]!, category: number["Category"]!, division: number["Division"]!)
            compEvents.append(eventItem)
        }
    }

   
   func numberOfSectionsInTableView(tableView: UITableView) -> Int {
      //Return the number of sections.
      return 1
   }
   
   func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return compEvents.count
   }
   
   func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
      let cell = UITableViewCell(style: .Default, reuseIdentifier: "EventCell")
      let smallHeight: CGFloat = 80.0
      let expandedHeight: CGFloat = 200.0
      if selectedIndexPath != nil {
         if indexPath == selectedIndexPath! {
            cellExpanded = true
            return expandedHeight
         }
         else{
            cellExpanded = false
            return smallHeight
         }
      }
      else {
         cellExpanded = false
         return smallHeight
      }
   }
   
   func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
      let smallHeight: CGFloat = 80.0
      let expandedHeight: CGFloat = 200.0
      var item: CompEventItem
      var cell = tableView.dequeueReusableCellWithIdentifier("EventCell", forIndexPath: indexPath) as! EventCell

      cell.selectionStyle = .None
      
      item = compEvents[indexPath.row]
      cell.timeLabel.text = item.time
      cell.performanceTitleLabel.text = item.performanceTitle
      
      if cellExpanded == true {
         
         cell.addSubview(cell.studioLabel)
         cell.addSubview(cell.ageLabel)
         cell.addSubview(cell.categoryLabel)
         cell.addSubview(cell.divisionLabel)
         
         cell.addConstraints([cell.studioConstraintLeft, cell.studioConstraintRight, cell.studioConstraintTop, cell.ageConstraintCenter, cell.ageConstraintLeft, cell.ageConstraintRight, cell.categoryConstraintBottom, cell.categoryConstraintCenter, cell.categoryConstraintCenterY1, cell.categoryConstraintCenterY2, cell.categoryConstraintTop, cell.divisionConstraintLeft, cell.divisionConstraintRight])
      
         cell.studioLabel.text = item.studio
         cell.ageLabel.text = item.age
         cell.categoryLabel.text = item.category
         cell.divisionLabel.text = item.division
      }
      else {
         cell.studioLabel.removeFromSuperview()
         cell.ageLabel.removeFromSuperview()
         cell.categoryLabel.removeFromSuperview()
         cell.divisionLabel.removeFromSuperview()
      }
      
      return cell
   }
   
   func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
      var cell = tableView.cellForRowAtIndexPath(indexPath) as! EventCell
      switch selectedIndexPath {
      case nil:
         selectedIndexPath = indexPath
      default:
         if selectedIndexPath! == indexPath {
            selectedIndexPath = nil
         }
         else {
            selectedIndexPath = indexPath
         }
      }
      if lastSelectedIndexPath != nil {
         var cell = tableView.cellForRowAtIndexPath(lastSelectedIndexPath!) as! EventCell
         cell.studioLabel.removeFromSuperview()
         cell.ageLabel.removeFromSuperview()
         cell.categoryLabel.removeFromSuperview()
         cell.divisionLabel.removeFromSuperview()
      }
      tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
      lastSelectedIndexPath = selectedIndexPath
   }
   
   func verticalTranslation(amount: CGFloat) -> CGAffineTransform {
      return CGAffineTransformMakeTranslation(0, amount)
   }
   
   @IBAction func filterMenuPressed(sender: AnyObject) {
      expandFilterMenu()
   }
   
   @IBAction func invisibleFilterMenuButtonPressed(sender: AnyObject) {
      expandFilterMenu()
   }
   
   @IBAction func invisibleBottomFiltterMenuButtonPressed(sender: AnyObject) {
      expandFilterMenu()
   }
   
   @IBAction func dismissButtonPressed(sender: AnyObject) {
      expandFilterMenu()
   }
   
   @IBAction func backButtonPressed(sender: AnyObject) {
      self.performSegueWithIdentifier("unwindToTourCities", sender: self)

   }
    
    @IBAction func menuButtonPressed(sender: AnyObject) {
        performSegueWithIdentifier("presentMenuSegue", sender: self)
        
    }
    
    func setupGestures() {
        var swipeDown = UISwipeGestureRecognizer(target: self, action: Selector("handleGestures:"))
        var swipeUp = UISwipeGestureRecognizer(target: self, action: Selector("handleGestures:"))
        
        var pan = UIPanGestureRecognizer(target: self, action: Selector("handleGestures:"))
//        var dragUp = UIPanGestureRecognizer(target: self, action: Selector("handleGestures:"))
        
        swipeDown.direction = .Down
        swipeDown.direction = .Up
        
        filterMenuView.addGestureRecognizer(swipeDown)
        filterMenuView.addGestureRecognizer(swipeDown)
        filterMenuView.addGestureRecognizer(swipeUp)
        filterMenuView.addGestureRecognizer(pan)
    }
    
    func handleGestures(sender: UISwipeGestureRecognizer){
        if sender.isKindOfClass(UISwipeGestureRecognizer.self){
            if sender.direction == .Down && filterMenuExpanded == false{
//                self.expandFilterMenu()
            }
            else if sender.direction == .Up && filterMenuExpanded == true {
//                self.expandFilterMenu()
            }
        }
        else if sender.isKindOfClass(UIPanGestureRecognizer.self) {
            if sender.state == UIGestureRecognizerState.Began {
//                expandFilterMenu()
            }
        }
    }
    
    func expandFilterMenu() {
        
        if filterMenuExpanded == false {
            let expandFilterMenuTransform = CGAffineTransformMakeTranslation(0, filterMenuView.frame.height-80)
            UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.2, options: nil, animations: { () -> Void in
                self.filterMenuView.transform = expandFilterMenuTransform
            }, completion: nil)
            UIView.animateWithDuration(0.25, animations: { () -> Void in
//                self.filterMenuView.filterMenuButton.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
            })
            filterMenuExpanded = true
        }
        else {
            UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.15, options: nil, animations: { () -> Void in
                self.filterMenuView.transform = CGAffineTransformIdentity
                }, completion: nil)
        
            UIView.animateWithDuration(0.25, animations: { () -> Void in
//                 self.filterMenuView.filterMenuButton.transform = CGAffineTransformMakeRotation(CGFloat(M_PI/2))
                self.filterMenuView.filterMenuButton.transform = CGAffineTransformIdentity
            }, completion: nil)
            filterMenuExpanded = false
        
        }
        
        
    }
   
    
   override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      let toViewController = segue.destinationViewController as! UIViewController
      toViewController.transitioningDelegate = self.transitionManager
   }
   
   


   
   
}
