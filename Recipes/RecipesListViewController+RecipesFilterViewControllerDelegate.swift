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
    recipesFilter = filter
    if recipesFilter == RecipesFilter.ShowAll {
      navigationBarFilterNameLabel.text = ""
    } else {
      navigationBarFilterNameLabel.text = recipesFilter
    }
    reloadCollectionViewDataWithNewData()
    dismissViewControllerAnimated(true, completion: nil)
  }
}