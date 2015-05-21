//
//  ScheduleViewController.swift
//  LADM
//
//  Created by Josh Carter on 5/20/15.
//  Copyright (c) 2015 MoonBase. All rights reserved.
//

import UIKit

class ScheduleViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    var scheduleItems = [ScheduleItem]()
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var selectorView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        setUpNavBar()
        fillData(cityData[selectedCity]!.dailySchedule)
        tableView.reloadData()
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
    
    
}
