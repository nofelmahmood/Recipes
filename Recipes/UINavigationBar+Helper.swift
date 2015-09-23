//
//  UINavigationBar+Helper.swift
//  Recipes
//
//  Created by Nofel Mahmood on 17/09/2015.
//  Copyright © 2015 Hyper. All rights reserved.
//

import UIKit

extension UINavigationBar {
  
  class func findHairlineImageView(view: UIView) -> UIImageView? {
    if view.isKindOfClass(UIImageView.self) && view.bounds.size.height <= 1.0 {
      return view as? UIImageView
    }
    for view in view.subviews {
      let imageView = UINavigationBar.findHairlineImageView(view)
      if let imageView = imageView {
        return imageView
      }
    }
    return nil
  }
}
