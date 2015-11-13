//
//  RecipeListCollectionViewCell.swift
//  Recipes
//
//  Created by Nofel Mahmood on 29/09/2015.
//  Copyright © 2015 Hyper. All rights reserved.
//

import UIKit

extension RecipeListCollectionViewCell: UICollectionViewCellParallax {
  func updateWithParallaxOffset(offset: CGPoint) {
    self.backgroundImageViewCenterYConstraint.constant = offset.y
  }
}

class RecipeListCollectionViewCell: UICollectionViewCell {
  @IBOutlet var backgroundImageView: UIImageView!
  @IBOutlet var favoriteButton: UIButton?
  @IBOutlet var nameLabel: UILabel!
  @IBOutlet var backgroundImageViewCenterYConstraint: NSLayoutConstraint!
  
  private var recipeViewModel: RecipeViewModel!
  
  func configureUsingRecipe(recipe: RecipeViewModel, inScope scope: Int) {
    if scope == RecipesScope.Favorites {
      self.favoriteButton?.hidden = true
    }
    self.recipeViewModel = recipe
    self.nameLabel.text = recipe.name
    if let favorite = recipe.favorite {
      self.favoriteButton?.selected = favorite
    }
  }
  
  override func prepareForReuse() {
    self.backgroundImageView.image = UIImage(named: "ImagePlaceholder")
    self.nameLabel.text = ""
    self.favoriteButton?.selected = false
    self.favoriteButton?.hidden = false
  }
  
  // MARK: IBAction
  @IBAction func favoriteButtonDidPress(sender: UIButton) {
    sender.selected = !sender.selected
    self.recipeViewModel.favorite = sender.selected
  }

}
