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
    guard let imageView = view.subviews.filter({ UINavigationBar.findHairlineImageView($0) != nil }).first
      else { return nil }
    return imageView as? UIImageView
  }
}
