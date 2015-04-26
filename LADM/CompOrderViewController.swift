//
//  CompOrderViewController.swift
//  LADM
//
//  Created by Chance Daniel on 4/25/15.
//  Copyright (c) 2015 MoonBase. All rights reserved.
//

import UIKit

class CompOrderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
   
   //Table View
   @IBOutlet weak var tableView: UITableView!
   
   //Filter Menu
   @IBOutlet weak var filterMenuView: UIView!
   @IBOutlet weak var filterMenuConstraintLeft: NSLayoutConstraint!
   @IBOutlet weak var filterMenuConstraintRight: NSLayoutConstraint!
   
   
   
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
      compEvents.append(event1)
      compEvents.append(event2)
      compEvents.append(event3)
      compEvents.append(event4)
      compEvents.append(event5)
      
      filterMenuView.hidden = true
   }
   
   override func viewDidLoad() {
      
      
//      tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "EventCell")
//      tableView.separatorStyle = UITableViewCellSeparatorStyle.None
      
//      tableView.rowHeight = UITableViewAutomaticDimension;
      tableView.estimatedRowHeight = 80.0;

   }
   override func viewDidAppear(animated: Bool) {
      tableView.reloadData()
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
   
   @IBAction func filterMenuPressed(sender: AnyObject) {
      filterMenuView.hidden = false
   }
   
   @IBAction func closeFilterMenuPressed(sender: AnyObject) {
      filterMenuView.hidden = true
   }
   
   
   
   
}
