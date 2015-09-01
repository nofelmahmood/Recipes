//
//  RecipesViewController.swift
//  Recipes
//
//  Created by Nofel Mahmood on 30/08/2015.
//  Copyright © 2015 Hyper. All rights reserved.
//

import UIKit
import CoreData

let RecipeTableViewCellIdentifier = "RecipeTableViewCell"

enum RecipesSegue: String {
  case RecipesSearch = "RecipesSearch"
  case RecipeModifier = "RecipeModifier"
}

extension RecipesViewController: UITableViewDataSource {
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let recipes = self.recipes else {
      return 0
    }
    return recipes.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(RecipeTableViewCellIdentifier, forIndexPath: indexPath) as! RecipeTableViewCell
    let recipe = self.recipes![indexPath.row]
    cell.updateCellFromRecipe(recipe)
    if let image = self.cachedImages[indexPath.row] {
      cell.backgroundImageView.image = image
    } else {
      cell.backgroundImageView.image = nil
      let photoURL = NSURL(string: recipe.photo_thumbnailURL!)
      let photoURLRequest = NSURLRequest(URL: photoURL!)
      let photoDownloadTask = NSURLSession.sharedSession().downloadTaskWithRequest(photoURLRequest, completionHandler: { (location, response, error) -> Void in
        let photoData = NSData(contentsOfURL: location!)
        if let photoData = photoData {
          self.recipes![indexPath.row].photo = photoData
          self.cachedImages[indexPath.row] = UIImage(data: self.recipes![indexPath.row].photo!)
          NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
            self.tableView.beginUpdates()
            self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            self.tableView.endUpdates()
          })
        }
      })
      photoDownloadTask.resume()
    }
    return cell
  }
}

extension RecipesViewController: UITableViewDelegate {
  
  func scrollViewDidScroll(scrollView: UIScrollView) {
    let visibleCells = self.tableView.visibleCells
    let offsetY = self.tableView.contentOffset.y
    for cell in visibleCells as! [RecipeTableViewCell] {
      let x = cell.backgroundImageView.frame.origin.x
      let w = cell.backgroundImageView.bounds.width
      let h = cell.backgroundImageView.bounds.height
      let y = ((offsetY - cell.frame.origin.y) / h) * 10
      cell.backgroundImageView.frame = CGRectMake(x, y, w, h)
    }
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    self.performSegueWithIdentifier(RecipesSegue.RecipeModifier.rawValue, sender: self)
  }
}


class RecipesViewController: UIViewController {
  
  @IBOutlet var tableView: UITableView!
  @IBOutlet var segmentedControl: UISegmentedControl!
  
  var recipes: [Recipe]?
  var fetchedRecipes: [Recipe]?
  var cachedImages = [Int: UIImage]()
  
  func prepareDataSource(completionBlock: (() -> Void)?) throws {
    let fetchRequest = NSFetchRequest(entityName: RecipeEntityName)
    let asynchronousFetchRequest = NSAsynchronousFetchRequest(fetchRequest: fetchRequest) { (result) -> Void in
      if let finalResult = result.finalResult as? [Recipe] {
        self.fetchedRecipes = finalResult
        self.recipes = self.fetchedRecipes
      }
      completionBlock?()
    }
    try CoreDataStack.defaultStack.managedObjectContext.executeRequest(asynchronousFetchRequest)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    NSUserDefaults.standardUserDefaults().setObject("6f18c4ae7aaf0fd69d57", forKey: ApiTokenKey)
    NSUserDefaults.standardUserDefaults().synchronize()
    self.tableView.delegate = self
    self.tableView.dataSource = self
    do {
      try self.prepareDataSource({ () -> Void in
      NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
        self.tableView.reloadData()
      })
    })
    } catch {
      print("Error preparing DataSource for RecipesViewController")
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: IBAction
  @IBAction func searchBarButtonDidPress(sender: AnyObject) {
    self.performSegueWithIdentifier(RecipesSegue.RecipesSearch.rawValue, sender: self)
  }
  
  @IBAction func scopeSegmentedControlSelectionDidChange(sender: AnyObject) {
    switch(self.segmentedControl.selectedSegmentIndex) {
    case 0:
      self.recipes = fetchedRecipes
    case 1:
      self.recipes = fetchedRecipes?.filter {
        return $0.favorite!.boolValue
      }
    default:
      break
    }
    self.tableView.reloadData()
  }
  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
  // Get the new view controller using segue.destinationViewController.
  // Pass the selected object to the new view controller.
    if segue.identifier == RecipesSegue.RecipesSearch.rawValue {
      guard let recipesSearchViewController = (segue.destinationViewController as? UINavigationController)?.viewControllers.first as? RecipesSearchViewController else {
        return
      }
      recipesSearchViewController.recipes = self.recipes
    } else if segue.identifier == RecipesSegue.RecipeModifier.rawValue {
      guard let recipesModifierViewController = (segue.destinationViewController as? UINavigationController)?.viewControllers.first as? RecipeModifierViewController else {
        return
      }
      guard let indexPathforSelectedRow = self.tableView.indexPathForSelectedRow else {
        return
      }
      let recipe = self.recipes![indexPathforSelectedRow.row]
      recipesModifierViewController.recipe = recipe
    }
  }
}
