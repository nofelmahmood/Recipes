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
    if tabBarController!.selectedIndex == RecipesScope.All {
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
    collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    let collectionViewLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
    collectionViewLayout.itemSize = CGSize(width: collectionView.frame.width, height: 289.0)
    collectionViewLayout.invalidateLayout()
    interactivePopTransition = UIPercentDrivenInteractiveTransition()
    navigationController?.delegate = self
    tabBarFrame = tabBarController!.tabBar.frame
    toRecipesSearchViewControllerTransition = RecipesToRecipesSearchAnimationController()
    toRecipeDetailViewControllerTransition = RecipesToRecipeDetailViewAnimationController()
    prepareDataSource()
    collectionView.reloadData()
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    UIApplication.sharedApplication().statusBarHidden = false
    tabBarController!.tabBar.frame = tabBarFrame
    tabBarController!.tabBar.hidden = false
    navigationController?.navigationBar.setBackgroundImage(nil, forBarMetrics: .Default)
    navigationController?.navigationBar.shadowImage = nil
    let btn = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
    navigationController?.navigationBar.topItem?.backBarButtonItem=btn
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    navigationController?.hidesBarsOnSwipe = true
    if firstTime {
      firstTime = false
      if recipesScope == RecipesScope.Favorites {
        navigationBarTitleButton.setTitle("Favorites", forState: .Normal)
        navigationBarTitleButton.userInteractionEnabled = false
        navigationBarTitleButton.setImage(nil, forState: .Normal)
      }
    }
    if recipesScope == RecipesScope.Favorites {
      recipes = fetchedRecipes.filter({ recipe in
        guard let favorite = recipe.favorite else {
          return false
        }
        return favorite
      })
    }
    prepareDataSource()
    collectionView.performBatchUpdates({
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
      recipes = allRecipes
      if recipesScope == RecipesScope.Favorites {
        recipes = fetchedRecipes.filter({ recipe in
          guard let favorite = recipe.favorite else {
            return false
          }
          return favorite
        })
      }
      fetchedRecipes = allRecipes
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
    if recipesScope == RecipesScope.All {
      if recipesFilter == RecipesFilter.ShowAll {
        recipes = fetchedRecipes
      } else {
        recipes = fetchedRecipes.filter({
          return $0.difficulty == recipesFilter
        })
      }
    }
    collectionView.performBatchUpdates({
      self.collectionView.reloadSections(NSIndexSet(index: 0))
      }, completion: nil)
  }
  
  // MARK: NSUserActivity
  func handleUserActivityWithRecipeID(recipeID: Int32) {
    if let recipe = recipes.filter({
      if let id = $0.id?.intValue {
        return recipeID == id
      }
      return false }).first {
        if let index = recipes.indexOf(recipe) {
          collectionView.selectItemAtIndexPath(NSIndexPath(forItem: index, inSection: 0), animated: false, scrollPosition: UICollectionViewScrollPosition.None)
          performSegueWithIdentifier(RecipesListViewControllerSegue.RecipeDetailViewController, sender: self)
        }
    }
  }
  // MARK: Trait Collection
  override func traitCollectionDidChange(previousTraitCollection: UITraitCollection?) {
    let collectionViewLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
    collectionViewLayout.itemSize = CGSize(width: collectionView.frame.width, height: 289.0)
    collectionViewLayout.invalidateLayout()
  }

  // MARK: Status Bar
  override func prefersStatusBarHidden() -> Bool {
    return false
  }
  
  // MARK: IBAction
  @IBAction func searchBarItemDidPress(sender: AnyObject) {
    performSegueWithIdentifier(RecipesListViewControllerSegue.RecipesSearchViewController, sender: self)
  }
  
  @IBAction func filterBarItemDidPress(sender: AnyObject) {
    performSegueWithIdentifier(RecipesListViewControllerSegue.RecipesFilterViewController, sender: self)
  }
  
  @IBAction func addBarItemDidPress(sender: AnyObject) {
    segueToRecipeDetailForNewRecipe = true
    performSegueWithIdentifier(RecipesListViewControllerSegue.RecipeDetailViewController, sender: self)
  }
  
  // MARK: - Navigation
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == RecipesListViewControllerSegue.RecipeDetailViewController {
      if let recipeDetailViewController = segue.destinationViewController as? RecipeDetailViewController {
        recipeDetailViewController.recipes = recipes
        recipeDetailViewController.selectedRecipeIndex = 0
        if segueToRecipeDetailForNewRecipe {
          segueToRecipeDetailForNewRecipe = false
          recipeDetailViewController.displayedForCreatingRecipe = true
        } else {
          recipeDetailViewController.selectedRecipeIndex = (collectionView.indexPathsForSelectedItems()!.first)!.row
          recipeDetailViewController.displayedForCreatingRecipe = false
        }
      }
    } else if segue.identifier == RecipesListViewControllerSegue.RecipesSearchViewController {
      if let recipesSearchViewController = (segue.destinationViewController as? UINavigationController)?.topViewController as? RecipesSearchViewController {
        recipesSearchViewController.recipes = fetchedRecipes
        recipesSearchViewController.navigationController?.transitioningDelegate = self
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0)
        view.drawViewHierarchyInRect(view.bounds, afterScreenUpdates: false)
        let snapshotImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        recipesSearchViewController.imageToBlur = snapshotImage
      }
    } else if segue.identifier == RecipesListViewControllerSegue.RecipesFilterViewController {
      let destinationController = segue.destinationViewController as? RecipesFilterViewController
      destinationController?.selectedFilter = recipesFilter
      destinationController?.popoverPresentationController?.delegate  = self
      destinationController?.preferredContentSize = CGSize(width: 200.0, height: 220.0)
      destinationController?.popoverPresentationController?.sourceRect = CGRect(x: (navigationBarTitleButton.frame.size.width/2) - 60, y: navigationBarTitleButton.frame.origin.y, width: navigationBarTitleButton.frame.size.width, height: navigationBarTitleButton.frame.size.height)
      destinationController?.delegate = self
    }
  }
}
