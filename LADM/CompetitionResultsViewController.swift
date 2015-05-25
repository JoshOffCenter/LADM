//
//  CompetitionResultsViewController.swift
//  LADM
//
//  Created by Chance Daniel on 5/23/15.
//  Copyright (c) 2015 MoonBase. All rights reserved.
//

import UIKit

class CompetitionResultsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    //MARK: IBOutles
    
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchBox: UITextField!
    @IBOutlet weak var searchBar: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var menuButton: UIButton!
    
    
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
    
    func emptyMessage() -> String {
        var message: String!
        if allowNewMessage == true {
            number = arc4random_uniform(10)
        }
        
        switch number{
        case 1:
            message = "Sorry, the results seem to have danced away."
            break
        case 2:
            message = "No results here, have you checked your dance bag?"
            break
        case 3:
            message = "Oops, I just had them."
            break
        case 4:
            message = "This is embarrasing, but I can't seem to find any results."
            break
        case 5:
            message = "No results :("
            break
        case 6:
            message = "You're all winners in my book."
            break
        case 7:
            message = "Sorry I was taking a dance break and misplaced the results."
            break
        case 8:
            message = "Quick! What's that over there!"
            break
        case 9:
            message = "Is this your fault or mine?"
            break
        default:
            message = "There are no results currently. Please check back later."
            break
        }
        
        return message
        
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
    
    func filterArrayWithSearchBoxString() {
        let searchString = getTextFromSearchBox().lowercaseString
        let sectionTitlesArray = Array(sectionDictionary.keys)
        if searchString != "" {
            for sectionTitle in sectionTitlesArray {
                let sectionValuesArray: [CompetitionResultItem] = sectionDictionary[sectionTitle]!
                for item in sectionValuesArray {
                    if ((item.division.lowercaseString.rangeOfString(searchString) == nil) && (item.routine.lowercaseString.rangeOfString(searchString) == nil) && (item.studio.lowercaseString.rangeOfString(searchString) == nil)) {
                        removeItem(item)
                    }
                }
            }
        }
        else {
            sectionDictionary = unfilteredDictionary
        }

        
    }
    
     func removeItem(item: CompetitionResultItem) {
        let sectionTitlesArray = Array(sectionDictionary.keys)
        
        for sectionTitle in sectionTitlesArray {
            var i = 0
            var sectionValuesArray: [CompetitionResultItem] = sectionDictionary[sectionTitle]!
            for (i; i < sectionValuesArray.count; i++) {
                if sectionValuesArray[i].equals(item){
                    sectionValuesArray.removeAtIndex(i)
                }
            }
            if sectionValuesArray.count <= 0 {
                sectionDictionary.removeValueForKey(sectionTitle)
            }
            else {
                sectionDictionary.updateValue(sectionValuesArray, forKey: sectionTitle)
            }
        }

    }
    
    func updateWithSearch() {
        filterArrayWithSearchBoxString()
        tableView.reloadData()
    }
    

    @IBAction func searchButtonPressed(sender: AnyObject) {
        updateWithSearch()
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
    
    
    //Keyboard 
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    @IBAction func backButtonPressed(sender: UIButton) {
        performSegueWithIdentifier("unwindToTourCities", sender: self)
    }
    
    //MARK: Gestures
    func setupGestures() {
        var tapGesture = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        self.view.addGestureRecognizer(tapGesture)
        
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
