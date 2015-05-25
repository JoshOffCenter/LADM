//
//  CompetitionResultsViewController.swift
//  LADM
//
//  Created by Chance Daniel on 5/23/15.
//  Copyright (c) 2015 MoonBase. All rights reserved.
//

import UIKit

class CompetitionResultsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //MARK: IBOutles
    
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchBox: UITextField!
    @IBOutlet weak var searchBar: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    
    var competitionResultItems = [CompetitionResultItem]()
    var competionResultItemsArrays = [[CompetitionResultItem]]()

    
    override func viewDidLoad() {
        setUpNavBar()
        tableView.layer.cornerRadius = 10

        
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
        
    }
    
    //MARK: UITableViewDelegate Protocols
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return divideIntoSections().count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionDictionary = divideIntoSections()
        let sectionArray = Array(sectionDictionary.values)
        return sectionArray[section].count
        
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionDictionary = divideIntoSections()
        let sectionTitlesArray = Array(sectionDictionary.keys)
        return sectionTitlesArray[section]
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let item: CompetitionResultItem
        var cell = tableView.dequeueReusableCellWithIdentifier("CompetitionResultCell", forIndexPath: indexPath) as! CompetitionResultCell
        
        let sectionDictionary = divideIntoSections()
        let sectionTitlesArray = Array(sectionDictionary.keys)
        let sectionValuesArray: [CompetitionResultItem] = sectionDictionary[sectionTitlesArray[indexPath.section]]!
        
        
        item = sectionValuesArray[indexPath.row]
        cell.awardLabel.text = item.award
        cell.routineLabel.text = item.routine
        cell.studioLabel.text = item.studio
        
        return cell
    }
    
    // Create dicitonarys based on section titles
    func divideIntoSections() -> Dictionary<String, [CompetitionResultItem] >{
        var divisionDictonary = Dictionary<String, [CompetitionResultItem]>()
        var lastItem = competitionResultItems[0]
        var array = [CompetitionResultItem]()
        
        for item in competitionResultItems{
            if item.division == lastItem.division {
                array.append(item)
            }
            else {
                divisionDictonary[lastItem.division] = array
                array.removeAll(keepCapacity: false)
                array.append(item)
                
            }
            lastItem = item
        }
        
        divisionDictonary[lastItem.division] = array
        return divisionDictonary
    }
    
    
    //MARK: Search Functions
    func getTextFromSearchBox() -> String {
        return searchBox.text
    }

    
    
    
    
    //combined the nav bar and takes away shadows
    func setUpNavBar() {
        navBar.barTintColor = searchBar.backgroundColor
        navBar.shadowImage = UIImage()
        let textAttributes = NSMutableDictionary(capacity: 1)
        textAttributes.setObject(UIColor.whiteColor(), forKey: NSForegroundColorAttributeName)
        textAttributes.setObject(UIFont(name: "Avenir Next Ultra Light", size: 20)!, forKey: NSFontAttributeName)
        navBar.titleTextAttributes = textAttributes as[NSObject:AnyObject]
    }

    
    
}
