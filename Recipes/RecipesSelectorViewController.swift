//
//  RecipeSelectorViewController.swift
//  Recipes
//
//  Created by Nofel Mahmood on 15/10/2015.
//  Copyright © 2015 Hyper. All rights reserved.
//

import UIKit

extension RecipesSelectorViewController: UICollectionViewDataSource {
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.recipes.count
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("RecipePhotoCollectionViewCell", forIndexPath: indexPath) as? RecipePhotoCollectionViewCell {
      let recipe = self.recipes[indexPath.row]
      cell.performSelection(cell.selected)
      recipe.photo({ image in
        if let image = image {
          NSOperationQueue.mainQueue().addOperationWithBlock({
            if let correspondingCell = self.collectionView.cellForItemAtIndexPath(NSIndexPath(forItem: indexPath.row, inSection: 0)) as? RecipePhotoCollectionViewCell {
              correspondingCell.photoImageView.image = image
            }
          })
        }
      })
      return cell
    }
    return UICollectionViewCell()
  }
}

//extension RecipesSelectorViewController: UICollectionViewDelegateFlowLayout {
//  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
//    if let selectedIndexPath = collectionView.indexPathsForSelectedItems()?.first where selectedIndexPath == indexPath {
//      return CGSize(width: 70.0, height: 50.0)
//    }
//    return CGSize(width: 50.0, height: 50.0)
//  }
//}

extension RecipesSelectorViewController: UICollectionViewDelegate {
  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    if let cell = collectionView.cellForItemAtIndexPath(indexPath) as? RecipePhotoCollectionViewCell {
      cell.performSelection(true)
    }
    self.recipeDetailViewController.collectionView.layoutIfNeeded()
    self.recipeDetailViewController.collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: UICollectionViewScrollPosition.CenteredHorizontally, animated: true)
  }
  
  func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
    if let cell = collectionView.cellForItemAtIndexPath(indexPath) as? RecipePhotoCollectionViewCell {
      cell.performSelection(false)
    }
  }
}

class RecipesSelectorViewController: UIViewController {
  @IBOutlet var collectionView: UICollectionView!
  
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
