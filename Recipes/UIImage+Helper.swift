//
//  UIImage+Helper.swift
//  Recipes
//
//  Created by Nofel Mahmood on 01/09/2015.
//  Copyright © 2015 Hyper. All rights reserved.
//

import UIKit

extension UIImage {
  class func scaledUIImageToSize(let image: UIImage, let size: CGSize) -> UIImage {
    let hasAlpha = false
    let scale: CGFloat = 0.0 // Automatically use scale factor of main screen
    
    UIGraphicsBeginImageContextWithOptions(size, !hasAlpha, scale)
    image.drawInRect(CGRect(origin: CGPointZero, size: size))
    
    let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return scaledImage
  }
}
