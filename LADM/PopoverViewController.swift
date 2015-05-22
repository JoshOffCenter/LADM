//
//  PopoverViewController.swift
//  LADM
//
//  Created by Chance Daniel on 5/21/15.
//  Copyright (c) 2015 MoonBase. All rights reserved.
//

import UIKit

class PopoverViewController: UIViewController {
   
    //MARK: IBOutlets

    @IBOutlet weak var jumpstartButton: UIButton!
    @IBOutlet weak var juniorButton: UIButton!
    @IBOutlet weak var seniorButton: UIButton!
    @IBOutlet weak var teacherButton: UIButton!
    
    override func viewDidLoad() {
        
        
    }
    
    @IBAction func buttonPressed(sender: UIButton) {
        switch sender{
        case jumpstartButton:
            break
        case juniorButton:
            break
        case seniorButton:
            break
        case teacherButton:
            break
        default:
            break
            
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    
}
