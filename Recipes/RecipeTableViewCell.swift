//
//  RecipesTableViewCell.swift
//  Recipes
//
//  Created by Nofel Mahmood on 30/08/2015.
//  Copyright © 2015 Hyper. All rights reserved.
//

import UIKit

class RecipeTableViewCell: UITableViewCell {
  
  @IBOutlet var nameLabel: UILabel!
  @IBOutlet var difficultyLabel: UILabel!
  @IBOutlet var favoriteButton: UIButton!
  @IBOutlet var backgroundImageView: UIImageView!
  @IBOutlet var backgroundImageViewWrapper: UIView!
  
  var recipe: Recipe!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    self.backgroundImageViewWrapper.clipsToBounds = true
    self.backgroundColor = UIColor.clearColor()
    
  }
  
  func updateCellFromRecipe(recipe: Recipe, scope: RecipesScope) {
    self.recipe = recipe
    self.nameLabel.text = recipe.name
    self.difficultyLabel.text = self.recipe.difficultyDescription()
    if let favorite = recipe.favorite?.boolValue {
      self.favoriteButton.selected = favorite
    } else {
      self.favoriteButton.selected = false
    }
    if scope == RecipesScope.All {
      self.favoriteButton.hidden = false
    } else if scope == RecipesScope.Favories {
      self.favoriteButton.hidden = true
    }
  }

  @IBAction func favoriteButtonTapped(sender: AnyObject?) {
    self.favoriteButton.selected = !self.favoriteButton.selected
    self.recipe.favorite = self.favoriteButton.selected
    recipe.createOrUpdateOnRemote(nil)
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    // Configure the view for the selected state
  }
}
