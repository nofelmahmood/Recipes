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
    self.selectFilterRow()
  }
  
  func selectFilterRow() {
    if self.selectedFilter == RecipesFilter.ShowAll {
      self.tableView.selectRowAtIndexPath(NSIndexPath(forRow: 3, inSection: 0), animated: true, scrollPosition: .None)
    } else if self.selectedFilter == RecipesFilter.Hard {
       self.tableView.selectRowAtIndexPath(NSIndexPath(forRow: 2, inSection: 0), animated: true, scrollPosition: .None)
    } else if self.selectedFilter == RecipesFilter.Medium {
      self.tableView.selectRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 0), animated: true, scrollPosition: .None)
    } else if self.selectedFilter == RecipesFilter.Easy {
      self.tableView.selectRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), animated: true, scrollPosition: .None)
    }
  }
  
  func selectedRecipesFilter() -> String {
    if let selectedRowIndexPath = self.tableView.indexPathForSelectedRow {
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
  
  
  /*
  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
  // Get the new view controller using segue.destinationViewController.
  // Pass the selected object to the new view controller.
  }
  */
  
}
