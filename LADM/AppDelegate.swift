//
//  AppDelegate.swift
//  LADM
//
//  Created by Josh Carter on 4/13/15.
//  Copyright (c) 2015 MoonBase. All rights reserved.
//

import UIKit
import Parse
import Bolts


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
   
   var navController: UINavigationController!

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
   
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        
        //PARSE
        Parse.enableLocalDatastore()
        
        // Initialize Parse.
        Parse.setApplicationId("EBNRrSOrKvzwmeSBkRd4tZm3soLienluMDPF1jOU",
            clientKey: "hJ8fFl1vLvtJX43sCfO1mdHT27HzfNjg9NIgWmbp")
        
        // [Optional] Track statistics around application opens.
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
        
        login()
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func login () {
        PFUser.logOut()

        PFUser.logInWithUsernameInBackground((UIDevice.currentDevice().identifierForVendor?.UUIDString)!, password:"LADM") {
            (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                // Do stuff after successful login.
                print("Login Successful")
            } else {
                // The login failed. Check error to see why.
                print("Try signup")
                self.signUp()
            }
        }
    }
    
    func signUp() {
        let user = PFUser()
        user.username = UIDevice.currentDevice().identifierForVendor?.UUIDString
        user.password = "LADM"
        
        user.signUpInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in
            if let error = error {
                let errorString = error.userInfo["error"] as? NSString
                print(errorString)
                // Show the errorString somewhere and let the user try again.
            } else {
                // Hooray! Let them use the app now.
                print("Signup Successful")
            }
        }
    }

}

