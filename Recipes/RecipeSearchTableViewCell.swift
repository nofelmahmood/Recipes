//
//  RecipeSearchTableViewCell.swift
//  Recipes
//
//  Created by Nofel Mahmood on 01/10/2015.
//  Copyright © 2015 Hyper. All rights reserved.
//

import UIKit

class RecipeSearchTableViewCell: UITableViewCell {
  
  @IBOutlet var nameLabel: UILabel!
  @IBOutlet var photoImageView: UIImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  override func prepareForReuse() {
    nameLabel.text = ""
    photoImageView.image = UIImage(named: "ImagePlaceholder")
  }
  
}
