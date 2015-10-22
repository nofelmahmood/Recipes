//
//  RecipesToRecipeDetailViewController.swift
//  Recipes
//
//  Created by Nofel Mahmood on 21/10/2015.
//  Copyright © 2015 Hyper. All rights reserved.
//

import UIKit

extension RecipesToRecipeDetailViewAnimationController: UIViewControllerAnimatedTransitioning {
  func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
    return 0.5
  }
  
  func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
    if transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) is RecipesListViewController {
      let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
      let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as! RecipeDetailViewController
      let containerView = transitionContext.containerView()
      containerView?.addSubview(fromViewController.view)
      containerView?.addSubview(toViewController.view)
      containerView?.bringSubviewToFront(toViewController.view)
      toViewController.view.frame.origin = CGPoint(x: 0, y: CGRectGetHeight(toViewController.view.frame))
      UIView.animateWithDuration(self.transitionDuration(transitionContext), delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
        fromViewController.view.transform = CGAffineTransformMakeScale(0.2,0.2)
        toViewController.view.frame.origin = CGPoint(x: 0, y: 0)
        }, completion: { completed in
          fromViewController.view.removeFromSuperview()
          transitionContext.completeTransition(true)
      })
    } else {
      let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
      let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as! RecipesListViewController
      let containerView = transitionContext.containerView()
      containerView?.addSubview(fromViewController.view)
      containerView?.addSubview(toViewController.view)
      containerView?.bringSubviewToFront(fromViewController.view)
      toViewController.view.transform = CGAffineTransformMakeScale(0.2, 0.2)
      UIView.animateWithDuration(self.transitionDuration(transitionContext), delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
        toViewController.view.transform = CGAffineTransformMakeScale(1.0, 1.0)
        fromViewController.view.frame.origin = CGPoint(x: 0, y: CGRectGetHeight(fromViewController.view.frame))
        }, completion: { completed in
          fromViewController.view.removeFromSuperview()
          transitionContext.completeTransition(true)
      })
    }
  }
}

class RecipesToRecipeDetailViewAnimationController: NSObject {
}
