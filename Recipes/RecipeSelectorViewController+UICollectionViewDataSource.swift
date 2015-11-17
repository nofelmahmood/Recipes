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
    return recipes.count + 1
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("RecipePhotoCollectionViewCell", forIndexPath: indexPath) as? RecipePhotoCollectionViewCell {
      if indexPath.row == 0 {
        cell.photoImageView.image = UIImage(named: "Add")
        cell.photoImageViewHeightConstraint.constant = 23.0
        cell.photoImageViewWidthConstraint.constant = 23.0
        return cell
      }
      let recipe = recipes[(indexPath.row - 1)]
      recipe.photo({ image in
        if let image = image {
          NSOperationQueue.mainQueue().addOperationWithBlock({
            if let correspondingCell = collectionView.cellForItemAtIndexPath(NSIndexPath(forItem: indexPath.row, inSection: 0)) as? RecipePhotoCollectionViewCell {
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