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

enum RecipesScope: String {
  case All = "All"
  case Favories = "Favorites"
}

// MARK: UITableViewDataSource
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
    cell.updateCellFromRecipe(recipe, scope: self.selectedScope())
    if let image = self.cachedImages[recipe.id!.intValue] {
      cell.backgroundImageView.image = image
    } else {
      cell.backgroundImageView.image = UIImage(named: "ImagePlaceholder")
      if let photoURLString = recipe.photo?.thumbnailURL {
        if let photoURL = NSURL(string: photoURLString) {
          let photoURLRequest = NSURLRequest(URL: photoURL)
          let photoDownloadTask = NSURLSession.sharedSession().downloadTaskWithRequest(photoURLRequest, completionHandler: { (location, response, error) -> Void in
            guard let location = location else {
              return
            }
            let photoData = NSData(contentsOfURL: location)
            if let photoData = photoData {
              recipe.photo?.data = photoData
              self.cachedImages[recipe.id!.intValue] = UIImage(data: photoData)
              if (tableView.cellForRowAtIndexPath(indexPath) as? RecipeTableViewCell)?.recipe == recipe {
                NSOperationQueue.mainQueue().addOperationWithBlock {
                  self.tableView.beginUpdates()
                  self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
                  self.tableView.endUpdates()
                }
              }
            }
          })
          photoDownloadTask.resume()
        }
      }
    }
    return cell
  }
}

// MARK: UITableViewDelegate
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
  
  func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == UITableViewCellEditingStyle.Delete {
      guard let recipe = self.recipes?[indexPath.row] else {
        return
      }
      CoreDataStack.defaultStack.managedObjectContext.deleteObject(recipe)
      let checkTryIt = try? CoreDataStack.defaultStack.managedObjectContext.save()
//      do {
//        try self.prepareDataSource {
//          NSOperationQueue.mainQueue().addOperationWithBlock {
//            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
//          }
//        }
//      } catch {
//        print("Error preparing DataSource")
//      }
    }
  }
}


class RecipesViewController: UIViewController {
  
  @IBOutlet var tableView: UITableView!
  @IBOutlet var segmentedControl: UISegmentedControl!
  
  var recipes: [Recipe]?
  var fetchedRecipes: [Recipe]?
  var cachedImages = [Int32: UIImage]()
  
  func prepareDataSource(completionBlock: (() -> Void)?) throws {
    let fetchRequest = NSFetchRequest(entityName: RecipeEntityName)
    let asynchronousFetchRequest = NSAsynchronousFetchRequest(fetchRequest: fetchRequest) { (result) -> Void in
      if let finalResult = result.finalResult as? [Recipe] {
        self.fetchedRecipes = finalResult
        self.loadRecipesForSelectedScope()
      }
      completionBlock?()
    }
    try CoreDataStack.defaultStack.managedObjectContext.executeRequest(asynchronousFetchRequest)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
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
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "saveNotification:", name: RecipeStoreDidSaveSuccessfulNotification, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "saveNotification:", name: RecipeStoreDidSaveUnSuccessfulNotification, object: nil)
  }
  
  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    NSNotificationCenter.defaultCenter().removeObserver(self, name: RecipeStoreDidSaveSuccessfulNotification, object: nil)
    NSNotificationCenter.defaultCenter().removeObserver(self, name: RecipeStoreDidSaveUnSuccessfulNotification, object: nil)
  }
  
  func saveNotification(notification: NSNotification) {
    if notification.name == RecipeStoreDidSaveSuccessfulNotification {
      _ = try? self.prepareDataSource(nil)
    } else {
      
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: Recipes Scope
  func selectedScope() -> RecipesScope {
    switch(self.segmentedControl.selectedSegmentIndex) {
    case 1:
      return RecipesScope.Favories
    default:
      return RecipesScope.All
    }
  }
  
  func loadRecipesForSelectedScope() {
    switch(self.segmentedControl.selectedSegmentIndex) {
    case 1:
      self.recipes = fetchedRecipes?.filter {
        if let favorite = $0.favorite?.boolValue {
          return favorite
        }
        return false
      }
    default:
      self.recipes = fetchedRecipes
    }
  }
  
  // MARK: IBAction
  @IBAction func addBarButtonDidPress(sender: AnyObject) {
    self.performSegueWithIdentifier(RecipesSegue.RecipeModifier.rawValue, sender: sender)
  }
  
  @IBAction func searchBarButtonDidPress(sender: AnyObject) {
    self.performSegueWithIdentifier(RecipesSegue.RecipesSearch.rawValue, sender: self)
  }
  
  @IBAction func scopeSegmentedControlSelectionDidChange(sender: AnyObject) {
    self.loadRecipesForSelectedScope()
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
      if sender is UIBarButtonItem {
        let recipe = NSEntityDescription.insertNewObjectForEntityForName("Recipe", inManagedObjectContext: CoreDataStack.defaultStack.managedObjectContext) as? Recipe
        recipesModifierViewController.recipe = recipe
        recipesModifierViewController.isNewRecipe = true
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
