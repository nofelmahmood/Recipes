//
//  RecipesToRecipesSearchAnimationController.swift
//  Recipes
//
//  Created by Nofel Mahmood on 07/10/2015.
//  Copyright © 2015 Hyper. All rights reserved.
//

import UIKit

extension RecipesToRecipesSearchAnimationController: UIViewControllerAnimatedTransitioning {
  func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
    return 1.0
  }
  
  func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
    if (transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as? UINavigationController)?.topViewController is RecipesSearchViewController {
      let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
      let containerView = transitionContext.containerView()
      (toViewController as? UINavigationController)?.setNavigationBarHidden(true, animated: true)
      containerView?.addSubview(toViewController.view)
      containerView?.sendSubviewToBack(toViewController.view)
      UIView.animateWithDuration(transitionDuration(transitionContext), animations: {
        (toViewController as? UINavigationController)?.setNavigationBarHidden(false, animated: true)
        }, completion: { completion in
          transitionContext.completeTransition(true)
      })
    } else {
      let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
      let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
      let containerView = transitionContext.containerView()
      containerView?.addSubview(toViewController.view)
      containerView?.sendSubviewToBack(toViewController.view)
      UIView.animateWithDuration(transitionDuration(transitionContext) - 0.4, animations: {
        (fromViewController as? UINavigationController)?.setNavigationBarHidden(true, animated: true)
        fromViewController.view.alpha = 0.0
        }, completion: { completion in
          transitionContext.completeTransition(true)
      })
    }
  }
}

class RecipesToRecipesSearchAnimationController: NSObject {

}
