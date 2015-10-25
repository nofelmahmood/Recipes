//
//  RecipeDetailCollectionViewCell+UIScrollViewDelegate.swift
//  Recipes
//
//  Created by Nofel Mahmood on 25/10/2015.
//  Copyright © 2015 Hyper. All rights reserved.
//

import UIKit

extension RecipeDetailCollectionViewCell: UIScrollViewDelegate {
  func scrollViewDidScroll(scrollView: UIScrollView) {
    self.scrollViewDidScroll?(contentOffset: scrollView.contentOffset)
  }
}