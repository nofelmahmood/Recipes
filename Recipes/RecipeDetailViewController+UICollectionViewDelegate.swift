//
//  RecipeDetailViewController+UICollectionViewDelegate.swift
//  Recipes
//
//  Created by Nofel Mahmood on 25/10/2015.
//  Copyright © 2015 Hyper. All rights reserved.
//

import UIKit

extension RecipeDetailViewController: UICollectionViewDelegate {
  func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
    setNavigationBarTransparent(true)
    navigationItem.title = ""
  }
}