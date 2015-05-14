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
   
   //Filter Menu Constraints
//   @IBOutlet weak var filterFilterByConstraintCenter: NSLayoutConstraint!
//   @IBOutlet weak var filterFilterByConstraintTop: NSLayoutConstraint!
//   @IBOutlet weak var filterFilterByConstraintBottom: NSLayoutConstraint!
//   
//   @IBOutlet weak var filterDividerConstraintLeft: NSLayoutConstraint!
//   @IBOutlet weak var filterDividerConstraintRight: NSLayoutConstraint!
//   
//   @IBOutlet weak var filterAgeConstraintTop: NSLayoutConstraint!
//   @IBOutlet weak var filterAgeConstraintLeft: NSLayoutConstraint!
//   @IBOutlet weak var filterAgeConstraintRight: NSLayoutConstraint!
//   
//   @IBOutlet weak var filterCategoryConstraintTop: NSLayoutConstraint!
//   @IBOutlet weak var filterCategoryConstraintLeft: NSLayoutConstraint!
//   @IBOutlet weak var filterCategoryConstraintRight: NSLayoutConstraint!
//   
//   @IBOutlet weak var filterDivisionConstraintTop: NSLayoutConstraint!
//   @IBOutlet weak var filterDivisionConstraintLeft: NSLayoutConstraint!
//   @IBOutlet weak var filterDivisionConstraintRight: NSLayoutConstraint!
//   
//   @IBOutlet weak var filterFavoritesConstraintTop: NSLayoutConstraint!
//   @IBOutlet weak var filterFavoritesConstraintLeft: NSLayoutConstraint!
//   @IBOutlet weak var filterFavoritesConstraintRight: NSLayoutConstraint!
//   
//   @IBOutlet weak var filterButtonConstraintTop: NSLayoutConstraint!
//   @IBOutlet weak var filterButtonConstraintBottom: NSLayoutConstraint!
//   @IBOutlet weak var filterButtonConstraintHeight: NSLayoutConstraint!
//   @IBOutlet weak var filterButtonConstraintWidth: NSLayoutConstraint!
//   @IBOutlet weak var filterButtonConstraintCenter: NSLayoutConstraint!
//   
//   @IBOutlet weak var filterMenuTopConstraint: NSLayoutConstraint!
//   
//   @IBOutlet weak var invisibleFilterButtonTopConstraint: NSLayoutConstraint!
//   @IBOutlet weak var invisibleFilterButtonBottomConstraint: NSLayoutConstraint!
   
   //Dismiss Button
   @IBOutlet weak var dismissButton: UIButton!
   
   @IBOutlet weak var dismissButtonConstraintLeft: NSLayoutConstraint!
   @IBOutlet weak var dismissButtonConstraintTop: NSLayoutConstraint!
   @IBOutlet weak var dismissButtonConstraintRight: NSLayoutConstraint!
   @IBOutlet weak var dismissButtonConstraintBottom: NSLayoutConstraint!
   
    @IBOutlet weak var invisibleFilterButton: UIButton!
   
   var compEvents = [CompEventItem]()
   var selectedIndexPath: NSIndexPath? = nil
   var lastSelectedIndexPath: NSIndexPath? = nil
   var cellExpanded = false
   
   override func viewWillAppear(animated: Bool) {
//      if tableView.numberOfRowsInSection(0) <= 0 {
//         compEvents.append(event1)
//         compEvents.append(event2)
//         compEvents.append(event3)
//         compEvents.append(event4)
//         compEvents.append(event5)
//        
//      }
        fillData()
    
    
//      filterMenuView.hidden = true
   }
   
   //Transition Manager
   let transitionManager = TransitionManager()

   
   override func viewDidLoad() {
      

      tableView.estimatedRowHeight = 80.0;
//      setupFilterMenu()
      setupGestures()

   }
   override func viewDidAppear(animated: Bool) {
      tableView.reloadData()
   }
   
   func setupFilterMenu() {
//      if filterMenuExpanded == true {
//         filterMenuView.filterByLabel.removeFromSuperview()
//         filterMenuView.filterDividerLabel.removeFromSuperview()
//         filterMenuView.filterAgeButton.removeFromSuperview()
//         filterMenuView.filterCategoryButton.removeFromSuperview()
//         filterMenuView.filterDivisionButton.removeFromSuperview()
//         filterMenuView.filterFavoritesButton.removeFromSuperview()
//         filterMenuExpanded = false
//      }
    
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
   
//   func expandFilterMenuDEPREICATED() {
//      let compactMenuSize:CGFloat = 40
//      let fullMenuSize:CGFloat = self.view.frame.height - 200
//      if filterMenuExpanded == false {
//         
//         filterMenuView.addSubview(filterMenuView.filterByLabel)
//         filterMenuView.addSubview(filterMenuView.filterDividerLabel)
//         filterMenuView.addSubview(filterMenuView.filterAgeButton)
//         filterMenuView.addSubview(filterMenuView.filterCategoryButton)
//         filterMenuView.addSubview(filterMenuView.filterDivisionButton)
//         filterMenuView.addSubview(filterMenuView.filterFavoritesButton)
//         
////         filterMenuView.removeConstraint(invisibleFilterButtonTopConstraint)
//         
//         filterMenuView.addConstraints([self.filterAgeConstraintLeft,self.filterAgeConstraintRight,self.filterAgeConstraintTop, self.filterButtonConstraintBottom, self.filterButtonConstraintHeight, self.filterButtonConstraintTop, self.filterButtonConstraintWidth, self.filterCategoryConstraintLeft, self.filterCategoryConstraintRight, self.filterCategoryConstraintTop, self.filterDividerConstraintLeft, self.filterDividerConstraintRight, self.filterDivisionConstraintLeft, self.filterDivisionConstraintRight, self.filterDivisionConstraintTop, self.filterFavoritesConstraintLeft, self.filterFavoritesConstraintRight, self.filterFavoritesConstraintTop, self.filterFilterByConstraintBottom, self.filterFilterByConstraintCenter, self.filterFilterByConstraintTop, /*self.invisibleFilterButtonBottomConstraint*/])
//
//         
//         UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.2, options: nil, animations: { () -> Void in
////            self.filterMenuView.frame.size = CGSizeMake(self.filterMenuView.frame.width, self.filterMenuView.frame.height + 30)
//            self.filterMenuView.frame.size = CGSizeMake(self.filterMenuView.frame.width, fullMenuSize)
//            
//            
//            }, completion: nil)
//         
//         UIView.animateWithDuration(0.25, animations: { () -> Void in
//            self.filterMenuView.filterMenuButton.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
//         })
//         
//         self.view.insertSubview(dismissButton, belowSubview: filterMenuView)
//         self.view.addConstraints([dismissButtonConstraintBottom, dismissButtonConstraintLeft, dismissButtonConstraintRight, dismissButtonConstraintTop])
//         
//         filterMenuExpanded = true
//      }
//      else {
//   
//         filterMenuView.filterByLabel.removeFromSuperview()
//         
//         UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: nil, animations: { () -> Void in
//            self.filterMenuView.frame.size = CGSizeMake(self.filterMenuView.frame.width, compactMenuSize)
//            
//            }, completion: { (finished) -> Void
//               in
//               if finished {
//               
//                  self.setupFilterMenu()
////                  self.filterMenuView.removeConstraint(self.invisibleFilterButtonBottomConstraint)
////                  self.filterMenuView.addConstraint(self.invisibleFilterButtonTopConstraint)
//               }
//         })
//         
//         UIView.animateWithDuration(0.25, animations: { () -> Void in
//            self.filterMenuView.filterMenuButton.transform = CGAffineTransformMakeRotation(CGFloat(M_PI/2))
//            self.filterMenuView.filterMenuButton.transform = CGAffineTransformIdentity
//
//         }, completion: nil)
//         self.dismissButton.removeFromSuperview()
//
//      }
//   }
    
   override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      let toViewController = segue.destinationViewController as! UIViewController
      toViewController.transitioningDelegate = self.transitionManager
   }
   
   


   
   
}
