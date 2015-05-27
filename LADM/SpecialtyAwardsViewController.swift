//
//  SpecialtyAwardsViewController.swift
//  LADM
//
//  Created by Chance Daniel on 5/25/15.
//  Copyright (c) 2015 MoonBase. All rights reserved.
//

import UIKit

class SpecialtyAwardsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //MARK: IBOutlets
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var navBar: UINavigationItem!
    @IBOutlet weak var searchBox: UITextField!
    @IBOutlet weak var searchBar: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    
    var competitionResultItems = [CompetitionResultItem]()
    var competionResultItemsArrays = [[CompetitionResultItem]]()
    var sectionDictionary: Dictionary<String, [CompetitionResultItem]>!
    var unfilteredDictionary: Dictionary<String, [CompetitionResultItem]>!
    var allowNewMessage = false
    var number: UInt32 = 0
    
    
    
    override func viewDidLoad() {
        setUpNavBar()
        tableView.layer.cornerRadius = 10
        self.searchBox.delegate = self
        
        setupGestures()
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: "updateWithSearch", name: UITextFieldTextDidChangeNotification, object: searchBox)
        
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
        
        
        let item1 = CompetitionResultItem(division: "Jr Duo/Trio", award: "1st Place, Platinum", category: "Contemporary", routine: "Anxieux", studio: "Dance Attack! Los Gatos")
        
        let item2 = CompetitionResultItem(division: "Jr Duo/Trio", award: "1st Place, Platinum", category: "Jazz", routine: "Love Me Right", studio: "Dance Attack! Los Gatos")
        
        let item3 = CompetitionResultItem(division: "Jr Prep Duo/Trio", award: "1st Place, High Gold", category: "Tap", routine: "Born To Entertain", studio: "The Dance Connection")
        
        let item4 = CompetitionResultItem(division: "Jr Prep Duo/Trio", award: "2nd Place, High Gold", category: "Jazz", routine: "All that Jazz", studio: "The Dance Connection")
        let item5 = CompetitionResultItem(division: "Senior", award: "IDK", category: "IDK", routine: "IDK", studio: "IDK")
        
        competitionResultItems.append(item1)
        competitionResultItems.append(item2)
        competitionResultItems.append(item3)
        competitionResultItems.append(item4)
        competitionResultItems.append(item5)
        sectionDictionary = divideIntoSections()
        unfilteredDictionary = divideIntoSections()
        
        
    }

    
    
    
    
    //MARK: UITableViewDelegate Protocols
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if sectionDictionary.isEmpty {
            return 1
        }
        return sectionDictionary.count
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionArray = Array(sectionDictionary.values)
        if !sectionDictionary.isEmpty {
            return sectionArray[section].count
        }
        return 1
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionTitlesArray = Array(sectionDictionary.keys)
        if !sectionDictionary.isEmpty{
            return sectionTitlesArray[section]
        }
        return nil
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let item: CompetitionResultItem
        if sectionDictionary.isEmpty {
            var cell = tableView.dequeueReusableCellWithIdentifier("EmptyCompetitionResultsCell", forIndexPath: indexPath) as! EmptyCompetitionResultCell
            cell.messageLabel.text = emptyMessage()
            allowNewMessage = false
            sectionDictionary = unfilteredDictionary
            return cell
        }
        else {
            var cell = tableView.dequeueReusableCellWithIdentifier("CompetitionResultCell", forIndexPath: indexPath) as! CompetitionResultCell
            
            let sectionTitlesArray = Array(sectionDictionary.keys)
            let sectionValuesArray: [CompetitionResultItem] = sectionDictionary[sectionTitlesArray[indexPath.section]]!
            
            
            item = sectionValuesArray[indexPath.row]
            cell.awardLabel.text = item.award
            cell.routineLabel.text = item.routine
            cell.studioLabel.text = item.studio
            
            allowNewMessage = true
            return cell
        }
    }

    
    
}
