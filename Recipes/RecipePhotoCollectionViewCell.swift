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
  
  override var selected: Bool {
    didSet {
      if selected {
        photoImageView.layer.cornerRadius = 1.0
        photoImageView.layer.borderColor = UIColor.appKeyColor().CGColor
        photoImageView.layer.borderWidth = 2.0
        photoImageView.layer.masksToBounds = true
      } else {
        photoImageView.layer.borderWidth = 0.0
        photoImageView.layer.cornerRadius = 0.0
        photoImageView.layer.masksToBounds = false
      }
    }
  }
  
  override func awakeFromNib() {
    photoImageView.image = nil
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    photoImageView.image = nil
    photoImageView.layer.borderWidth = 0.0
    photoImageView.layer.cornerRadius = 0.0
    photoImageView.layer.masksToBounds = false
    photoImageViewWidthConstraint.constant = 44.0
    photoImageViewHeightConstraint.constant = 44.0
  }
}