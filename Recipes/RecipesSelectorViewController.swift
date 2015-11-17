//
//  RecipeSelectorViewController.swift
//  Recipes
//
//  Created by Nofel Mahmood on 15/10/2015.
//  Copyright © 2015 Hyper. All rights reserved.
//

import UIKit

class RecipesSelectorViewController: UIViewController {
  @IBOutlet var collectionView: UICollectionView!
  var selectedItemIndexPath: NSIndexPath!
  
  var recipes: [RecipeViewModel] {
    return (parentViewController as! RecipeDetailViewController).recipes
  }
  var recipeDetailViewController: RecipeDetailViewController {
    return parentViewController as! RecipeDetailViewController
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    collectionView.reloadData()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func prefersStatusBarHidden() -> Bool {
    return true
  }

  // MARK: - Navigation
}
