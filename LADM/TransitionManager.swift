
//
//  TransitionManager.swift
//  LADM
//
//  Created by Chance Daniel on 4/27/15.
//  Copyright (c) 2015 MoonBase. All rights reserved.
//

import UIKit

class TransitionManager: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {
   
   private var presenting = false

   
   //MARK: UIViewControllerAnimatedTransitioning protocol methods
   
   //animate a change from one viewcontroller to another
   func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
      
      // get reference to our fromView, toView and the container view that we should perform the transition in
      let container = transitionContext.containerView()
      
      // create a tuple of our screens
      let screens : (from:UIViewController, to:UIViewController) = (transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!, transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!)
      
      // assign references to our menu view controller and the 'bottom' view controller from the tuple
      
      let menuViewController = !self.presenting ? screens.from as! MenuViewController : screens.to as! MenuViewController
      let bottomViewController = !self.presenting ? screens.to as UIViewController : screens.from as UIViewController
      
      let menuView = menuViewController.view
      let bottomView = bottomViewController.view
      
      // prepare menu items to slide in
      if (self.presenting){
         self.offStageMenuController(menuViewController)
      }
      
      // add the both views to our view controller
      container!.addSubview(bottomView)
      container!.addSubview(menuView)
      
      let duration = self.transitionDuration(transitionContext)
      
      // perform the animation!
      UIView.animateWithDuration(duration, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: [], animations: {
         
         if (self.presenting){
            self.onStageMenuController(menuViewController) // onstage items: slide in
//            menuViewController.view.alpha = 1
         }
         else {
            self.offStageMenuController(menuViewController) // offstage items: slide out
//            menuViewController.view.alpha = 0
         }
         
         }, completion: { finished in
            
            // tell our transitionContext object that we've finished animating
            transitionContext.completeTransition(true)
            
            UIApplication.sharedApplication().keyWindow!.addSubview(screens.to.view)
            
      })

   }
   
   func offStage(amount: CGFloat) -> CGAffineTransform {
      return CGAffineTransformMakeTranslation(amount, 0)
   }
   
   func offStageMenuController(menuViewController: MenuViewController){
      
      menuViewController.view.alpha = 0
      
      // setup paramaters for 2D transitions for animations
      let topRowOffset  :CGFloat = 300
      let bottomRowOffset  :CGFloat = 50
      
      menuViewController.tourCitiesButton.transform = self.offStage(-topRowOffset)
      menuViewController.tourCitiesLabel.transform = self.offStage(-topRowOffset)
      
      menuViewController.contactButton.transform = self.offStage(-bottomRowOffset)
      menuViewController.contactLabel.transform = self.offStage(-bottomRowOffset)
      
      menuViewController.eventFeedButton.transform = self.offStage(topRowOffset)
      menuViewController.eventFeedLabel.transform = self.offStage(topRowOffset)
      
      menuViewController.socialMediaButton.transform = self.offStage(bottomRowOffset)
      menuViewController.socialMediaLabel.transform = self.offStage(bottomRowOffset)
      
      
   }
   
   func onStageMenuController(menuViewController: MenuViewController){
      
      // prepare menu to fade in
      menuViewController.view.alpha = 1
      
      menuViewController.tourCitiesButton.transform = CGAffineTransformIdentity
      menuViewController.tourCitiesLabel.transform = CGAffineTransformIdentity
      
      menuViewController.contactButton.transform = CGAffineTransformIdentity
      menuViewController.contactLabel.transform = CGAffineTransformIdentity
      
      menuViewController.eventFeedButton.transform = CGAffineTransformIdentity
      menuViewController.eventFeedLabel.transform = CGAffineTransformIdentity
      
      menuViewController.socialMediaButton.transform = CGAffineTransformIdentity
      menuViewController.socialMediaLabel.transform = CGAffineTransformIdentity
      
   }
   
   //return animation time in seconds
   func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
      return 0.5
   }
   
   //MARK: UIViewControllerTransitioningDelegate protocol methods
   
   //return the animator when presenting a view controller
   func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
      self.presenting = true
      return self
   }
   
   //return the animator when dissming from a view controller
   func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
      self.presenting = false
      return self
      
   }
   
   
   
}






