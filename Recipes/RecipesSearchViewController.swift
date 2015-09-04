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

extension RecipesSearchViewController: UISearchControllerDelegate {
  
  func didPresentSearchController(searchController: UISearchController) {
    self.searchController.searchBar.becomeFirstResponder()
  }
  
  func didDismissSearchController(searchController: UISearchController) {
    self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
  }
}

extension RecipesSearchViewController: UISearchResultsUpdating {
  func updateSearchResultsForSearchController(searchController: UISearchController) {
    guard let searchString = searchController.searchBar.text else {
      self.searchResults.removeAll()
      self.tableView.reloadData()
      return
    }
    guard let recipes = self.recipes else {
      return
    }
    
    self.searchResults = recipes.filter({ (recipe) -> Bool in
      if recipe.name!.rangeOfString(searchString, options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil, locale: nil) != nil {
        return true
      }
      return false
    })
    
    self.tableView.reloadData()
    
  }
}

extension RecipesSearchViewController: UITableViewDataSource {
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.searchResults.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(RecipeSearchTableViewCellIdentifier, forIndexPath: indexPath) as! RecipeSearchTableViewCell
    let recipe = self.searchResults[indexPath.row]
    cell.nameLabel.text = recipe.name!
    if let photo = recipe.photo!.data {
      cell.photoImageView.image = UIImage(data: photo)
    }
    return cell
  }
}

extension RecipesSearchViewController: UITableViewDelegate {
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    self.performSegueWithIdentifier(RecipeSearchSegue.RecipeModifier.rawValue, sender: self)
  }
}

class RecipesSearchViewController: UIViewController {
  
  @IBOutlet var tableView: UITableView!
  let searchController = UISearchController(searchResultsController: nil)
  
  var recipes: [Recipe]?
  var searchResults = [Recipe]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    self.searchController.searchResultsUpdater = self
    searchController.hidesNavigationBarDuringPresentation = false
    searchController.dimsBackgroundDuringPresentation = false
    searchController.searchBar.sizeToFit()
    self.navigationItem.titleView = self.searchController.searchBar
    self.searchController.searchBar.searchBarStyle = UISearchBarStyle.Prominent
    self.searchController.delegate = self
    self.searchController.searchBar.returnKeyType = UIReturnKeyType.Done
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    self.searchController.active = true
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
  /*
  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
  // Get the new view controller using segue.destinationViewController.
  // Pass the selected object to the new view controller.
  }
  */
  
}
