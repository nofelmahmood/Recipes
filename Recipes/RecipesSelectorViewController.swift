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
    return (self.parentViewController as! RecipeDetailViewController).recipes
  }
  var recipeDetailViewController: RecipeDetailViewController {
    return self.parentViewController as! RecipeDetailViewController
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    self.collectionView.reloadData()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func prefersStatusBarHidden() -> Bool {
    return true
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
