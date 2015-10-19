//
//  RecipesListViewController+UIScrollView.swift
//  Recipes
//
//  Created by Nofel Mahmood on 30/09/2015.
//  Copyright © 2015 Hyper. All rights reserved.
//

import UIKit

extension RecipesListViewController: UIScrollViewDelegate {
  func scrollViewDidScroll(scrollView: UIScrollView) {
    let visibleCells = self.collectionView.visibleCells()
    for cell in visibleCells {
      if (cell as? UICollectionViewCellParallax) != nil {
        let bounds = self.collectionView.bounds
        let boundsCenter = CGPoint(x: CGRectGetMidX(bounds), y: CGRectGetMidY(bounds))
        let cellCenter = cell.center
        let offsetFromCenter = CGPointMake(boundsCenter.x - cellCenter.x, boundsCenter.y - cellCenter.y)
        let cellSize = cell.bounds.size
        let maxVerticalOffset = (bounds.size.height / 2) + (cellSize.height / 2)
        let scaleFactor = 28.0 / maxVerticalOffset
        let parallaxOffset = CGPointMake(0.0, -offsetFromCenter.y * scaleFactor)
        (cell as? UICollectionViewCellParallax)?.updateWithParallaxOffset(parallaxOffset)
      }
    }
  }
}