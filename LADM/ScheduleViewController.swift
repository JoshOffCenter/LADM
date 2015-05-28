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
    var scheduleItems = [ScheduleItem]()
    var day: String!
    
    
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var selectorView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    //SelectorView Content
    @IBOutlet weak var satButton: UIButton!
    @IBOutlet weak var sunButton: UIButton!
    @IBOutlet weak var toggleView: UIView!
    @IBOutlet weak var groupButton: UIButton!
    @IBOutlet weak var menuButton: UIButton!
    
    var testCenter:CGPoint!
    
    
    override func viewDidLoad() {
        setUpNavBar()
        fillData(cityData[selectedCity]!.dailySchedule)
        tableView.reloadData()
        setupToggleView()
        setupGestures()
        day = "SAT"
        
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
    
    
    func fillData(data: Dictionary<String,Dictionary<String,Dictionary<String,Dictionary<String,String>>>>) {
        scheduleItems.removeAll(keepCapacity: false)
        
        for (day,item) in data {
            for(group,item) in item {
                for(number, cluster) in item {
                    let item = ScheduleItem(group: group, time: cluster["Time"]!, faculty: cluster["Faculty"]!, event: cluster["Event"]!, info: cluster["Extra Information"]!, day: day)
                    scheduleItems.append(item)
                }
            }
        }
        
        
    }
    //combined the nav bar and takes away shadows
    func setUpNavBar() {
        navigationBar.barTintColor = selectorView.backgroundColor
        navigationBar.shadowImage = UIImage()
        let textAttributes = NSMutableDictionary(capacity: 1)
        textAttributes.setObject(UIColor.whiteColor(), forKey: NSForegroundColorAttributeName)
        textAttributes.setObject(UIFont(name: "Avenir Next Ultra Light", size: 20)!, forKey: NSFontAttributeName)
        navigationBar.titleTextAttributes = textAttributes as[NSObject:AnyObject]
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
        let item: ScheduleItem
        var cell = tableView.dequeueReusableCellWithIdentifier("ScheduleCell", forIndexPath: indexPath) as! ScheduleCell
        item = scheduleItems[indexPath.row]
        cell.facultyLabel.text = item.faculty
        cell.timeLabel.text = item.time
        cell.eventLabel.text = item.event
        return cell
    }
    
    
    //MARK: Setup Toggle View
    func setupToggleView() {
        toggleView.setTranslatesAutoresizingMaskIntoConstraints(true)
        toggleView.center = satButton.center
        toggleView.roundCorners(UIRectCorner.AllCorners, radius: 5)
    }
    
    //MARK: Setup Popover View
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }

    func setupPopoverView() -> PopoverViewController {
        let storybard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        var popoverViewController = storybard.instantiateViewControllerWithIdentifier("PopoverViewController") as! PopoverViewController
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
        if sender == satButton {
            sunButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        }
        else {
            satButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        }
        
        UIView.animateWithDuration(0.25, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self.toggleView.center = sender.center
            
        }, completion: nil)
        
        var dayFull:String
        if day == "SAT" {
            dayFull = "Saturday"
        }
        else {
            dayFull = "Sunday"
        }
        scheduleItems = cityData[selectedCity]!.filterDailySchedule(dayFull, group: groupButton.titleLabel!.text!)
        tableView.reloadData()
    }
    
    
    @IBAction func groupButtonPressed(sender: UIButton) {
//        let pcv = setupPopoverView()
//        let pvmc = setupPopoverView().popoverPresentationController
//        pvmc?.permittedArrowDirections = UIPopoverArrowDirection.Up
//        pvmc?.delegate = self
//        pvmc?.sourceView = sender
//        pvmc?.sourceRect = CGRect(x: sender.center.x, y: sender.center.y, width: 1, height: 1)
//        adaptivePresentationStyleForPresentationController(pvmc)
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
        
        scheduleItems = cityData[selectedCity]!.filterDailySchedule(dayFull, group: group)
        tableView.reloadData()
    }
    
        
    
    
    
    //MARK: Gestures
    func setupGestures() {
        var swipeBackGesture = UIScreenEdgePanGestureRecognizer(target: self, action: "handleLeftEdgeSwipe:")
        swipeBackGesture.edges = UIRectEdge.Left
        self.view.addGestureRecognizer(swipeBackGesture)
    }
    
    func handleLeftEdgeSwipe(sender: UIGestureRecognizer){
        if sender.state == UIGestureRecognizerState.Ended {
            performSegueWithIdentifier("unwindToTourCities", sender: self)
        }
    }

    
    
}
