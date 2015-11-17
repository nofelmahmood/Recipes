//
//  RecipesFilterViewController.swift
//  Recipes
//
//  Created by Nofel Mahmood on 01/10/2015.
//  Copyright © 2015 Hyper. All rights reserved.
//

import UIKit

protocol RecipesFilterViewControllerDelegate {
  func recipesFilterViewController(controller: RecipesFilterViewController, didSelectFilter filter: String)
}

class RecipesFilterViewController: UIViewController {
  
  @IBOutlet var tableView: UITableView!
  
  var delegate: RecipesFilterViewControllerDelegate?
  var selectedFilter: String!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    selectFilterRow()
  }
  
  func selectFilterRow() {
    if selectedFilter == RecipesFilter.ShowAll {
      tableView.selectRowAtIndexPath(NSIndexPath(forRow: 3, inSection: 0), animated: true, scrollPosition: .None)
    } else if selectedFilter == RecipesFilter.Hard {
       tableView.selectRowAtIndexPath(NSIndexPath(forRow: 2, inSection: 0), animated: true, scrollPosition: .None)
    } else if selectedFilter == RecipesFilter.Medium {
      tableView.selectRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 0), animated: true, scrollPosition: .None)
    } else if selectedFilter == RecipesFilter.Easy {
      tableView.selectRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), animated: true, scrollPosition: .None)
    }
  }
  
  func selectedRecipesFilter() -> String {
    if let selectedRowIndexPath = tableView.indexPathForSelectedRow {
      switch(selectedRowIndexPath.row) {
      case 0:
        return RecipesFilter.Easy
      case 1:
        return RecipesFilter.Medium
      case 2:
        return RecipesFilter.Hard
      default:
        return RecipesFilter.ShowAll
      }
    }
    return RecipesFilter.ShowAll
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
}
