//
//  RecipesSearchViewController+UISearch.swift
//  Recipes
//
//  Created by Nofel Mahmood on 25/10/2015.
//  Copyright © 2015 Hyper. All rights reserved.
//

import UIKit

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
      if recipe.name.rangeOfString(searchString, options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil, locale: nil) != nil {
        return true
      }
      return false
    })
    self.tableView.reloadData()
  }
}