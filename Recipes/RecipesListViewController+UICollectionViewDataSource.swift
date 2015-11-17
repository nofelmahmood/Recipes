//
//  RecipesListViewController+UICollectionViewDataSource.swift
//  Recipes
//
//  Created by Nofel Mahmood on 29/09/2015.
//  Copyright © 2015 Hyper. All rights reserved.
//

import UIKit

let reuseIdentifier = "RecipeListCollectionViewCell"

extension RecipesListViewController: UICollectionViewDataSource {
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return recipes.count
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    if let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as? RecipeListCollectionViewCell {
      let recipe = recipes[indexPath.row]
      cell.configureUsingRecipe(recipe, inScope: recipesScope)
      recipe.photo({ photo in
        if let photo = photo, let index = self.recipes.indexOf(recipe) {
          NSOperationQueue.mainQueue().addOperationWithBlock({
            if let correspondingCell = collectionView.cellForItemAtIndexPath(NSIndexPath(forItem: index, inSection: 0)) as? RecipeListCollectionViewCell {
              correspondingCell.backgroundImageView.image = photo
            }
          })
        }
      })
      return cell
    }
    return UICollectionViewCell()
  }
}