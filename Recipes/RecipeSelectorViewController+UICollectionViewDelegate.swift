//
//  RecipeSelectorViewController+UICollectionViewDelegate.swift
//  Recipes
//
//  Created by Nofel Mahmood on 25/10/2015.
//  Copyright © 2015 Hyper. All rights reserved.
//

import UIKit

extension RecipesSelectorViewController: UICollectionViewDelegate {
  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    if let selectedItemIndexPath = self.selectedItemIndexPath {
      if let cell = collectionView.cellForItemAtIndexPath(selectedItemIndexPath) as? RecipePhotoCollectionViewCell {
        cell.performSelection(false)
      }
    }
    self.selectedItemIndexPath = indexPath
    if let cell = collectionView.cellForItemAtIndexPath(indexPath) as? RecipePhotoCollectionViewCell {
      cell.performSelection(true)
    }
    self.recipeDetailViewController.collectionView.layoutIfNeeded()
    self.recipeDetailViewController.collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: UICollectionViewScrollPosition.CenteredHorizontally, animated: true)
  }
  
  func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
    if let cell = collectionView.cellForItemAtIndexPath(indexPath) as? RecipePhotoCollectionViewCell {
      cell.performSelection(false)
    }
  }
}