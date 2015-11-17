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
    if let visibleItemIndexPath = collectionView.indexPathsForVisibleItems().first {
      recipesSelectorViewController?.collectionView.selectItemAtIndexPath(NSIndexPath(forItem: visibleItemIndexPath.row + 1, inSection: 0), animated: true, scrollPosition: UICollectionViewScrollPosition.CenteredHorizontally)
    }
  }
}