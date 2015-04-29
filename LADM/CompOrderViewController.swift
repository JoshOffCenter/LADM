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
   @IBOutlet weak var filterFilterByConstraintCenter: NSLayoutConstraint!
   @IBOutlet weak var filterFilterByConstraintTop: NSLayoutConstraint!
   @IBOutlet weak var filterFilterByConstraintBottom: NSLayoutConstraint!
   
   @IBOutlet weak var filterDividerConstraintLeft: NSLayoutConstraint!
   @IBOutlet weak var filterDividerConstraintRight: NSLayoutConstraint!
   
   @IBOutlet weak var filterAgeConstraintTop: NSLayoutConstraint!
   @IBOutlet weak var filterAgeConstraintLeft: NSLayoutConstraint!
   @IBOutlet weak var filterAgeConstraintRight: NSLayoutConstraint!
   
   @IBOutlet weak var filterCategoryConstraintTop: NSLayoutConstraint!
   @IBOutlet weak var filterCategoryConstraintLeft: NSLayoutConstraint!
   @IBOutlet weak var filterCategoryConstraintRight: NSLayoutConstraint!
   
   @IBOutlet weak var filterDivisionConstraintTop: NSLayoutConstraint!
   @IBOutlet weak var filterDivisionConstraintLeft: NSLayoutConstraint!
   @IBOutlet weak var filterDivisionConstraintRight: NSLayoutConstraint!
   
   @IBOutlet weak var filterFavoritesConstraintTop: NSLayoutConstraint!
   @IBOutlet weak var filterFavoritesConstraintLeft: NSLayoutConstraint!
   @IBOutlet weak var filterFavoritesConstraintRight: NSLayoutConstraint!
   
   @IBOutlet weak var filterButtonConstraintTop: NSLayoutConstraint!
   @IBOutlet weak var filterButtonConstraintBottom: NSLayoutConstraint!
   @IBOutlet weak var filterButtonConstraintHeight: NSLayoutConstraint!
   @IBOutlet weak var filterButtonConstraintWidth: NSLayoutConstraint!
   @IBOutlet weak var filterButtonConstraintCenter: NSLayoutConstraint!
   
   @IBOutlet weak var filterMenuTopConstraint: NSLayoutConstraint!
   
   
   //Test Data
   var event1 = CompEventItem(time: "3:30p", performanceTitle: "Circus", studio: "Progressions Elite", age: "JR", category: "Contemporary", division: "Group")
   var event2 = CompEventItem(time: "3:33p", performanceTitle: "Cookies", studio: "Progressions Elite", age: "JR", category: "Contemporary", division: "Group")
   var event3 = CompEventItem(time: "3:36p", performanceTitle: "Chapel of Love", studio: "Progressions Elite", age: "JR", category: "Contemporary", division: "Group")
   var event4 = CompEventItem(time: "3:39p", performanceTitle: "Crayola Doesn't Make A Decent Crayon", studio: "Progressions Elite", age: "JR",  category: "Contemporary", division: "Group")
   var event5 = CompEventItem(time: "3:43p", performanceTitle: "Funky Town", studio: "Progressions Elite", age: "JR", category: "Contemporary", division: "Group")
   
   
   var compEvents = [CompEventItem]()
   var selectedIndexPath: NSIndexPath? = nil
   var lastSelectedIndexPath: NSIndexPath? = nil
   var cellExpanded = false
   
   override func viewWillAppear(animated: Bool) {
      if tableView.numberOfRowsInSection(0) <= 0 {
         compEvents.append(event1)
         compEvents.append(event2)
         compEvents.append(event3)
         compEvents.append(event4)
         compEvents.append(event5)
      }
      
//      filterMenuView.hidden = true
   }
   
   //Transition Manager
   let transitionManager = TransitionManager()

   
   override func viewDidLoad() {
      
      
//      tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "EventCell")
//      tableView.separatorStyle = UITableViewCellSeparatorStyle.None
      
//      tableView.rowHeight = UITableViewAutomaticDimension;
      tableView.estimatedRowHeight = 80.0;
      setupFilterMenu()

   }
   override func viewDidAppear(animated: Bool) {
      tableView.reloadData()
   }
   
   func setupFilterMenu() {
//      let filterMenuView = filterMenuView as! FilterMenuView
      filterMenuView.filterByLabel.removeFromSuperview()
      filterMenuView.filterDividerLabel.removeFromSuperview()
      filterMenuView.filterAgeButton.removeFromSuperview()
      filterMenuView.filterCategoryButton.removeFromSuperview()
      filterMenuView.filterDivisionButton.removeFromSuperview()
      filterMenuView.filterFavoritesButton.removeFromSuperview()

//      if filterMenuExpanded == true {
//         filterMenuView.filterMenuButton.transform = CGAffineTransformMakeRotation(CGFloat(2*M_PI))
//         filterMenuExpanded = false
//      }
   
//      filterMenuView.addSubview(filterMenuView.filterMenuButton)
//      filterMenuView.filterMenuButton.removeFromSuperview()
      
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
   
   func expandFilterMenu() {
      if filterMenuExpanded == false {
//         let filterMenuView = self.filterMenuView as! FilterMenuView
         filterMenuView.addSubview(filterMenuView.filterByLabel)
         filterMenuView.addSubview(filterMenuView.filterDividerLabel)
         filterMenuView.addSubview(filterMenuView.filterAgeButton)
         filterMenuView.addSubview(filterMenuView.filterCategoryButton)
         filterMenuView.addSubview(filterMenuView.filterDivisionButton)
         filterMenuView.addSubview(filterMenuView.filterFavoritesButton)
         
         filterMenuView.addConstraints([self.filterAgeConstraintLeft,self.filterAgeConstraintRight,self.filterAgeConstraintTop, self.filterButtonConstraintBottom, self.filterButtonConstraintHeight, self.filterButtonConstraintTop, self.filterButtonConstraintWidth, self.filterCategoryConstraintLeft, self.filterCategoryConstraintRight, self.filterCategoryConstraintTop, self.filterDividerConstraintLeft, self.filterDividerConstraintRight, self.filterDivisionConstraintLeft, self.filterDivisionConstraintRight, self.filterDivisionConstraintTop, self.filterFavoritesConstraintLeft, self.filterFavoritesConstraintRight, self.filterFavoritesConstraintTop, self.filterFilterByConstraintBottom, self.filterFilterByConstraintCenter, self.filterFilterByConstraintTop])
         
         
         UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.7, options: nil, animations: { () -> Void in
            //         self.filterMenuView.alpha = 1
            //         self.filterMenuView.transform = self.verticalTranslation(20)
            self.filterMenuView.frame.size = CGSizeMake(self.filterMenuView.frame.width, self.filterMenuView.frame.height + 30)
            
            }, completion: nil)
         
         UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.filterMenuView.filterMenuButton.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
         })
         filterMenuExpanded = true
      }
      else {
   
//         let filterMenuView = self.filterMenuView as! FilterMenuView
         filterMenuView.filterByLabel.removeFromSuperview()
         
         UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: nil, animations: { () -> Void in

//            self.filterMenuView.filterMenuButton.transform = CGAffineTransformMakeRotation(CGFloat(0))
//            self.filterMenuView.filterMenuButton.transform = CGAffineTransformIdentity

            self.filterMenuView.frame.size = CGSizeMake(self.filterMenuView.frame.width, 40)
//            UIView.animateWithDuration(0.5, animations: { () -> Void in
//               //                     filterMenuView.filterMenuButton.transform = CGAffineTransformMakeRotation(CGFloat(-M_PI))
//               self.filterMenuView.filterMenuButton.transform = CGAffineTransformMakeRotation(CGFloat(2*M_PI))
//               
//            })
            
            }, completion: { (finished) -> Void
               in
               if finished {
               
                  self.setupFilterMenu()
               }
         })
         
         UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.filterMenuView.filterMenuButton.transform = CGAffineTransformMakeRotation(CGFloat(M_PI/2))
         }, completion: { (finished) -> Void in
            if finished {
               
               UIView.animateWithDuration(0.25, animations: { () -> Void in
                  self.filterMenuView.filterMenuButton.transform = CGAffineTransformIdentity
               })
            }
         })
        


      
         filterMenuExpanded = false
      }

   }
   
   
   override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      let toViewController = segue.destinationViewController as! UIViewController
      toViewController.transitioningDelegate = self.transitionManager
   }
   
   


   
   
}
