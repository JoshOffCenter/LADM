//
//  ContactMenuView.swift
//  LADM
//
//  Created by Chance Daniel on 5/10/15.
//  Copyright (c) 2015 MoonBase. All rights reserved.
//

import UIKit

class ContactMenu: UIView {
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.roundCorners(UIRectCorner.AllCorners, radius: 10)
        setupBackground()
        
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = frame
    }
    
    func addBlur() {
        let blurEffect: UIBlurEffect = UIBlurEffect(style: .Light)
        let blurView: UIVisualEffectView = UIVisualEffectView(effect: blurEffect)
        //      blurView.setTranslatesAutoresizingMaskIntoConstraints(false)
        blurView.frame = CGRectMake(0, 0, self.bounds.width, self.bounds.height)
        //      blurView.frame = selectCityView.bounds
//        self.insertSubview(blurView, atIndex: 1)
    }
    
    func setupBackground() {
        let image = UIImage(named: "Blur_Menu.png")
        let imageView = UIImageView(image: image)
        imageView.frame = CGRectMake(-5, -5, self.bounds.width + 10, self.bounds.height + 10)
        self.insertSubview(imageView, atIndex: 0)
    }
    
    @IBAction func phoneButtonPressed(sender: AnyObject) {
        let url:NSURL = NSURL(string: "tel://8185411316")!
        UIApplication.sharedApplication().openURL(url)
    }
    
    @IBAction func emailButtonPressed(sender: AnyObject) {
        let url:NSURL = NSURL(string: "mailto:office@ladancemagic.com")!
        UIApplication.sharedApplication().openURL(url)
    }

    
    
}
