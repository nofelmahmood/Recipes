//
//  RecipesListViewController.swift
//  Recipes
//
//  Created by Nofel Mahmood on 29/09/2015.
//  Copyright © 2015 Hyper. All rights reserved.
//

import UIKit

struct RecipesScope {
  static let All = 0
  static let Favorites = 1
}

struct RecipesFilter {
  static let Easy = RecipeDifficulty.Easy
  static let Medium = RecipeDifficulty.Medium
  static let Hard = RecipeDifficulty.Hard
  static let ShowAll = "Show All"
}

struct RecipesListViewControllerSegue {
  static let RecipesSearchViewController = "RecipesSearchViewController"
  static let RecipesFilterViewController = "RecipesFilterViewController"
  static let RecipeDetailViewController = "RecipeDetailViewController"
}

class RecipesListViewController: UIViewController {
  @IBOutlet var collectionView: UICollectionView!
  @IBOutlet var navigationBarTitleButton: UIButton!
  @IBOutlet var navigationBarFilterNameLabel: UILabel!
  
  var toRecipesSearchViewControllerTransition: RecipesToRecipesSearchAnimationController!
  var toRecipeDetailViewControllerTransition: RecipesToRecipeDetailViewAnimationController!
  var interactivePopTransition: UIPercentDrivenInteractiveTransition!
  var recipesFilter = RecipesFilter.ShowAll
  var recipes: [RecipeViewModel] = [RecipeViewModel]()
  var fetchedRecipes: [RecipeViewModel] = [RecipeViewModel]()
  
  var tabBarFrame : CGRect!
  
  var recipesScope: Int {
    if self.tabBarController!.selectedIndex == RecipesScope.All {
      return RecipesScope.All
    } else {
      return RecipesScope.Favorites
    }
  }
  var firstTime = true
  var segueToRecipeDetailForNewRecipe = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    self.interactivePopTransition = UIPercentDrivenInteractiveTransition()
    self.navigationController?.delegate = self
    self.tabBarFrame = self.tabBarController!.tabBar.frame
    self.toRecipesSearchViewControllerTransition = RecipesToRecipesSearchAnimationController()
    self.toRecipeDetailViewControllerTransition = RecipesToRecipeDetailViewAnimationController()
    self.prepareDataSource()
    self.collectionView.reloadData()
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    UIApplication.sharedApplication().statusBarHidden = false
    self.tabBarController!.tabBar.frame = self.tabBarFrame
    self.tabBarController!.tabBar.hidden = false
    self.navigationController?.navigationBar.setBackgroundImage(nil, forBarMetrics: .Default)
    self.navigationController?.navigationBar.shadowImage = nil
    let btn = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
    self.navigationController?.navigationBar.topItem?.backBarButtonItem=btn
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    self.navigationController?.hidesBarsOnSwipe = true
    if self.firstTime {
      self.firstTime = false
      if self.recipesScope == RecipesScope.Favorites {
        self.navigationBarTitleButton.setTitle("Favorites", forState: .Normal)
        self.navigationBarTitleButton.userInteractionEnabled = false
        self.navigationBarTitleButton.setImage(nil, forState: .Normal)
      }
    }
    if self.recipesScope == RecipesScope.Favorites {
      self.recipes = self.fetchedRecipes.filter({ recipe in
        guard let favorite = recipe.favorite else {
          return false
        }
        return favorite
      })
    }
    self.prepareDataSource()
    self.collectionView.performBatchUpdates({
      self.collectionView.reloadSections(NSIndexSet(index: 0))
      }, completion: nil)
    
    SyncManager.sharedManager.perform({
      NSOperationQueue.mainQueue().addOperationWithBlock({
        CoreDataStack.defaultStack.saveContext()
        self.prepareDataSource()
        self.collectionView.performBatchUpdates({
          self.collectionView.reloadSections(NSIndexSet(index: 0))
          }, completion: nil)
      })
    })
  }
  
  func prepareDataSource() {
    if let allRecipes = Recipe.allForView(inContext: CoreDataStack.defaultStack.managedObjectContext) {
      self.recipes = allRecipes
      if self.recipesScope == RecipesScope.Favorites {
        self.recipes = self.fetchedRecipes.filter({ recipe in
          guard let favorite = recipe.favorite else {
            return false
          }
          return favorite
        })
      }
      self.fetchedRecipes = allRecipes
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func recipeFilterFromRecipeDifficulty(difficulty: String) -> String {
    switch(difficulty) {
    case RecipeDifficulty.Easy:
      return RecipesFilter.Easy
    case RecipeDifficulty.Medium:
      return RecipesFilter.Medium
    case RecipeDifficulty.Hard:
      return RecipesFilter.Hard
    default:
      return RecipesFilter.ShowAll
    }
  }
  
  func reloadCollectionViewDataWithNewData() {
    if self.recipesScope == RecipesScope.All {
      if self.recipesFilter == RecipesFilter.ShowAll {
        self.recipes = self.fetchedRecipes
      } else {
        self.recipes = self.fetchedRecipes.filter({
          return $0.difficulty == self.recipesFilter
        })
      }
    }
    self.collectionView.performBatchUpdates({
      self.collectionView.reloadSections(NSIndexSet(index: 0))
      }, completion: nil)
  }
  
  // MARK: NSUserActivity
  func handleUserActivityWithRecipeID(recipeID: Int32) {
    if let recipe = self.recipes.filter({
      if let id = $0.id?.intValue {
        return recipeID == id
      }
      return false }).first {
        if let index = self.recipes.indexOf(recipe) {
          self.collectionView.selectItemAtIndexPath(NSIndexPath(forItem: index, inSection: 0), animated: false, scrollPosition: UICollectionViewScrollPosition.None)
          self.performSegueWithIdentifier(RecipesListViewControllerSegue.RecipeDetailViewController, sender: self)
        }
    }
  }
  
  // MARK: Status Bar
  override func prefersStatusBarHidden() -> Bool {
    return false
  }
  
  // MARK: IBAction
  @IBAction func searchBarItemDidPress(sender: AnyObject) {
    self.performSegueWithIdentifier(RecipesListViewControllerSegue.RecipesSearchViewController, sender: self)
  }
  
  @IBAction func filterBarItemDidPress(sender: AnyObject) {
    self.performSegueWithIdentifier(RecipesListViewControllerSegue.RecipesFilterViewController, sender: self)
  }
  
  @IBAction func addBarItemDidPress(sender: AnyObject) {
    self.segueToRecipeDetailForNewRecipe = true
    self.performSegueWithIdentifier(RecipesListViewControllerSegue.RecipeDetailViewController, sender: self)
  }
  
  // MARK: - Navigation
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    if segue.identifier == RecipesListViewControllerSegue.RecipeDetailViewController {
      if let recipeDetailViewController = segue.destinationViewController as? RecipeDetailViewController {
        recipeDetailViewController.recipes = self.recipes
        recipeDetailViewController.selectedRecipeIndex = 0
        if self.segueToRecipeDetailForNewRecipe {
          self.segueToRecipeDetailForNewRecipe = false
          recipeDetailViewController.displayedForCreatingRecipe = true
        } else {
          recipeDetailViewController.selectedRecipeIndex = (self.collectionView.indexPathsForSelectedItems()!.first)!.row
          recipeDetailViewController.displayedForCreatingRecipe = false
        }
      }
    } else if segue.identifier == RecipesListViewControllerSegue.RecipesSearchViewController {
      if let recipesSearchViewController = (segue.destinationViewController as? UINavigationController)?.topViewController as? RecipesSearchViewController {
        recipesSearchViewController.recipes = self.fetchedRecipes
        recipesSearchViewController.navigationController?.transitioningDelegate = self
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0)
        view.drawViewHierarchyInRect(self.view.bounds, afterScreenUpdates: false)
        let snapshotImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        recipesSearchViewController.imageToBlur = snapshotImage
      }
    } else if segue.identifier == RecipesListViewControllerSegue.RecipesFilterViewController {
      let destinationController = segue.destinationViewController as? RecipesFilterViewController
      destinationController?.selectedFilter = self.recipesFilter
      destinationController?.popoverPresentationController?.delegate  = self
      destinationController?.preferredContentSize = CGSize(width: 200.0, height: 220.0)
      destinationController?.popoverPresentationController?.sourceRect = CGRect(x: (self.navigationBarTitleButton.frame.size.width/2) - 60, y: self.navigationBarTitleButton.frame.origin.y, width: self.navigationBarTitleButton.frame.size.width, height: self.navigationBarTitleButton.frame.size.height)
      destinationController?.delegate = self
    }
  }
}
