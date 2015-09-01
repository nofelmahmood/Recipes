//
//  UITableViewCell+Helper.swift
//  Recipes
//
//  Created by Nofel Mahmood on 01/09/2015.
//  Copyright © 2015 Hyper. All rights reserved.
//

import UIKit

extension UITableViewCell {
  func tableView() -> UITableView? {
    return self.superview?.superview as? UITableView
  }
}
