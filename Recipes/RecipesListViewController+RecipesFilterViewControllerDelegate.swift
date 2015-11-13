//
//  RecipesListViewController+RecipesFilterViewControllerDelegate.swift
//  Recipes
//
//  Created by Nofel Mahmood on 25/10/2015.
//  Copyright © 2015 Hyper. All rights reserved.
//

import UIKit

extension RecipesListViewController: RecipesFilterViewControllerDelegate {
  func recipesFilterViewController(controller: RecipesFilterViewController, didSelectFilter filter: String) {
    self.recipesFilter = filter
    if self.recipesFilter == RecipesFilter.ShowAll {
      self.navigationBarFilterNameLabel.text = ""
    } else {
      self.navigationBarFilterNameLabel.text = self.recipesFilter
    }
    self.reloadCollectionViewDataWithNewData()
    self.dismissViewControllerAnimated(true, completion: nil)
  }
}