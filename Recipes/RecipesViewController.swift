//
//  RecipesViewController.swift
//  Recipes
//
//  Created by Nofel Mahmood on 30/08/2015.
//  Copyright © 2015 Hyper. All rights reserved.
//

import UIKit
import CoreData


class RecipesViewController: UIViewController {
  
  @IBOutlet var tableView: UITableView!
  var recipes: [Recipe]?
  
  func prepareDataSource(completionBlock: (() -> Void)?) throws
  {
    let fetchRequest = NSFetchRequest(entityName: RecipeEntityName)
    let asynchronousFetchRequest = NSAsynchronousFetchRequest(fetchRequest: fetchRequest) { (result) -> Void in
      if let finalResult = result.finalResult as? [Recipe] {
        self.recipes = finalResult
      }
    }
    _ = try? CoreDataStack.defaultStack.managedObjectContext.executeRequest(asynchronousFetchRequest)
    
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    _ = try? self.prepareDataSource({ () -> Void in
      NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
        self.tableView.reloadData()
      })
    })
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
