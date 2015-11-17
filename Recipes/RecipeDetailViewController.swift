//
//  RecipeDetailViewController.swift
//  Recipes
//
//  Created by Nofel Mahmood on 12/10/2015.
//  Copyright © 2015 Hyper. All rights reserved.
//

import UIKit

class RecipeDetailViewController: UIViewController {
  
  @IBOutlet var collectionView: UICollectionView!
  @IBOutlet var containerView: UIView!
  @IBOutlet var containerViewHeightConstraint: NSLayoutConstraint!
  @IBOutlet var deleteBarButtonItem: UIBarButtonItem!
  @IBOutlet var editBarButtonItem: UIBarButtonItem!
  
  var selectedRecipeIndex: Int!
  var displayedForCreatingRecipe = false
  var recipes: [RecipeViewModel]!
  var recipesSelectorViewController: RecipesSelectorViewController? {
    for viewController in childViewControllers {
      if viewController is RecipesSelectorViewController {
        return viewController as? RecipesSelectorViewController
      }
    }
    return nil
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    let popRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: "handlePopRecognizer:")
    popRecognizer.edges = UIRectEdge.Top
    view.addGestureRecognizer(popRecognizer)
    tabBarController?.tabBar.hidden = true
    tabBarController?.tabBar.frame = CGRectZero
    view.layoutIfNeeded()
    setNavigationBarTransparent(true)
    collectionView.pagingEnabled = true
    (collectionView.collectionViewLayout as! UICollectionViewFlowLayout).itemSize = CGSize(width: view.frame.size.width, height: collectionView.frame.size.height)
    collectionView.reloadData()
  }
  
  func handlePopRecognizer(recognizer: UIScreenEdgePanGestureRecognizer) {
    
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    UIApplication.sharedApplication().statusBarHidden = true
    collectionView.layoutIfNeeded()
    if !displayedForCreatingRecipe {
      let indexPath = NSIndexPath(forItem: selectedRecipeIndex, inSection: 0)
      collectionView.selectItemAtIndexPath(indexPath, animated: true, scrollPosition: UICollectionViewScrollPosition.CenteredHorizontally)
      recipesSelectorViewController?.collectionView.selectItemAtIndexPath(NSIndexPath(forItem: indexPath.row + 1, inSection: 0), animated: true, scrollPosition: UICollectionViewScrollPosition.CenteredHorizontally)
    }
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    navigationController?.hidesBarsOnSwipe = false
    navigationController?.setNavigationBarHidden(false, animated: false)
  }
  
  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
    NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
  }
  
  func visibleRecipeCell() -> RecipeDetailCollectionViewCell {
    return collectionView.visibleCells().first as! RecipeDetailCollectionViewCell
  }
  
  func keyboardWillShow(notification: NSNotification) {
    guard let userInfo = notification.userInfo else {
      return
    }
    var keyboardFrame = userInfo["UIKeyboardFrameEndUserInfoKey"]!.CGRectValue
    let cell = visibleRecipeCell()
    keyboardFrame = cell.scrollView.convertRect(keyboardFrame, fromView: nil)
    let intersect = CGRectIntersection(keyboardFrame, cell.scrollView.bounds)
    if !CGRectIsNull(intersect) {
      let duration = userInfo["UIKeyboardAnimationDurationUserInfoKey"]!.doubleValue
      UIView.animateWithDuration(duration, animations: { () -> Void in
        cell.scrollView.contentInset = UIEdgeInsetsMake(0, 0, intersect.size.height, 0)
        cell.scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, intersect.size.height, 0)
      })
    }
  }
  
  func keyboardWillHide(notification: NSNotification) {
    guard let userInfo = notification.userInfo else {
      return
    }
    let duration = userInfo["UIKeyboardAnimationDurationUserInfoKey"]!.doubleValue
    let cell = visibleRecipeCell()
    UIView.animateWithDuration(duration) { () -> Void in
      cell.scrollView.contentInset = UIEdgeInsetsZero
      cell.scrollView.scrollIndicatorInsets = UIEdgeInsetsZero
    }
  }
  
  func setNavigationBarTransparent(transparent: Bool) {
    if transparent {
      if navigationController?.navigationBar.backgroundImageForBarMetrics(UIBarMetrics.Default) != nil {
        return
      }
      UIView.animateWithDuration(0.2, animations: {
        self.navigationController?.navigationBar.tintColor = UIColor.darkGrayColor()
        if let leftBarButtons = self.navigationItem.leftBarButtonItems {
          for barButton in leftBarButtons {
            barButton.tintColor = UIColor.darkGrayColor()
          }
        }
        if let rightBarButtons = self.navigationItem.rightBarButtonItems {
          for barButton in rightBarButtons {
            barButton.tintColor = UIColor.darkGrayColor()
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
  
  override func setEditing(editing: Bool, animated: Bool) {
    super.setEditing(editing, animated: animated)
    if editing {
      navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "doneButtonDidPress:")
      navigationItem.rightBarButtonItems?.removeLast()
      navigationItem.setHidesBackButton(true, animated: true)
      collectionView.scrollEnabled = false
      containerViewHeightConstraint.constant = 0
      visibleRecipeCell().scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
      UIView.animateWithDuration(0.3, animations: {
        self.view.layoutIfNeeded()
        }, completion: { completed in
          self.visibleRecipeCell().scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: self.containerViewHeightConstraint.constant, right: 0)
          self.visibleRecipeCell().editing = true
      })
    } else {
      navigationItem.rightBarButtonItem = editBarButtonItem
      navigationItem.rightBarButtonItems?.append(deleteBarButtonItem)
      navigationItem.setHidesBackButton(false, animated: true)
      collectionView.scrollEnabled = true
      containerViewHeightConstraint.constant = 44.0
      UIView.animateWithDuration(0.3, animations: {
        self.view.layoutIfNeeded()
        }, completion: { completed in
          self.visibleRecipeCell().scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: self.containerViewHeightConstraint.constant, right: 0)
          self.visibleRecipeCell().editing = false
      })
    }
    if let cell = collectionView.visibleCells().first as? RecipeDetailCollectionViewCell {
      cell.editing = editing
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func showAlertControllerForSelectingPhoto() {
    let alertController = UIAlertController(title: "Recipe Photo", message: "a picture is worth a thousand words !", preferredStyle: UIAlertControllerStyle.ActionSheet)
    let photoAlbumAlertAction = UIAlertAction(title: "Photo Library", style: UIAlertActionStyle.Default, handler: { alertAction in
      self.showImagePicker(UIImagePickerControllerSourceType.PhotoLibrary)
    })
    let cameraAlertAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default, handler: { alertAction in
      self.showImagePicker(UIImagePickerControllerSourceType.Camera)
    })
    let cancelAlertAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
    alertController.addAction(cameraAlertAction)
    alertController.addAction(photoAlbumAlertAction)
    alertController.addAction(cancelAlertAction)
    presentViewController(alertController, animated: true, completion: nil)
  }
  
  func showImagePicker(sourceType: UIImagePickerControllerSourceType) {
    if UIImagePickerController.isSourceTypeAvailable(sourceType) {
      let imagePickerController = UIImagePickerController()
      imagePickerController.delegate = self
      imagePickerController.sourceType = sourceType
      presentViewController(imagePickerController, animated: true, completion: nil)
    }
  }
  
  // MARK: IBAction
  @IBAction func editButtonDidPress(sender: AnyObject) {
    setEditing(true, animated: true)
  }
  
  @IBAction func deleteButtonDidPress(sender: AnyObject) {
    if let visibleItemIndexPath = collectionView.indexPathsForVisibleItems().first {
      let recipe = recipes[visibleItemIndexPath.row]
      let alertController = UIAlertController(title: "Delete \"\(recipe.name)\"", message: "Are you sure ?", preferredStyle: UIAlertControllerStyle.ActionSheet)
      let yesAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.Destructive, handler: { alertAction in
        recipe.deleteUnderlyingRecipe()
        CoreDataStack.defaultStack.saveContext()
        if let index = self.recipes.indexOf(recipe) {
          self.recipes.removeAtIndex(index)
          self.collectionView.performBatchUpdates({
            self.collectionView.deleteItemsAtIndexPaths([visibleItemIndexPath])
            self.recipesSelectorViewController?.collectionView.performBatchUpdates({
              self.recipesSelectorViewController?.collectionView.deleteItemsAtIndexPaths([NSIndexPath(forItem: visibleItemIndexPath.row + 1, inSection: 0)])
              }, completion: nil)
            }, completion: nil)
        }
      })
      let noAction = UIAlertAction(title: "No", style: UIAlertActionStyle.Cancel, handler: nil)
      alertController.addAction(yesAction)
      alertController.addAction(noAction)
      presentViewController(alertController, animated: true, completion: nil)
    }
  }
  
  @IBAction func doneButtonDidPress(sender: AnyObject) {
    setEditing(false, animated: true)
    CoreDataStack.defaultStack.saveContext()
  }
  
  // MARK: Status Bar
  override func prefersStatusBarHidden() -> Bool {
    return true
  }  
}
