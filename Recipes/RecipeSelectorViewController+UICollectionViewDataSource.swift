//
//  RecipeSelectorViewController+UICollectionViewDataSource.swift
//  Recipes
//
//  Created by Nofel Mahmood on 25/10/2015.
//  Copyright © 2015 Hyper. All rights reserved.
//

import UIKit

extension RecipesSelectorViewController: UICollectionViewDataSource {
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.recipes.count
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("RecipePhotoCollectionViewCell", forIndexPath: indexPath) as? RecipePhotoCollectionViewCell {
      let recipe = self.recipes[indexPath.row]
      if self.recipeDetailViewController.selectedRecipeIndex == indexPath.row {
        cell.performSelection(true)
      }
      recipe.photo({ image in
        if let image = image {
          NSOperationQueue.mainQueue().addOperationWithBlock({
            if let correspondingCell = self.collectionView.cellForItemAtIndexPath(NSIndexPath(forItem: indexPath.row, inSection: 0)) as? RecipePhotoCollectionViewCell {
              correspondingCell.photoImageView.image = image
            }
          })
        }
      })
      return cell
    }
    return UICollectionViewCell()
  }
}
