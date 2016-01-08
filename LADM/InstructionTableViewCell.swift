//
//  InstructionTableViewCell.swift
//  LADM
//
//  Created by Chance Daniel on 1/8/16.
//  Copyright © 2016 MoonBase. All rights reserved.
//

import UIKit

class InstructionTableViewCell: UITableViewCell {


    @IBOutlet weak var cellButton: UIButton!
    override func layoutSubviews() {
        cellButton.titleLabel?.textAlignment = .Center
    }


}
