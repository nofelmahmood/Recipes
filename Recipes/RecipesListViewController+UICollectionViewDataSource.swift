//
//  RecipesListViewController+UICollectionViewDataSource.swift
//  Recipes
//
//  Created by Nofel Mahmood on 29/09/2015.
//  Copyright © 2015 Hyper. All rights reserved.
//

import UIKit

let reuseIdentifier = "RecipeListCollectionViewCell"

extension RecipesListViewController: UICollectionViewDataSource {
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.recipes.count
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    if let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as? RecipeListCollectionViewCell {
      let recipe = self.recipes[indexPath.row]
      cell.configureUsingRecipe(recipe)
      return cell
    }
    return UICollectionViewCell()
  }
}