//
//  RecipeDetailViewController+UICollectionViewDataSource.swift
//  Recipes
//
//  Created by Nofel Mahmood on 25/10/2015.
//  Copyright © 2015 Hyper. All rights reserved.
//

import UIKit

extension RecipeDetailViewController: UICollectionViewDataSource {
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return recipes.count
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("RecipeDetailCollectionViewCell", forIndexPath: indexPath) as? RecipeDetailCollectionViewCell {
      let recipe = recipes[indexPath.row]
      cell.configureCellWithRecipe(recipe)
      cell.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: containerViewHeightConstraint.constant, right: 0)
      recipe.photo({ image in
        if let image = image {
          NSOperationQueue.mainQueue().addOperationWithBlock({
            if let correspondingCell = collectionView.cellForItemAtIndexPath(NSIndexPath(forItem: indexPath.row, inSection: 0)) as? RecipeDetailCollectionViewCell {
              correspondingCell.photoImageView.image = image
              correspondingCell.backgroundImageView.image = image
            }
          })
        }
      })
      cell.scrollViewDidScroll = ({ contentOffset in
        if contentOffset.y >= (cell.photoImageView.frame.size.height - self.navigationController!.navigationBar.frame.size.height - UIApplication.sharedApplication().statusBarFrame.size.height) {
          self.setNavigationBarTransparent(false)
          if contentOffset.y >= cell.descriptionTextView.frame.origin.y - UIApplication.sharedApplication().statusBarFrame.size.height - self.navigationController!.navigationBar.frame.size.height {
            self.navigationItem.title = cell.nameTextField.text
          } else {
            self.navigationItem.title = ""
          }
        } else {
          self.setNavigationBarTransparent(true)
        }
      })
      cell.photoEditButtonDidPress = ({
        self.showAlertControllerForSelectingPhoto()
      })
      return cell
    }
    return UICollectionViewCell()
  }
}