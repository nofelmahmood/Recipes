//
//  RecipesSearchViewController+UISearchControllerDelegate.swift
//  Recipes
//
//  Created by Nofel Mahmood on 25/10/2015.
//  Copyright © 2015 Hyper. All rights reserved.
//

import UIKit

extension RecipesSearchViewController: UISearchControllerDelegate {
  func didDismissSearchController(searchController: UISearchController) {
    self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
  }
}