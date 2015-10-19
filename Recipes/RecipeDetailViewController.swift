//
//  RecipeDetailViewController.swift
//  Recipes
//
//  Created by Nofel Mahmood on 12/10/2015.
//  Copyright © 2015 Hyper. All rights reserved.
//

import UIKit

extension RecipeDetailViewController: UICollectionViewDataSource {
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.recipes.count
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("RecipeDetailCollectionViewCell", forIndexPath: indexPath) as? RecipeDetailCollectionViewCell {
      let recipe = self.recipes[indexPath.row]
      cell.configureCellWithRecipe(recipe)
      recipe.photo({ image in
        if let image = image {
          NSOperationQueue.mainQueue().addOperationWithBlock({
            if let correspondingCell = self.collectionView.cellForItemAtIndexPath(NSIndexPath(forItem: indexPath.row, inSection: 0)) as? RecipeDetailCollectionViewCell {
              correspondingCell.photoImageView.image = image
              correspondingCell.backgroundImageView.image = image
            }
          })
        }
      })
      cell.scrollViewDidScroll = ({ contentOffset in
        if contentOffset.y >= (cell.photoImageView.frame.size.height - self.navigationController!.navigationBar.frame.size.height - UIApplication.sharedApplication().statusBarFrame.size.height) {
          self.setNavigationBarTransparent(false)
          if contentOffset.y >= cell.descriptionTextView.frame.origin.y - UIApplication.sharedApplication().statusBarFrame.size.height - self.navigationController!.navigationBar.frame.size.height {
            self.navigationItem.title = cell.nameTextField.text
          } else {
            self.navigationItem.title = ""
          }
        } else {
          self.setNavigationBarTransparent(true)
        }
      })
      return cell
    }
    return UICollectionViewCell()
  }
}

extension RecipeDetailViewController: UIScrollViewDelegate {
  func scrollViewDidScroll(scrollView: UIScrollView) {
    if let visibleItemIndexPath = self.collectionView.indexPathsForVisibleItems().first {
      if let previousSelectedIndexPath = self.recipesSelectorViewController?.collectionView.indexPathsForVisibleItems().first {
        self.recipesSelectorViewController?.collectionView.deselectItemAtIndexPath(previousSelectedIndexPath, animated: false)
      }
      self.recipesSelectorViewController?.collectionView.selectItemAtIndexPath(visibleItemIndexPath, animated: true, scrollPosition: UICollectionViewScrollPosition.CenteredHorizontally)
    }
  }
}

extension RecipeDetailViewController: UICollectionViewDelegate {
  func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
    self.setNavigationBarTransparent(true)
    self.navigationItem.title = ""
  }
}

class RecipeDetailViewController: UIViewController {
  
  @IBOutlet var collectionView: UICollectionView!
  @IBOutlet var containerView: UIView!
  
  var selectedRecipeIndex: Int!
  var recipes: [RecipeViewModel]!
  var recipesSelectorViewController: RecipesSelectorViewController? {
    for viewController in self.childViewControllers {
      if viewController is RecipesSelectorViewController {
        return viewController as? RecipesSelectorViewController
      }
    }
    return nil
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    self.tabBarController?.tabBar.hidden = true
    self.tabBarController?.tabBar.frame = CGRectZero
    let containerViewBottomConstraint = NSLayoutConstraint(item: self.containerView, attribute: .Bottom, relatedBy: .Equal, toItem: self.view, attribute: .Bottom, multiplier: 1.0, constant: 0.0)
    self.view.addConstraint(containerViewBottomConstraint)
    let containerViewHeightConstraint = NSLayoutConstraint(item: self.containerView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 50.0)
    self.view.addConstraint(containerViewHeightConstraint)
    self.view.layoutIfNeeded()
    self.setNavigationBarTransparent(true)
    self.collectionView.pagingEnabled = true
    (self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout).itemSize = CGSize(width: self.view.frame.size.width, height: self.collectionView.frame.size.height)
    self.collectionView.reloadData()
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    UIApplication.sharedApplication().statusBarHidden = true
    self.collectionView.layoutIfNeeded()
    let indexPath = NSIndexPath(forItem: self.selectedRecipeIndex, inSection: 0)
    self.collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: UICollectionViewScrollPosition.CenteredHorizontally, animated: false)    
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    self.navigationController?.hidesBarsOnSwipe = false
    self.navigationController?.setNavigationBarHidden(false, animated: false)
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
  }
  
  func setNavigationBarTransparent(transparent: Bool) {
    if transparent {
      if navigationController!.navigationBar.backgroundImageForBarMetrics(UIBarMetrics.Default) != nil {
        return
      }
      UIView.animateWithDuration(0.2, animations: {
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        if let leftBarButtons = self.navigationItem.leftBarButtonItems {
          for barButton in leftBarButtons {
            barButton.tintColor = UIColor.whiteColor()
          }
        }
        if let rightBarButtons = self.navigationItem.rightBarButtonItems {
          for barButton in rightBarButtons {
            barButton.tintColor = UIColor.whiteColor()
          }
        }
        }, completion: { completed in
          self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
          self.navigationController?.navigationBar.shadowImage = UIImage()
      })
    } else {
      if navigationController!.navigationBar.backgroundImageForBarMetrics(UIBarMetrics.Default) == nil {
        return
      }
      UIView.animateWithDuration(0.2, animations: {
        self.navigationController?.navigationBar.tintColor = UIColor.appKeyColor()
        if let leftBarButtons = self.navigationItem.leftBarButtonItems {
          for barButton in leftBarButtons {
            barButton.tintColor = UIColor.appKeyColor()
          }
        }
        if let rightBarButtons = self.navigationItem.rightBarButtonItems {
          for barButton in rightBarButtons {
            barButton.tintColor = UIColor.appKeyColor()
          }
        }
        }, completion: { completed in
          self.navigationController?.navigationBar.setBackgroundImage(nil, forBarMetrics: .Default)
          self.navigationController?.navigationBar.shadowImage = nil
      })
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: Status Bar
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
