//
//  RecipeDetailViewController+UIScrollViewDelegate.swift
//  Recipes
//
//  Created by Nofel Mahmood on 25/10/2015.
//  Copyright © 2015 Hyper. All rights reserved.
//

import UIKit

extension RecipeDetailViewController: UIScrollViewDelegate {
  func scrollViewDidScroll(scrollView: UIScrollView) {
    self.collectionView.deselectItemAtIndexPath(NSIndexPath(forItem: self.selectedRecipeIndex, inSection: 0), animated: true)
    if let visibleItemIndexPath = self.collectionView.indexPathsForVisibleItems().first {
      if let previousSelectedIndexPath = self.recipesSelectorViewController?.collectionView.indexPathsForVisibleItems().first {
        self.recipesSelectorViewController?.collectionView.deselectItemAtIndexPath(previousSelectedIndexPath, animated: false)
      }
      self.selectedRecipeIndex = visibleItemIndexPath.row
      self.recipesSelectorViewController?.collectionView.selectItemAtIndexPath(visibleItemIndexPath, animated: true, scrollPosition: UICollectionViewScrollPosition.CenteredHorizontally)
    }
  }
}