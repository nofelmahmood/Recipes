//
//  RecipeDetailViewController+UIImagePickerControllerDelegate.swift
//  Recipes
//
//  Created by Nofel Mahmood on 25/10/2015.
//  Copyright © 2015 Hyper. All rights reserved.
//

import UIKit

// Required for implementing UIImagePickerControllerDelegate
extension RecipeDetailViewController: UINavigationControllerDelegate {
  
}

extension RecipeDetailViewController: UIImagePickerControllerDelegate {
  func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
    self.dismissViewControllerAnimated(true, completion: {
      if let selectedIndexPath = self.collectionView.indexPathsForVisibleItems().first {
        let recipe = self.recipes[selectedIndexPath.row]
        recipe.photo = image
        if let cell = self.collectionView.cellForItemAtIndexPath(selectedIndexPath) as? RecipeDetailCollectionViewCell {
          cell.photoImageView.image = image
          cell.editing = true
        }
      }
    })
  }
  
  func imagePickerControllerDidCancel(picker: UIImagePickerController) {
    self.dismissViewControllerAnimated(true, completion: {
      if let selectedIndexPath = self.collectionView.indexPathsForVisibleItems().first {
        if let cell = self.collectionView.cellForItemAtIndexPath(selectedIndexPath) as? RecipeDetailCollectionViewCell {
          cell.editing = true
        }
      }
    })
  }
}