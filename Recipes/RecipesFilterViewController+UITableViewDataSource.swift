//
//  RecipesFilterViewController+UITableViewDataSource.swift
//  Recipes
//
//  Created by Nofel Mahmood on 25/10/2015.
//  Copyright © 2015 Hyper. All rights reserved.
//

import UIKit

extension RecipesFilterViewController: UITableViewDataSource {
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 4
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCellWithIdentifier("RecipesFilterTableViewCell", forIndexPath: indexPath) as? RecipesFilterTableViewCell {
      if indexPath.row == 0 {
        cell.nameLabel.text = RecipeDifficulty.Easy
      } else if indexPath.row == 1 {
        cell.nameLabel.text = RecipeDifficulty.Medium
      } else if indexPath.row == 2 {
        cell.nameLabel.text = RecipeDifficulty.Hard
      } else {
        cell.nameLabel.textColor = UIColor.appKeyColor()
        cell.nameLabel.text = "Show All"
      }
      return cell
    }
    return UITableViewCell()
  }
}