//
//  RecipesSearchViewController+UITableViewDataSource.swift
//  Recipes
//
//  Created by Nofel Mahmood on 25/10/2015.
//  Copyright © 2015 Hyper. All rights reserved.
//

import UIKit

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
    cell.nameLabel.text = recipe.name
    recipe.photo({ photo in
      if let photo = photo, let index = self.searchResults.indexOf(recipe) {
        NSOperationQueue.mainQueue().addOperationWithBlock({
          if let correspondingCell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0)) as? RecipeSearchTableViewCell {
            correspondingCell.photoImageView.image = photo
          }
        })
      }
    })
    return cell
  }
}