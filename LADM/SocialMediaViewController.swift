//
//  SocialMediaViewController.swift
//  LADM
//
//  Created by Chance Daniel on 6/5/15.
//  Copyright (c) 2015 MoonBase. All rights reserved.
//


import UIKit
import TwitterKit

class SocialMediaViewController: TWTRTimelineViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Twitter.sharedInstance().logInGuestWithCompletion { session, error in
            if let validSession = session {
                let client = Twitter.sharedInstance().APIClient
                self.dataSource = TWTRSearchTimelineDataSource(searchQuery: "", APIClient: client)
            } else {
                println("error: %@", error.localizedDescription);
            }
        }
    }
}