//
//  ScheduleViewController.swift
//  LADM
//
//  Created by Josh Carter on 5/20/15.
//  Copyright (c) 2015 MoonBase. All rights reserved.
//

import UIKit
import Parse

class ScheduleViewController: UIViewController, UITableViewDelegate,UITableViewDataSource, UIPopoverPresentationControllerDelegate {
    //Class Variables
//    var scheduleItems = [ScheduleItem]()
    var day: String!
    var availableDays = [String]()
    var dataManager = DataManager.sharedInstance
    var scheduleItems: [ScheduleItem]!
    var scheduleSections: [ScheduleItemSection]!
    
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var selectorView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    //SelectorView Content
    @IBOutlet weak var dayOneButton: UIButton!
    @IBOutlet weak var dayTwoButton: UIButton!
    @IBOutlet weak var dayThreeButton: UIButton!
    
    @IBOutlet weak var toggleView: UIView!
    @IBOutlet weak var groupButton: UIButton!
    @IBOutlet weak var menuButton: UIButton!
    
    var testCenter:CGPoint!
    
    
    override func viewDidLoad() {
        setUpNavBar()
        scheduleItems = dataManager.scheduleItems
        scheduleSections = splitSections(scheduleItems)
        


//        fillData(cityData[selectedCity]!.dailySchedule)
        tableView.reloadData()
        
        setupGestures()
        
        for item in scheduleItems {
//            print(String(item.startTime) + " " + item.event + " " + item.faculty)
            if !availableDays.contains(item.day) {
                availableDays.append(item.day)
            }
        }
        //availableDays.append("Thurday")
        availableDays.sortInPlace(sorterForDayButton)
        
        let dayString = availableDays[0].substringWithRange(Range<String.Index>(start: availableDays[0].startIndex.advancedBy(0), end: availableDays[0].startIndex.advancedBy(3)))

        day = dayString.lowercaseString
        setupToggleView()
    
        self.callFilter(groupButton.titleLabel!.text!)


        
        
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
        

        tableView.layer.cornerRadius = 10
        subscribeToParseChannel()

    }
    
    func subscribeToParseChannel() {
        let installation = PFInstallation.currentInstallation()
        let installationString = String(installation.installationId)
        

        PFCloud.callFunctionInBackground("cityInterest", withParameters:["city":selectedCity, "installId":installationString]) {
            result, error in
            if error == nil {
            
            }
        }
    }
    
    func splitSections(itemArr: [ScheduleItem]) -> [ScheduleItemSection] {
        var arr = [ScheduleItemSection]()
        for item in itemArr {
            let group = item.group
            
            var found = false
            for s in arr {
                if s.group == group {
                    s.scheduleItems.append(item)
                    found = true
                    break
                }
            }
            if !found {
                arr.append(ScheduleItemSection(group:group, firstItem: item))
            }
        }
        for s in arr {
            s.scheduleItems.sortInPlace({$0.startTime.compare($1.startTime) == .OrderedAscending})
        }
        arr.sortInPlace({$0.group < $1.group})
        return arr
    }
    
  
    func scrollToCurrent() {
        let timeZone = NSTimeZone.localTimeZone()
        let seconds = timeZone.secondsFromGMT
        let date = NSDate(timeIntervalSinceNow: NSTimeInterval(seconds))
        
        var indexPath = NSIndexPath(forItem: 0, inSection: 0)
        
        var soonestItem: ScheduleItem! = scheduleSections.first?.scheduleItems.first
        
        for var sectionIndex = 0; sectionIndex < scheduleSections.count; sectionIndex++ {
            if soonestItem.group == groupButton.titleLabel?.text {
                for var scheduleIndex = 0; scheduleIndex < scheduleSections[sectionIndex].scheduleItems.count; scheduleIndex++ {
                    let item = scheduleSections[sectionIndex].scheduleItems[scheduleIndex]
                    if item.startTime.earlierDate(date) == item.startTime {
                        soonestItem = item
                        indexPath = NSIndexPath(forRow: scheduleIndex, inSection: sectionIndex)
                    }
                }
            }
        }
        if scheduleSections.count > indexPath.section && scheduleSections[indexPath.section].scheduleItems.count > indexPath.row {
            tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Top, animated: true)
        }
       
    }
    
    //combined the nav bar and takes away shadows
    func setUpNavBar() {
        navigationBar.barTintColor = selectorView.backgroundColor
        navigationBar.shadowImage = UIImage()
        let textAttributes: [String : AnyObject]! = [NSForegroundColorAttributeName : UIColor.whiteColor(), NSFontAttributeName : UIFont(name: "Avenir Next Ultra Light", size: 20)!]
        navigationBar.titleTextAttributes = textAttributes
    }
    
    
    //MARK: UITableViewDelegate protocol methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return scheduleSections.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scheduleSections[section].scheduleItems.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let cell = UITableViewCell(style: .Default, reuseIdentifier: "ScheduleCell")
//        return cell.frame.height
        return 80
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if scheduleSections[section].scheduleItems.isEmpty {
            return nil
        }
        return scheduleSections[section].group
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        scheduleItems.sortInPlace({ $0.startTime.compare($1.startTime) == NSComparisonResult.OrderedAscending })
//
//        for item in scheduleItems {
////            print(item.event + " " + item.group)
//            print(item.event)
//        }
//        
        let item: ScheduleItem
        let cell = tableView.dequeueReusableCellWithIdentifier("ScheduleCell", forIndexPath: indexPath) as! ScheduleCell
//        item = scheduleItems[indexPath.row]
        item = scheduleSections[indexPath.section].scheduleItems[indexPath.row]
        cell.facultyLabel.text = item.faculty
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        dateFormatter.timeZone = NSTimeZone(name: "UTC")
//        dateFormatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
        var startTimeString = dateFormatter.stringFromDate(item.startTime)
        

        if startTimeString.characters.first == "0"  {
            startTimeString = startTimeString.substringWithRange(Range<String.Index>(start: startTimeString.startIndex.advancedBy(1), end: startTimeString.endIndex))
            
        }
        
        var endTimeString: String!
        if (item.endTime != nil) {
            endTimeString = dateFormatter.stringFromDate(item.endTime!)
            if endTimeString.characters.first == "0"  {
                endTimeString = endTimeString.substringWithRange(Range<String.Index>(start: endTimeString.startIndex.advancedBy(1), end: endTimeString.endIndex))
                
            }
            endTimeString = "\n to \n" + endTimeString
        } else {
            endTimeString = ""
        }
        
        cell.timeLabel.text = startTimeString + endTimeString
//        cell.timeLabel.text = item.time
//        cell.timeLabel.text = String(item.order!)

//        if item.faculty != "" || item.event.containsString("Audition") {
//            cell.eventLabel.text = item.event.capitalizedString
//        } else {
//            cell.eventLabel.text = item.event.uppercaseString
//        }
        cell.eventLabel.text = item.event

        return cell
    }
    
    
    //MARK: Setup Toggle View
    func setupToggleView() {
        dayOneButton.setTitle((availableDays[0] as NSString).substringToIndex(3).uppercaseString, forState: UIControlState.Normal)
        dayTwoButton.setTitle((availableDays[1] as NSString).substringToIndex(3).uppercaseString, forState: UIControlState.Normal)

        if availableDays.count == 3 {
            dayThreeButton.setTitle((availableDays[2] as NSString).substringToIndex(3).uppercaseString, forState: UIControlState.Normal)
            dayThreeButton.enabled = true
            dayThreeButton.hidden = false
        }
        else {
            dayThreeButton.enabled = false
            dayThreeButton.hidden = true
        }
        
        
        toggleView.translatesAutoresizingMaskIntoConstraints = true
        toggleView.roundCorners(UIRectCorner.AllCorners, radius: 5)
        
        UIView.animateWithDuration(0.25, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            if self.availableDays.count > 2 {
                self.toggleView.center = CGPointMake(self.dayOneButton.center.x + 2, self.dayOneButton.center.y)
            } else {
                self.toggleView.center = CGPointMake(self.dayOneButton.center.x, self.dayOneButton.center.y)
            }
            }, completion: nil)
    }
    
    //MARK: Setup Popover View
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }

    func setupPopoverView() -> PopoverViewController {
        let storybard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let popoverViewController = storybard.instantiateViewControllerWithIdentifier("PopoverViewController") as! PopoverViewController
        popoverViewController.modalPresentationStyle = .Popover
        popoverViewController.preferredContentSize = CGSizeMake(50, 100)
        return popoverViewController
    }
    
    //MARK: Button IBActions
    
    @IBAction func backButtonPressed(sender: UIButton) {
        performSegueWithIdentifier("unwindToTourCities", sender: self)
    }
    
    
    @IBAction func toggleDay(sender: UIButton, forEvent event: UIEvent) {
        if let day = sender.titleLabel {
            self.day = day.text?.lowercaseString
        }
        sender.setTitleColor(self.selectorView.backgroundColor, forState: .Normal)
        if sender == dayOneButton {
            dayTwoButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            dayThreeButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        }
        else if sender == dayTwoButton {
            dayOneButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            dayThreeButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        }
        else {
            dayOneButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            dayTwoButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        }
        
        UIView.animateWithDuration(0.25, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self.toggleView.center = sender.center
            
        }, completion: nil)
        self.callFilter(groupButton.titleLabel!.text!)
        
//        var dayFull:String
//        if day == "SAT" {
//            dayFull = "Saturday"
//        }
//        else {
//            dayFull = "Sunday"
//        }
//        scheduleItems = cityData[selectedCity]!.filterDailySchedule(dayFull, group: groupButton.titleLabel!.text!)
        tableView.reloadData()
    }
    

    
    //Mark Segue Overrides
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        switch segue.identifier {
        case "groupPopoverSegue"?:
            if #available(iOS 9.0, *) {
                let popover = segue.destinationViewController.popoverPresentationController
                let anchor = popover?.sourceView
                popover!.sourceRect = anchor!.bounds
                
            }
        default:
            break
        }

        if let viewController = segue.destinationViewController as? PopoverViewController{
            viewController.onDataAvailable = {[weak self]
                (data) in
                if let weakSelf = self {
                    weakSelf.callFilter(data)
                }
            }
            viewController.modalPresentationStyle = UIModalPresentationStyle.Popover
            viewController.popoverPresentationController!.delegate = self
        }
        
    }
    
    func callFilter(group:String) {
        groupButton.setTitle(group, forState: UIControlState.Normal)
        var dayFull:String
        if day == "sat" {
            dayFull = "Saturday"
        }
        else {
            dayFull = "Sunday"
        }
        
        var dictionary: NSDictionary = ["day" : dayFull]

        if group != "Group" {
            dictionary = ["day" : dayFull, "group" : group]
        }
        
        
        scheduleItems = dataManager.filterItemsWithDictionary(dataManager.scheduleItems, dictionary: dictionary) as! [ScheduleItem]
        scheduleSections = splitSections(scheduleItems)

//        print("Filtered Items")
//        for item in scheduleItems {
//            print(item.day + " " + item.group)
//        }
//        print("End Filtered Items")

        
        tableView.reloadData()
        scrollToCurrent()
    }
    
    
    func sorterForDayButton(this: String, that: String) -> Bool {
//        Monday, tuesday, wednesday , thrusday, friday, saturday, sunday
    
        var thisInt = -1
        var thatInt = -1
        
        switch this.lowercaseString {
        case "sunday":
            thisInt = 6
        case "monday":
            thisInt = 0
        case "tuesday":
            thisInt = 1
        case "wednesday":
            thisInt = 2
        case "thursday":
            thisInt = 3
        case "friday":
            thisInt = 4
        case "saturday":
            thisInt = 5
        default:
            break;
        }
        
        switch that.lowercaseString {
        case "sunday":
            thatInt = 6
        case "monday":
            thatInt = 0
        case "tuesday":
            thatInt = 1
        case "wednesday":
            thatInt = 2
        case "thursday":
            thatInt = 3
        case "friday":
            thatInt = 4
        case "saturday":
            thatInt = 5
        default:
            break;
        }
        
        return thisInt < thatInt
        
    }
    
    
    
    
    //MARK: Gestures
    func setupGestures() {
        let swipeBackGesture = UIScreenEdgePanGestureRecognizer(target: self, action: "handleLeftEdgeSwipe:")
        swipeBackGesture.edges = UIRectEdge.Left
        self.view.addGestureRecognizer(swipeBackGesture)
    }
    
    func handleLeftEdgeSwipe(sender: UIGestureRecognizer){
        if sender.state == UIGestureRecognizerState.Ended {
            performSegueWithIdentifier("unwindToTourCities", sender: self)
        }
    }

    
    
}
