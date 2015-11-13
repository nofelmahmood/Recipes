//
//  RecipeDetailViewController+UIScrollViewDelegate.swift
//  Recipes
//
//  Created by Nofel Mahmood on 25/10/2015.
//  Copyright © 2015 Hyper. All rights reserved.
//

import UIKit

extension RecipeDetailViewController: UIScrollViewDelegate {
  
  func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
    if let visibleItemIndexPath = self.collectionView.indexPathsForVisibleItems().first {
      self.recipesSelectorViewController?.collectionView.selectItemAtIndexPath(NSIndexPath(forItem: visibleItemIndexPath.row + 1, inSection: 0), animated: true, scrollPosition: UICollectionViewScrollPosition.CenteredHorizontally)
    }
  }
}