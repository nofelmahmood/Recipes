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
      if self.selected {
        self.photoImageView.layer.cornerRadius = 1.0
        self.photoImageView.layer.borderColor = UIColor.appKeyColor().CGColor
        self.photoImageView.layer.borderWidth = 2.0
        self.photoImageView.layer.masksToBounds = true
      } else {
        self.photoImageView.layer.borderWidth = 0.0
        self.photoImageView.layer.cornerRadius = 0.0
        self.photoImageView.layer.masksToBounds = false
      }
    }
  }
  
  override func awakeFromNib() {
    self.photoImageView.image = nil
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    self.photoImageView.image = nil
    self.photoImageView.layer.borderWidth = 0.0
    self.photoImageView.layer.cornerRadius = 0.0
    self.photoImageView.layer.masksToBounds = false
    self.photoImageViewWidthConstraint.constant = 44.0
    self.photoImageViewHeightConstraint.constant = 44.0
  }
}


