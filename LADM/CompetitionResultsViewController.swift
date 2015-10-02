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
    var totalSectionData = [CompetitionResultsSection]()
    var sectionData = [CompetitionResultsSection]()
    var allowNewMessage = false
    var number: UInt32 = 0
    
    override func viewDidLoad() {
        setUpNavBar()
        fillData(cityData[selectedCity]!.competitionResults)
        
        totalSectionData = splitSections(competitionResultItems)
        sectionData = splitSections(competitionResultItems)
        
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
    }

    func fillData(data:Dictionary<String,Dictionary<String,Dictionary<String,String>>>) {
        competitionResultItems.removeAll(keepCapacity: false)
        for (div,item) in data {
            for(num, vals) in item {
                let division = div
                let award = vals["Award or Medal"]!
                let category = vals["Category"]!
                let routine = vals["Routine Name"]!
                let studio = vals["Studio"]!
                
                let bundle = CompetitionResultItem(division: division, award: award, category: category, routine: routine, studio: studio)
                
                competitionResultItems.append(bundle)
                }
            }
    }
    
    func splitSections(itemArr: [CompetitionResultItem]) -> [CompetitionResultsSection] {
        var arr = [CompetitionResultsSection]()
        for item in itemArr {
            let division = item.division
            var found = false
            for s in arr {
                if s.division == division {
                    s.competitionItems.append(item)
                    found = true
                    break
                }
            }
            if !found {
                arr.append(CompetitionResultsSection(div:division, firstItem: item))
            }
        }
        for item in arr {
            item.competitionItems.sortInPlace({
            (item1,item2) in
                let place1 = item1.award[item1.award.startIndex.advancedBy(0)]
                let place2 = item2.award[item2.award.startIndex.advancedBy(0)]
            
                let split1 = item1.award.characters.split{$0 == " "}.map { String($0) }
                let split2 = item2.award.characters.split{$0 == " "}.map { String($0) }
                
                let rank1 = self.awardRanker(split1)
                
                
                let rank2 = self.awardRanker(split2)
                
                return rank1 > rank2
            })
        }
        arr.sortInPlace({$0.division < $1.division})
        return arr
    }
    
    func awardRanker(arr: [String]) -> Int {
        var rank = 0
        let firstChunk = arr[0]
        let firstNum = Int(String(firstChunk[firstChunk.startIndex.advancedBy(0)]))
        if firstNum != nil {
            rank = (4-firstNum!) * 4
        }
        if arr.count == 1 {
            return 1
        }
        switch arr[arr.count - 2] {
        case "High": rank += 2
        case "Double": rank += 4
        default:
            if arr[arr.count-1] == "Platinum" {
                rank+=3
            }
            else {
                rank += 1
            }
        }
        return rank
    }

    //MARK: UITableViewDelegate Protocols
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if sectionData.isEmpty { return 1 }
        return sectionData.count

    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if sectionData.isEmpty { return 1 }
        return sectionData[section].competitionItems.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if sectionData.isEmpty { return nil }
        return sectionData[section].division
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if sectionData.isEmpty {
             let cell = tableView.dequeueReusableCellWithIdentifier("EmptyCompetitionResultsCell", forIndexPath: indexPath) as! EmptyCompetitionResultCell
            cell.messageLabel.text = emptyMessage()
            allowNewMessage = false
            return cell
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("CompetitionResultCell",forIndexPath: indexPath) as! CompetitionResultCell
        let item = sectionData[indexPath.section].competitionItems[indexPath.row]
        cell.studioLabel.text = item.studio
        cell.routineLabel.text = item.routine
        cell.awardLabel.text = item.award
        allowNewMessage = true
        return cell
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
        return searchBox.text!
    }
    
    func filterArrayWithSearchBoxString() {
        var newItemList = [CompetitionResultItem]()
        let searchString = getTextFromSearchBox().lowercaseString
        if searchString != "" {
            for item in competitionResultItems {
                if (item.division.lowercaseString.rangeOfString(searchString) != nil || item.category.lowercaseString.rangeOfString(searchString) != nil || item.award.lowercaseString.rangeOfString(searchString) != nil || item.routine.lowercaseString.rangeOfString(searchString) != nil || item.studio.lowercaseString.rangeOfString(searchString) != nil) {
                    newItemList.append(item)
                }
            }
            sectionData = splitSections(newItemList)
        }
        else {
            sectionData = totalSectionData
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
        let textAttributes: [String : AnyObject]! = [NSForegroundColorAttributeName : UIColor.whiteColor(), NSFontAttributeName : UIFont(name: "Avenir Next Ultra Light", size: 20)!]
        navBar.titleTextAttributes = textAttributes
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
        let tapGesture = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        self.view.addGestureRecognizer(tapGesture)
        
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
