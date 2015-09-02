//
//  RecipePhotoTableViewCell.swift
//  Recipes
//
//  Created by Nofel Mahmood on 31/08/2015.
//  Copyright © 2015 Hyper. All rights reserved.
//

import UIKit

class RecipePhotoTableViewCell: UITableViewCell {
  
  @IBOutlet var photoImageView: UIImageView!
  @IBOutlet var cameraButton: UIButton!
  @IBOutlet var photoLibraryButton: UIButton!
  @IBOutlet var visualEffectView: UIVisualEffectView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    self.editingAccessoryType = UITableViewCellAccessoryType.None
    self.accessoryType = UITableViewCellAccessoryType.None
    self.photoImageView.translatesAutoresizingMaskIntoConstraints = false
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    // Configure the view for the selected state
  }
  
  override func setEditing(editing: Bool, animated: Bool) {
    self.photoLibraryButton.hidden = !editing
    self.cameraButton.hidden = !editing
    self.visualEffectView.hidden = !editing
  }
}
