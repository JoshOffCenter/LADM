//
//  PopoverViewController.swift
//  LADM
//
//  Created by Chance Daniel on 5/21/15.
//  Copyright (c) 2015 MoonBase. All rights reserved.
//

import UIKit

class PopoverViewController: UIViewController {
   
    var onDataAvailable : ((data: String) -> ())?
    
    //MARK: IBOutlets

    @IBOutlet weak var jumpstartButton: UIButton!
    @IBOutlet weak var juniorButton: UIButton!
    @IBOutlet weak var seniorButton: UIButton!
    @IBOutlet weak var teacherButton: UIButton!
    
    override func viewDidLoad() {
       self.preferredContentSize = CGSizeMake(200, 350);
    }
    
    func sendData(data:String) {
        self.onDataAvailable?(data:data)
    }
    
    @IBAction func buttonPressed(sender: UIButton) {
        let returnString = sender.titleLabel!.text
        sendData(returnString!)
        
//        switch sender{
//        case jumpstartButton:
//            sendData("Jumpstart")
//            break
//        case juniorButton:
//            sendData("Junior")
//            break
//        case seniorButton:
//            sendData("Senior")
//            break
//        case teacherButton:
//            sendData("Teacher")
//            break
//        default:
//            break
//            
//            
//        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    
}
