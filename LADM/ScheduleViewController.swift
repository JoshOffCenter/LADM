//
//  ScheduleViewController.swift
//  LADM
//
//  Created by Josh Carter on 5/20/15.
//  Copyright (c) 2015 MoonBase. All rights reserved.
//

import UIKit

class ScheduleViewController: UIViewController, UITableViewDelegate,UITableViewDataSource, UIPopoverPresentationControllerDelegate {
    //Class Variables
//    var scheduleItems = [ScheduleItem]()
    var day: String!
    var availableDays = [String]()
    var dataManager = DataManager.sharedInstance
    var scheduleItems: [ScheduleItem]!

    
    
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
        
        scheduleItems.sortInPlace({ $0.startTime.compare($1.startTime) == NSComparisonResult.OrderedAscending })


//        fillData(cityData[selectedCity]!.dailySchedule)
        tableView.reloadData()
        setupGestures()
        
        for item in scheduleItems {
            if !availableDays.contains(item.day) {
                availableDays.append(item.day)
            }
        }
        //availableDays.append("Thurday")
        availableDays.sortInPlace(sorterForDayButton)
        
        day = availableDays[0]
        setupToggleView()

        
        
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

    }
    
//    
//    func fillData(data: Dictionary<String,Dictionary<String,Dictionary<String,Dictionary<String,String>>>>) {
////        scheduleItems.removeAll(keepCapacity: false)
//        
//        for (day,item) in data {
//            for(group,item) in item {
//                for(number, cluster) in item {
////                    let item = ScheduleItem(group: group, time: cluster["Time"]!, faculty: cluster["Faculty"]!, event: cluster["Event"]!, info: cluster["Extra Information"]!, day: day)
////                    scheduleItems.append(item)
//                }
//            }
//        }
    
        
//    }
    //combined the nav bar and takes away shadows
    func setUpNavBar() {
        navigationBar.barTintColor = selectorView.backgroundColor
        navigationBar.shadowImage = UIImage()
        let textAttributes: [String : AnyObject]! = [NSForegroundColorAttributeName : UIColor.whiteColor(), NSFontAttributeName : UIFont(name: "Avenir Next Ultra Light", size: 20)!]
        navigationBar.titleTextAttributes = textAttributes
    }
    
    
    //MARK: UITableViewDelegate protocol methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scheduleItems.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let cell = UITableViewCell(style: .Default, reuseIdentifier: "ScheduleCell")
//        return cell.frame.height
        return 80
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        scheduleItems.sortInPlace({$0.order < $1.order})

        let item: ScheduleItem
        let cell = tableView.dequeueReusableCellWithIdentifier("ScheduleCell", forIndexPath: indexPath) as! ScheduleCell
        item = scheduleItems[indexPath.row]
        cell.facultyLabel.text = item.faculty
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
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
            self.toggleView.center = CGPointMake(self.dayOneButton.center.x + 3, self.dayOneButton.center.y)
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
            self.day = day.text
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
    
    
    @IBAction func groupButtonPressed(sender: UIButton) {
//        let pcv = setupPopoverView()
//        let pvmc = setupPopoverView().popoverPresentationController
//        pvmc?.permittedArrowDirections = UIPopoverArrowDirection.Up
//        pvmc?.delegate = self
//        pvmc?.sourceView = sender
//        pvmc?.sourceRect = CGRect(x: sender.center.x, y: sender.center.y, width: 1, height: 1)
////        adaptivePresentationStyleForPresentationController(pvmc)
//        presentViewController(pcv, animated: true, completion: nil)
    }
    
    //Mark Segue Overrides
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "groupPopoverSegue" {
//            let popoverViewController = segue.destinationViewController as! PopoverViewController
//            popoverViewController.modalPresentationStyle = UIModalPresentationStyle.Popover
//            popoverViewController.popoverPresentationController!.delegate = self
//        }
        

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
        if day == "SAT" {
            dayFull = "Saturday"
        }
        else {
            dayFull = "Sunday"
        }
        
        let dictionary: NSDictionary = ["day" : dayFull, "age" : group]
        
        scheduleItems = dataManager.filterItemsWithDictionary(dataManager.scheduleItems, dictionary: dictionary) as! [ScheduleItem]
//        scheduleItems.sortInPlace({$0.order < $1.order})

        
        
//        scheduleItems = cityData[selectedCity]!.filterDailySchedule(dayFull, group: group)
        tableView.reloadData()
    }
    
    
    func sorterForDayButton(this: String, that: String) -> Bool {
//        Monday, tuesday, wednesday , thrusday, friday, saturday, sunday
    
        var thisInt = -1
        var thatInt = -1
        
        switch this.lowercaseString {
        case "sunday":
            thisInt = 0
        case "monday":
            thisInt = 1
        case "tuesday":
            thisInt = 2
        case "wednesday":
            thisInt = 3
        case "thursday":
            thisInt = 4
        case "friday":
            thisInt = 5
        case "saturday":
            thisInt = 6
        default:
            break;
        }
        
        switch that.lowercaseString {
        case "sunday":
            thatInt = 0
        case "monday":
            thatInt = 1
        case "tuesday":
            thatInt = 2
        case "wednesday":
            thatInt = 3
        case "thursday":
            thatInt = 4
        case "friday":
            thatInt = 5
        case "saturday":
            thatInt = 6
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
