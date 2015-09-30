//
//  RecipesListViewController.swift
//  Recipes
//
//  Created by Nofel Mahmood on 29/09/2015.
//  Copyright © 2015 Hyper. All rights reserved.
//

import UIKit

class RecipesListViewController: UIViewController {
  @IBOutlet var collectionView: UICollectionView!
  @IBOutlet var scopeSelectorSegmentedControl: UISegmentedControl!
  
  var recipes: [RecipeViewModel] = [RecipeViewModel]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    self.prepareDataSource()
    self.collectionView.reloadData()
  }
  
  func prepareDataSource() {
    if let allRecipes = Recipe.allForView(inContext: CoreDataStack.defaultStack.managedObjectContext) {
      self.recipes = allRecipes
    }
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
