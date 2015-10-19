//
//  RecipesFilterViewController.swift
//  Recipes
//
//  Created by Nofel Mahmood on 01/10/2015.
//  Copyright © 2015 Hyper. All rights reserved.
//

import UIKit

extension RecipesFilterViewController: UITableViewDataSource {
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 4
  }
    
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCellWithIdentifier("RecipesFilterTableViewCell", forIndexPath: indexPath) as? RecipesFilterTableViewCell {
      if indexPath.row == 0 {
        cell.nameLabel.text = RecipeDifficulty.Easy
      } else if indexPath.row == 1 {
        cell.nameLabel.text = RecipeDifficulty.Medium
      } else if indexPath.row == 2 {
        cell.nameLabel.text = RecipeDifficulty.Hard
      } else {
        cell.nameLabel.textColor = UIColor.appKeyColor()
        cell.nameLabel.text = "Show All"
      }
      return cell
    }
    return UITableViewCell()
  }
}

extension RecipesFilterViewController: UITableViewDelegate {
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    self.delegate?.recipesFilterViewController(self, didSelectFilter: self.selectedRecipesFilter())
  }
}

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
