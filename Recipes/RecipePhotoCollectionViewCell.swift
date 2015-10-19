//
//  RecipePhotoCollectionViewCell.swift
//  Recipes
//
//  Created by Nofel Mahmood on 15/10/2015.
//  Copyright © 2015 Hyper. All rights reserved.
//

import UIKit
import QuartzCore

class RecipePhotoCollectionViewCell: UICollectionViewCell {
  @IBOutlet var photoImageView: UIImageView!
  @IBOutlet var photoImageViewWidthConstraint: NSLayoutConstraint!
  @IBOutlet var photoImageViewHeightConstraint: NSLayoutConstraint!
  
  override func awakeFromNib() {
    self.photoImageView.image = nil
  }
  
  func performSelection(select: Bool) {
    if select {
      self.photoImageView.layer.cornerRadius = 1.0
      self.photoImageView.layer.borderColor = UIColor.appKeyColor().CGColor
      self.photoImageView.layer.borderWidth = 2.0
      self.photoImageView.layer.masksToBounds = true
    } else {
      self.photoImageView.layer.borderWidth = 0.0
    }
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    self.photoImageView.image = nil
    self.photoImageView.layer.borderWidth = 0.0
    self.performSelection(self.selected)
  }
}


