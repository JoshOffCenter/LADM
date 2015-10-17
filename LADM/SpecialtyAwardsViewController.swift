//
//  SpecialtyAwardsViewController.swift
//  LADM
//
//  Created by Chance Daniel on 5/25/15.
//  Copyright (c) 2015 MoonBase. All rights reserved.
//

import UIKit

class SpecialtyAwardsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate {
    
    //MARK: IBOutlets
    
    @IBOutlet weak var searchBox: UITextField!
    @IBOutlet weak var searchBar: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var menuButton: UIButton!
    
    let dataManager = DataManager.sharedInstance
    var specialtyItems = [SpecialtyItem]()
    
    var totalSectionData = [SpecialtyAwardSection]()
    var sectionData = [SpecialtyAwardSection]()
    var allowNewMessage = false
    var number: UInt32 = 0
    
    override func viewDidLoad() {
        setUpNavBar()
        specialtyItems = dataManager.specialtyItems
//        fillData(cityData[selectedCity]!.specialtyAwards)
        totalSectionData = splitSections(specialtyItems)
        sectionData = splitSections(specialtyItems)
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
    
//    func fillData(data: Dictionary<String,Dictionary<String,Dictionary<String,String>>>) {
//        specialtyAwardItems.removeAll(keepCapacity: false)
//        for (div, item1) in data {
//            for (award, item2) in item1 {
//                let piece = item2["Piece"]!
//                let studio = item2["Studio"]!
////                let item = SpecialtyAwardItem(division: div, award: award, piece: piece, studio: studio)
//                specialtyAwardItems.append(item)
//            }
//        }
//        
//    }
    
//    func splitSections(itemArr: [SpecialtyAwardItem]) -> [SpecialtyAwardSection]{
//        var arr = [SpecialtyAwardSection]()
//        for item in itemArr {
//            let division = item.division
//            var found = false
//            for s in arr {
//                if s.division == division {
//                    s.specialtyItems.append(item)
//                    found = true
//                    break
//                }
//            }
//            if !found {
//                arr.append(SpecialtyAwardSection(div: division, firstItem:item))
//            }
//        }
//        for item in arr {
//            item.specialtyItems.sortInPlace({$0.award < $1.award})
//        }
//        arr.sortInPlace({$0.division < $1.division})
//        return arr
//    }
    
    func splitSections(itemArr: [SpecialtyItem]) -> [SpecialtyAwardSection] {
        var arr = [SpecialtyAwardSection]()
        for item in itemArr {
            let age = item.age
            //            let division = item.division
            var found = false
            for s in arr {
                if s.age == age {
                    s.specialtyItems.append(item)
                    found = true
                    break
                }
            }
            if !found {
                arr.append(SpecialtyAwardSection(a:age, firstItem: item))
            }
        }
        
        for s in arr {
            s.specialtyItems.sortInPlace({$0.award < $1.award})
        }
        arr.sortInPlace({$0.age < $1.age})
        return arr
    }

    
    //MARK: UITableViewDelegate Protocols
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if sectionData.isEmpty {
           return 1
        }
        return sectionData.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if sectionData.isEmpty { return 1 }
        return sectionData[section].specialtyItems.count
      
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if sectionData.isEmpty {
            return nil
        }
        return sectionData[section].age
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if sectionData.isEmpty {
            let cell =  tableView.dequeueReusableCellWithIdentifier("EmptySpecialtyAwardCell", forIndexPath: indexPath) as! EmptySpecialtyAwardCell
            cell.messageLabel.text = emptyMessage()
            allowNewMessage = false
            return cell
        }
            let cell = tableView.dequeueReusableCellWithIdentifier("SpecialtyAwardCell", forIndexPath: indexPath) as! SpecialtyAwardCell
            let item = sectionData[indexPath.section].specialtyItems[indexPath.row]
            cell.awardLabel.text = item.award
            cell.pieceLabel.text = item.piece
            cell.studioLabel.text = item.studio
            allowNewMessage = true
            return cell
    }
    
    func setUpNavBar() {
        navBar.barTintColor = searchBar.backgroundColor
        navBar.shadowImage = UIImage()
        let textAttributes: [String : AnyObject]! = [NSForegroundColorAttributeName : UIColor.whiteColor(), NSFontAttributeName : UIFont(name: "Avenir Next Ultra Light", size: 20)!]
        navBar.titleTextAttributes = textAttributes

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
    
    //Keyboard
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    @IBAction func backButtonPressed(sender: AnyObject) {
        performSegueWithIdentifier("unwindToTourCities", sender: self)
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
    
    func updateWithSearch() {
        filterArrayWithSearchBoxString()
        tableView.reloadData()
    }
    
    func filterArrayWithSearchBoxString() {
        var newItemList = [SpecialtyItem]()
        let searchString = getTextFromSearchBox().lowercaseString
        if searchString != "" {
            for item in specialtyItems {
                if(item.age.lowercaseString.rangeOfString(searchString) != nil || item.award.lowercaseString.rangeOfString(searchString) != nil || item.piece.lowercaseString.rangeOfString(searchString) != nil || item.studio.lowercaseString.rangeOfString(searchString) != nil) {
                    newItemList.append(item)
                }
            }
            sectionData = splitSections(newItemList)
        }
        else {
            sectionData = totalSectionData
        }
        
    }
    
    func getTextFromSearchBox() -> String {
        return searchBox.text!
    }
}
