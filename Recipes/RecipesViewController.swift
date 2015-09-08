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
      if let photoURLString = recipe.photoThumbnailURL {
        if let photoURL = NSURL(string: photoURLString) {
          let photoURLRequest = NSURLRequest(URL: photoURL)
          let photoDownloadTask = NSURLSession.sharedSession().downloadTaskWithRequest(photoURLRequest, completionHandler: { (location, response, error) -> Void in
            guard let location = location else {
              return
            }
            let photoData = NSData(contentsOfURL: location)
            if let photoData = photoData {
              recipe.photoData = photoData
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
      recipe.deleteFromRemote { successful in
        if successful {
          NSOperationQueue.mainQueue().addOperationWithBlock {
            self.recipes?.removeAtIndex(indexPath.row)
            self.fetchedRecipes?.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
          }
        } else {
          let alertController = UIAlertController(title: "Sorry", message: "We failed to delete the recipe from server. Please check your internet connection and try again !", preferredStyle: UIAlertControllerStyle.Alert)
          let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
          alertController.addAction(okAction)
          self.presentViewController(alertController, animated: true, completion: nil)
        }
      }
    }
  }
}

// MARK: -
class RecipesViewController: UIViewController {
  
  @IBOutlet var tableView: UITableView!
  @IBOutlet var segmentedControl: UISegmentedControl!
  @IBOutlet var errorMessageView: UIView!

  var refreshControl: UIRefreshControl!
  var activityIndicatorView: UIActivityIndicatorView!
  
  var recipes: [Recipe]?
  var fetchedRecipes: [Recipe]?
  var cachedImages = [Int32: UIImage]()
  
  func prepareDataSource(completionBlock: ((successful: Bool)->())?)  {
    RecipeApi.sharedAPI.recipes { (recipes: [Recipe]?) -> () in
      if let recipes = recipes {
        self.fetchedRecipes = recipes
        completionBlock?(successful: true)
      } else {
        self.fetchedRecipes = nil
        completionBlock?(successful: false)
      }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    self.activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
    self.activityIndicatorView.color = AppColorList.keyColor
    let frame = self.activityIndicatorView.frame
    self.activityIndicatorView.frame.origin.x = self.view.frame.size.width / 2 - frame.size.width / 2
    self.activityIndicatorView.frame.origin.y = self.view.frame.size.height / 2 - frame.size.height / 2
    self.tableView.addSubview(self.activityIndicatorView)
    AFNetworkReachabilityManager.sharedManager().setReachabilityStatusChangeBlock { (status: AFNetworkReachabilityStatus) -> Void in
      if status == AFNetworkReachabilityStatus.ReachableViaWiFi || status == AFNetworkReachabilityStatus.ReachableViaWWAN {
        NSOperationQueue.mainQueue().addOperationWithBlock {
          self.prepareDataSource({ (successful) -> () in
            if successful {
              NSOperationQueue.mainQueue().addOperationWithBlock {
                self.loadRecipesForSelectedScope()
                self.tableView.reloadData()
              }
            }
          })
          self.tableView.reloadData()
        }
      }
    }
    AFNetworkReachabilityManager.sharedManager().startMonitoring()
    self.refreshControl = UIRefreshControl()
    self.refreshControl.backgroundColor = UIColor.whiteColor()
    self.refreshControl.tintColor = AppColorList.keyColor
    self.refreshControl.addTarget(self, action: "didRefresh:", forControlEvents: UIControlEvents.ValueChanged)
    self.tableView.addSubview(self.refreshControl)
    self.tableView.delegate = self
    self.tableView.dataSource = self
  }

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
  }
  
  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    self.activityIndicatorView.startAnimating()
    self.prepareDataSource { (successful) -> () in
      NSOperationQueue.mainQueue().addOperationWithBlock {
        self.activityIndicatorView.stopAnimating()
      }
      if successful {
        NSOperationQueue.mainQueue().addOperationWithBlock {
          self.loadRecipesForSelectedScope()
          self.tableView.reloadData()
        }
      } else {
        self.tableView.backgroundView = self.errorMessageView
      }
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  func didRefresh(sender: AnyObject) {
    self.prepareDataSource { (successful) -> () in
      if successful {
        NSOperationQueue.mainQueue().addOperationWithBlock {
          self.loadRecipesForSelectedScope()
          self.tableView.reloadData()
          self.refreshControl.endRefreshing()
        }
      } else {
        NSOperationQueue.mainQueue().addOperationWithBlock {
          self.tableView.backgroundView = self.errorMessageView
        }
      }
    }
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
        if let favorite = $0.favorite {
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
      recipesSearchViewController.cachedImages = self.cachedImages
    } else if segue.identifier == RecipesSegue.RecipeModifier.rawValue {
      guard let recipesModifierViewController = (segue.destinationViewController as? UINavigationController)?.viewControllers.first as? RecipeModifierViewController else {
        return
      }
      if sender is UIBarButtonItem {
        let newRecipe = Recipe()
        recipesModifierViewController.recipe = newRecipe
        recipesModifierViewController.isNewRecipe = true
        return
      }
      guard let indexPathforSelectedRow = self.tableView.indexPathForSelectedRow else {
        return
      }
      let recipe = self.recipes![indexPathforSelectedRow.row]
      recipesModifierViewController.recipe = recipe
      if let id = recipe.id?.intValue {
        recipesModifierViewController.cachedImage = self.cachedImages[id]
      }
    }
  }
}
