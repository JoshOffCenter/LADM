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
    
    struct section {
        let division: String
        var specialtyItems = [SpecialtyAwardItem]()
    }
    
    @IBOutlet weak var searchBox: UITextField!
    @IBOutlet weak var searchBar: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var menuButton: UIButton!
    
    var specialtyAwardItems = [SpecialtyAwardItem]()
    var sectionData = [SpecialtyAwardSection]()
//    var sectionDictionary: Dictionary<String, [SpecialtyAwardItem]>!
//    var unfilteredDictionary: Dictionary<String, [SpecialtyAwardItem]>!
    var allowNewMessage = false
    var number: UInt32 = 0
    
    
    
    override func viewDidLoad() {
        setUpNavBar()
        fillData(cityData[selectedCity]!.specialtyAwards)
        splitSections()
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
        
//        unfilteredDictionary = divideIntoSections()
//        sectionDictionary = divideIntoSections()
        
        
    }
    
    func fillData(data: Dictionary<String,Dictionary<String,Dictionary<String,String>>>) {
        specialtyAwardItems.removeAll(keepCapacity: false)
        for (div, item1) in data {
            for (award, item2) in item1 {
                let piece = item2["Piece"]!
                let studio = item2["Studio"]!
                let item = SpecialtyAwardItem(division: div, award: award, piece: piece, studio: studio)
                specialtyAwardItems.append(item)
            }
        }
        
    }
    
    func splitSections() {
        for item in specialtyAwardItems {
            let division = item.division
            var found = false
            for s in sectionData {
                if s.division == division {
                    s.specialtyItems.append(item)
                    found = true
                    break
                }
            }
            if !found {
                sectionData.append(SpecialtyAwardSection(div: division, firstItem:item))
            }
        }
        for item in sectionData {
            item.specialtyItems.sort({$0.award < $1.award})
        }
        sectionData.sort({$0.division < $1.division})
    }
    
    
    //MARK: UITableViewDelegate Protocols
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if sectionData.isEmpty {
           return 1
        }
        return sectionData.count
        
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if sectionData.isEmpty {
//            return 1
//        }
//        return sectionData[section].specialtyItems.count
        if sectionData.isEmpty { return 1 }
        return sectionData[section].specialtyItems.count
      
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //        let sectionTitlesArray = Array(sectionDictionary.keys)
        //        if !sectionDictionary.isEmpty{
        //            return sectionTitlesArray[section]
        //        }
        //        return nil
        
        if sectionData.isEmpty {
            return nil
        }
        return sectionData[section].division
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //        let item: SpecialtyAwardItem
        //        if sectionDictionary.isEmpty {
        //            var cell = tableView.dequeueReusableCellWithIdentifier("EmptySpecialtyAwardCell", forIndexPath: indexPath) as! EmptySpecialtyAwardCell
        //            cell.messageLabel.text = emptyMessage()
        //            allowNewMessage = false
        //            sectionDictionary = unfilteredDictionary
        //            return cell
        //        }
        //        else {
        //            var cell = tableView.dequeueReusableCellWithIdentifier("SpecialtyAwardCell", forIndexPath: indexPath) as! SpecialtyAwardCell
        //
        //            let sectionTitlesArray = Array(sectionDictionary.keys)
        //            let sectionValuesArray: [SpecialtyAwardItem] = sectionDictionary[sectionTitlesArray[indexPath.section]]!
        //
        //
        //            item = sectionValuesArray[indexPath.row]
        //            cell.awardLabel.text = item.award
        //            cell.pieceLabel.text = item.piece
        //            cell.studioLabel.text = item.studio
        //            
        //            
        //            allowNewMessage = true
        //            return cell
        //        }
        
        if sectionData.isEmpty {
            var cell =  tableView.dequeueReusableCellWithIdentifier("EmptySpecialtyAwardCell", forIndexPath: indexPath) as! EmptySpecialtyAwardCell
            cell.messageLabel.text = emptyMessage()
            allowNewMessage = false
            //chance does something weird here in the example
            return cell
        }
        
            var cell = tableView.dequeueReusableCellWithIdentifier("SpecialtyAwardCell", forIndexPath: indexPath) as! SpecialtyAwardCell
            
            var item = sectionData[indexPath.section].specialtyItems[indexPath.row]
            cell.awardLabel.text = item.award
            cell.pieceLabel.text = item.piece
            cell.studioLabel.text = item.studio
            
            allowNewMessage = true
            return cell
        
    }
    
    func setUpNavBar() {
        navBar.barTintColor = searchBar.backgroundColor
        navBar.shadowImage = UIImage()
        let textAttributes = NSMutableDictionary(capacity: 1)
        textAttributes.setObject(UIColor.whiteColor(), forKey: NSForegroundColorAttributeName)
        textAttributes.setObject(UIFont(name: "Avenir Next Ultra Light", size: 20)!, forKey: NSFontAttributeName)
        navBar.titleTextAttributes = textAttributes as[NSObject:AnyObject]
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

    
//    // Create dicitonarys based on section titles
//    func divideIntoSections() -> Dictionary<String, [SpecialtyAwardItem] >{
//        var divisionDictonary = Dictionary<String, [SpecialtyAwardItem]>()
//        var lastItem = specialtyAwardItems[0]
//        var array = [SpecialtyAwardItem]()
//        
//        for item in specialtyAwardItems{
//            if item.division == lastItem.division {
//                array.append(item)
//            }
//            else {
//                divisionDictonary[lastItem.division] = array
//                array.removeAll(keepCapacity: false)
//                array.append(item)
//                
//            }
//            lastItem = item
//        }
//        
//        divisionDictonary[lastItem.division] = array
//        return divisionDictonary
//    }
    

    
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
}
