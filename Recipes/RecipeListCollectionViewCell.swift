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
    backgroundImageViewCenterYConstraint.constant = offset.y
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
      favoriteButton?.hidden = true
    }
    recipeViewModel = recipe
    nameLabel.text = recipe.name
    if let favorite = recipe.favorite {
      favoriteButton?.selected = favorite
    }
  }
  
  override func prepareForReuse() {
    backgroundImageView.image = UIImage(named: "ImagePlaceholder")
    nameLabel.text = ""
    favoriteButton?.selected = false
    favoriteButton?.hidden = false
  }
  
  // MARK: IBAction
  @IBAction func favoriteButtonDidPress(sender: UIButton) {
    sender.selected = !sender.selected
    recipeViewModel.favorite = sender.selected
  }

}
