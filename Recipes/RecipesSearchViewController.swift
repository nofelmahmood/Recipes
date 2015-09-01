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
      let rec: Recipe = recipe
      if rec.name!.rangeOfString(searchString, options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil, locale: nil) != nil
      {
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
    if let photo = recipe.photo {
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
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
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
