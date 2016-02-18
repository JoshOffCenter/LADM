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
    
    let dataManager = DataManager.sharedInstance
    var competitionItems = [CompetitionItem]()
    var competitionSections: [CompetitionItemSection]!


   
   //Table View
   @IBOutlet weak var tableView: UITableView!
   
   //Filter Menu
   @IBOutlet weak var filterMenuView: FilterMenuView!
//   let filterMenuView = filterMenuView as! FilterMenuView
//   @IBOutlet weak var filterMenuConstraintLeft: NSLayoutConstraint!
//   @IBOutlet weak var filterMenuConstraintRight: NSLayoutConstraint!
   
   var filterMenuExpanded = false
    let defaults = NSUserDefaults.standardUserDefaults()
    var shouldHideInstruction = false

    @IBAction func closeInstructionCell(sender: AnyObject) {
        shouldHideInstruction = true
        tableView.reloadData()
        
//        UIView.beginAnimations(nil, context: nil)
//        self.tableView.s
//        
//        [UIView beginAnimations:nil context:NULL];
//        [self.tableView setTableHeaderView:nil];
//        [UIView commitAnimations];
        
    }
   
   //Dismiss Button
   @IBOutlet weak var dismissButton: UIButton!
   @IBOutlet weak var dismissButtonConstraintLeft: NSLayoutConstraint!
   @IBOutlet weak var dismissButtonConstraintTop: NSLayoutConstraint!
   @IBOutlet weak var dismissButtonConstraintRight: NSLayoutConstraint!
   @IBOutlet weak var dismissButtonConstraintBottom: NSLayoutConstraint!
   
    @IBOutlet weak var invisibleFilterButton: UIButton!
    
    
    //Navigation Bar
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var menuButton: UIButton!
    
   
//   var compEvents = [CompEventItem]()
   var selectedIndexPath: NSIndexPath? = nil
   var lastSelectedIndexPath: NSIndexPath? = nil
   var cellExpanded = false
   
   override func viewWillAppear(animated: Bool) {

//        fillData()
    
   }
    
    override func viewWillDisappear(animated: Bool) {
        dataManager.competitionTableViewPostion = tableView.contentOffset.y;

    }
   
   //Transition Manager
//   let transitionManager = TransitionManager()

   
   override func viewDidLoad() {
    
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateTable:", name: "updateCompetitionOrder", object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "triggerReload:", name: "finishedUpdating", object: nil)

    
    shouldHideInstruction = defaults.boolForKey("shouldHideInstruction")
      
    competitionItems = dataManager.competitionItems
    competitionSections = splitSections(competitionItems)
    
//    competitionItems.sortInPlace({ $0.startTime.compare($1.startTime) == NSComparisonResult.OrderedAscending })
//    tableView.reloadData()

    
    tableView.estimatedRowHeight = 80.0;
    tableView.layer.cornerRadius = 10
    setupNavBar()
    setupGestures()
    dismissButton.enabled = false
    invisibleFilterButton.enabled = true
    

    
//    fillData(cityData[selectedCity]!.competitionSchedule)

    
    var delay = 0.2 * Double(NSEC_PER_SEC)
    var time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
    dispatch_after(time, dispatch_get_main_queue()) {
        self.menuButton.setImage(UIImage.animatedImageNamed("HamArrow", duration: 0.8), forState: UIControlState.Normal)
    }
    
    delay = 0.8 * Double(NSEC_PER_SEC)
    time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
    dispatch_after(time, dispatch_get_main_queue()) {
        self.menuButton.setImage(UIImage(named: "HamArrow20"), forState: UIControlState.Normal)
    }

    
    let dictionary: NSDictionary = ["studio" : "Any Studio", "age" : "Any Age", "category" : "Any Category", "day" : "Any Day"]
    competitionItems = dataManager.filterItemsWithDictionary(dataManager.competitionItems, dictionary: dictionary) as! [CompetitionItem]
    
    competitionSections = splitSections(competitionItems)


//    for item in competitionItems {
//        print(item.name + " " + String(item.startTime))
//    }
//    competitionItems.sortInPlace({ $0.startTime.compare($1.startTime) == NSComparisonResult.OrderedAscending })
    

    
    tableView.reloadData()
    tableView.contentOffset.y = dataManager.competitionTableViewPostion
//    scrollToCurrent()
   }
    
    
    func splitSections(itemArr: [CompetitionItem]) -> [CompetitionItemSection] {
        var arr = [CompetitionItemSection]()
        for item in itemArr {
            let day = item.day
            
            var found = false
            for s in arr {
                if s.day == day {
                    s.competitionItems.append(item)
                    found = true
                    break
                }
            }
            if !found {
                arr.append(CompetitionItemSection(day:day, firstItem: item))
            }
        }
        for s in arr {
//            s.competitionItems.sortInPlace({$0.startTime.compare($1.startTime) == .OrderedAscending})
            s.competitionItems.sortInPlace({
                return dateFixCompare($0, d2: $1)
            })
        
//            s.competitionItems.sortInPlace(dateFixCompare($0.startTime, $1.startTime))
        }
        arr.sortInPlace({$0.day < $1.day})
        return arr
    }
    
    func dateFixCompare(d1: CompetitionItem, d2: CompetitionItem) -> Bool {
        
        
        
        let d1Hour = NSCalendar.currentCalendar().component(.Hour, fromDate: d1.startTime)
        let d2Hour = NSCalendar.currentCalendar().component(.Hour, fromDate: d2.startTime)

        
        if d1Hour >= 16 && d1Hour <= 22 {
            if d2Hour >= 16 && d2Hour <= 22 {
                return d1.startTime.compare(d2.startTime) == .OrderedAscending
            }
            return false
        }
    
        else if( d2Hour >= 16 && d2Hour <= 22) {
            return true
        }
        
        
        return d1.startTime.compare(d2.startTime) == .OrderedAscending

        
//        NSCalendarUnit.
        
        
    }
    
   override func viewDidAppear(animated: Bool) {
      tableView.reloadData()
   }
    
    func updateTable(notification: NSNotification) {
        var currentCity = competitionItems[0].city
        var receivedDict = notification.object!
        if currentCity == receivedDict["city"]!! as! String {
            print("equals")
            dataManager.updateCompetition(currentCity)
        }
        tableView.reloadData()
        print("reloaded")
    }
    
    func triggerReload(notificaton: NSNotification) {
        print("triggered")
        let dictionary: NSDictionary = ["studio" : filterMenuView.filterStudioLabel.text!, "age" : filterMenuView.filterAgeLabel.text!, "category" : filterMenuView.filterCategoryLabel.text!, "day" : filterMenuView.filterDayLabel.text!]
        competitionItems = dataManager.competitionItems
        competitionItems = dataManager.filterItemsWithDictionary(dataManager.competitionItems, dictionary: dictionary) as! [CompetitionItem]
        
//        competitionItems.sortInPlace({ $0.startTime.compare($1.startTime) == NSComparisonResult.OrderedAscending })
        tableView.reloadData()
    }
    
    func setupNavBar() {
        navBar.barTintColor = self.filterMenuView.backgroundColor
        
        navBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        navBar.shadowImage = UIImage()
        let textAttributes: [String : AnyObject]! = [NSForegroundColorAttributeName : UIColor.whiteColor(), NSFontAttributeName : UIFont(name: "Avenir Next Ultra Light", size: 20)!]
        navBar.titleTextAttributes = textAttributes
        
    }

    
//    func fillData(data:Dictionary<String,Dictionary<String,String>>) {
//        compEvents.removeAll(keepCapacity: false)
//        for (var i = 1; i <= data.count;i++) {
//            var number = data[String(i)]!
//            let eventItem = CompEventItem(time: number["Time"]!, performanceTitle: number["Routine ID and Name"]!, studio: number["Studio Name"]!, age: number["Age"]!, category: number["Category"]!, division: number["Division"]!)
//            compEvents.append(eventItem)
//        }
//        tableView.reloadData()
//    }

   
   func numberOfSectionsInTableView(tableView: UITableView) -> Int {
      //Return the number of sections.
//      return 1
      return competitionSections.count
   }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if competitionSections[section].competitionItems.isEmpty {
            return nil
        }
        return competitionSections[section].day
    }

    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if !shouldHideInstruction {
            return 130
        }
        return 25
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if !shouldHideInstruction {
        let cellTableViewHeader = tableView.dequeueReusableCellWithIdentifier("InstructionCell")
        cellTableViewHeader!.frame = CGRectMake(0, 0, self.tableView.bounds.width, 130)
//        self.tableView.tableHeaderView = cellTableViewHeader
        
            return cellTableViewHeader
        }
        return nil

    }
   
   func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return competitionSections[section].competitionItems.count
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
        var item: CompetitionItem
        let cell = tableView.dequeueReusableCellWithIdentifier("EventCell", forIndexPath: indexPath) as! EventCell

        cell.selectionStyle = .None

        item = competitionSections[indexPath.section].competitionItems[indexPath.row]
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        dateFormatter.timeZone = NSTimeZone(name: "UTC")

        var dateString = dateFormatter.stringFromDate(item.startTime)
        if dateString.characters.first == "0"  {
            dateString = dateString.substringWithRange(Range<String.Index>(start: dateString.startIndex.advancedBy(1), end: dateString.endIndex))

        }
        
        cell.timeLabel.text = dateString
        cell.performanceTitleLabel.text = item.name
        cell.objectID = item.objectId
      
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
        
        if dataManager.favorites.containsObject(item.objectId) {
            cell.favoriteButton.selected = true
        }
        else {
            cell.favoriteButton.selected = false
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
        if let cell = tableView.cellForRowAtIndexPath(lastSelectedIndexPath!) as? EventCell {
         cell.studioLabel.removeFromSuperview()
         cell.ageLabel.removeFromSuperview()
         cell.categoryLabel.removeFromSuperview()
         cell.divisionLabel.removeFromSuperview()
        }
        
      }
      tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
      lastSelectedIndexPath = selectedIndexPath
   }
    
    func scrollToCurrent() {
        let timeZone = NSTimeZone.localTimeZone()
        let seconds = timeZone.secondsFromGMT
        let date = NSDate(timeIntervalSinceNow: NSTimeInterval(seconds))
        
        var indexPath = NSIndexPath(forItem: 0, inSection: 0)
        
        for var competitionIndex = 0; competitionIndex < competitionItems.count; competitionIndex++ {
            let item = competitionItems[competitionIndex]
            if item.startTime.earlierDate(date) == item.startTime {
                indexPath = NSIndexPath(forRow: competitionIndex, inSection: 0)
            }
        }
        if (date.timeIntervalSinceDate((competitionItems.last?.startTime)!) < 600) {
            tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Top, animated: true)
        }
        
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
        let swipeDown = UISwipeGestureRecognizer(target: self, action: Selector("handleGestures:"))
        let swipeUp = UISwipeGestureRecognizer(target: self, action: Selector("handleGestures:"))
        
        let pan = UIPanGestureRecognizer(target: self, action: Selector("handleGestures:"))
//        var dragUp = UIPanGestureRecognizer(target: self, action: Selector("handleGestures:"))
        
        swipeDown.direction = .Down
        swipeDown.direction = .Up
        
        
        let swipeBackGesture = UIScreenEdgePanGestureRecognizer(target: self, action: "handleLeftEdgeSwipe:")
        swipeBackGesture.edges = UIRectEdge.Left
        self.view.addGestureRecognizer(swipeBackGesture)
        
        filterMenuView.addGestureRecognizer(swipeDown)
        filterMenuView.addGestureRecognizer(swipeDown)
        filterMenuView.addGestureRecognizer(swipeUp)
        filterMenuView.addGestureRecognizer(pan)
    }
    
    func handleGestures(sender: UISwipeGestureRecognizer){
        if sender.isKindOfClass(UISwipeGestureRecognizer.self){
            if sender.direction == .Down && filterMenuExpanded == false{
                self.expandFilterMenu()
            }
            else if sender.direction == .Up && filterMenuExpanded == true {
                self.expandFilterMenu()
            }
        }
        else if sender.isKindOfClass(UIPanGestureRecognizer.self) {
            if sender.state == UIGestureRecognizerState.Began {
                expandFilterMenu()
            }
        }
    }
    
    func handleLeftEdgeSwipe(sender: UIGestureRecognizer){
        if sender.state == UIGestureRecognizerState.Ended {
            performSegueWithIdentifier("unwindToTourCities", sender: self)
        }
    }
    
    func expandFilterMenu() {
        shouldHideInstruction = true
        defaults.setBool(shouldHideInstruction, forKey: "shouldHideInstruction")
        if filterMenuExpanded == false {
            let expandFilterMenuTransform = CGAffineTransformMakeTranslation(0, filterMenuView.frame.height-80)
            UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.2, options: [], animations: { () -> Void in
                self.filterMenuView.transform = expandFilterMenuTransform
            }, completion: nil)
            UIView.animateWithDuration(0.25, animations: { () -> Void in
//                self.filterMenuView.filterMenuButton.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
            })
            filterMenuExpanded = true
            dismissButton.enabled = true
            invisibleFilterButton.enabled = false

        }
        else {
            UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.15, options: [], animations: { () -> Void in
                self.filterMenuView.transform = CGAffineTransformIdentity
                }, completion: nil)
        
            UIView.animateWithDuration(0.25, animations: { () -> Void in
//                 self.filterMenuView.filterMenuButton.transform = CGAffineTransformMakeRotation(CGFloat(M_PI/2))
                self.filterMenuView.filterMenuButton.transform = CGAffineTransformIdentity
            }, completion: nil)
            
//            let filteredData = cityData[selectedCity]!.filterCompetitionSchedule(filterMenuView.filterStudioLabel.text!, age: filterMenuView.filterAgeLabel.text!, category: filterMenuView.filterCategoryLabel.text!, day: filterMenuView.filterDayLabel.text!)
//            fillData(filteredData)
            
            let dictionary: NSDictionary = ["studio" : filterMenuView.filterStudioLabel.text!, "age" : filterMenuView.filterAgeLabel.text!, "category" : filterMenuView.filterCategoryLabel.text!, "day" : filterMenuView.filterDayLabel.text!]
            competitionItems = dataManager.filterItemsWithDictionary(dataManager.competitionItems, dictionary: dictionary) as! [CompetitionItem]
//            competitionItems.sortInPlace({ $0.startTime.compare($1.startTime) == NSComparisonResult.OrderedAscending })
            competitionSections = splitSections(competitionItems)


            tableView.reloadData()
            
            filterMenuExpanded = false
            dismissButton.enabled = false
            invisibleFilterButton.enabled = true
         
        }
        
        
    }
    
    
   
    
   override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      let toViewController = segue.destinationViewController 
//      toViewController.transitioningDelegate = self.transitionManager
   }
   
    
   


   
   
}
