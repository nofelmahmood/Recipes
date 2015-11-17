//
//  AppDelegate.swift
//  Recipes
//
//  Created by Nofel Mahmood on 29/08/2015.
//  Copyright © 2015 Hyper. All rights reserved.
//

import UIKit
import CoreData
import CoreSpotlight

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {
  
  var window: UIWindow?
  
  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    UITabBar.appearance().tintColor = UIColor.appKeyColor()
    return true
  }
  
  func application(application: UIApplication, continueUserActivity userActivity: NSUserActivity, restorationHandler: ([AnyObject]?) -> Void) -> Bool {
    if let recipesListViewController = ((self.window?.rootViewController as? UITabBarController)?.selectedViewController?.childViewControllers.first as? UINavigationController)?.topViewController as? RecipesListViewController {
      if let recipeID = (userActivity.userInfo?[CSSearchableItemActivityIdentifier] as? NSString)?.intValue {
        recipesListViewController.handleUserActivityWithRecipeID(recipeID)
      }
    }
    return false
  }
}

