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
    if indexPath.row == 0 {
      let newRecipe = RecipeViewModel(withModel: nil)
      self.recipeDetailViewController.recipes.insert(newRecipe, atIndex: 0)
      self.recipeDetailViewController.collectionView.scrollToItemAtIndexPath(NSIndexPath(forItem: 0, inSection: 0), atScrollPosition: UICollectionViewScrollPosition.CenteredHorizontally, animated: true)
      self.recipeDetailViewController.setEditing(true, animated: true)
    } else {
      self.recipeDetailViewController.collectionView.layoutIfNeeded()
      self.recipeDetailViewController.collectionView.scrollToItemAtIndexPath(NSIndexPath(forItem: indexPath.row - 1, inSection: 0), atScrollPosition: UICollectionViewScrollPosition.CenteredHorizontally, animated: true)
    }
  }
  
  func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {

  }
}