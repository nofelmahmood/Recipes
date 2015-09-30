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
  @IBOutlet var nameLabel: UILabel!
  @IBOutlet var backgroundImageViewCenterYConstraint: NSLayoutConstraint!
  
  func configureUsingRecipe(recipe: RecipeViewModel) {
    self.nameLabel.text = recipe.name
    if let photo = recipe.photo {
      self.backgroundImageView.image = photo
    }
  }
  
  override func prepareForReuse() {
//    self.backgroundImageView.image = UIImage(named: "ImagePlaceholder")
    self.nameLabel.text = ""
  }
}
