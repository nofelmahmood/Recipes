//
//  RecipesSearchViewController.swift
//  Recipes
//
//  Created by Nofel Mahmood on 31/08/2015.
//  Copyright © 2015 Hyper. All rights reserved.
//

import UIKit

enum RecipeSearchSegue: String {
  case RecipeModifier = "RecipeModifier"
}

let RecipeSearchTableViewCellIdentifier = "RecipeSearchTableViewCell"

class RecipesSearchViewController: UIViewController {
  
  @IBOutlet var tableView: UITableView!
  @IBOutlet var backgroundImageView: UIImageView!
  var imageToBlur: UIImage!
  let searchController = UISearchController(searchResultsController: nil)
  
  var recipes: [RecipeViewModel]!
  var searchResults = [RecipeViewModel]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    self.searchController.searchResultsUpdater = self
    searchController.hidesNavigationBarDuringPresentation = false
    searchController.dimsBackgroundDuringPresentation = false
    searchController.searchBar.sizeToFit()
    self.navigationItem.titleView = self.searchController.searchBar
    self.searchController.searchBar.searchBarStyle = UISearchBarStyle.Minimal
    self.searchController.delegate = self
    self.searchController.searchBar.returnKeyType = UIReturnKeyType.Done
    self.searchController.active = true
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    self.navigationItem.backBarButtonItem?.title = ""
    self.backgroundImageView.image = self.imageToBlur
    self.performSelector("focusSearchBar", withObject: nil, afterDelay: 0.1)
  }
  
  func focusSearchBar() {
    self.searchController.searchBar.becomeFirstResponder()
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
  }
  
  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
    NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  // MARK: Keyboard
  func keyboardWillShow(notification: NSNotification) {
    guard let userInfo = notification.userInfo else {
      return
    }
    var keyboardFrame = userInfo["UIKeyboardFrameEndUserInfoKey"]!.CGRectValue
    keyboardFrame = self.tableView.convertRect(keyboardFrame, fromView: nil)
    let intersect = CGRectIntersection(keyboardFrame, self.tableView.bounds)
    if !CGRectIsNull(intersect) {
      let duration = userInfo["UIKeyboardAnimationDurationUserInfoKey"]!.doubleValue
      UIView.animateWithDuration(duration, animations: { () -> Void in
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, intersect.size.height, 0)
        self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, intersect.size.height, 0)
      })
    }
  }
  
  func keyboardWillHide(notification: NSNotification) {
    guard let userInfo = notification.userInfo else {
      return
    }
    let duration = userInfo["UIKeyboardAnimationDurationUserInfoKey"]!.doubleValue
    UIView.animateWithDuration(duration) { () -> Void in
      self.tableView.contentInset = UIEdgeInsetsZero
      self.tableView.scrollIndicatorInsets = UIEdgeInsetsZero
    }
  }
  
  // MARK: - Navigation
  
//   In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
  // Get the new view controller using segue.destinationViewController.
  // Pass the selected object to the new view controller.
    if segue.identifier == "RecipeDetailViewController" {
      let recipeDetailViewController = segue.destinationViewController as? RecipeDetailViewController
      recipeDetailViewController?.recipes = self.recipes
      if let selectedIndexPath = self.tableView.indexPathForSelectedRow {
        let recipe = self.searchResults[selectedIndexPath.row]
        if let index = self.recipes.indexOf(recipe) {
          recipeDetailViewController?.selectedRecipeIndex = index
        }
      }
      recipeDetailViewController?.displayedForCreatingRecipe = false
      
    }
  }
}
