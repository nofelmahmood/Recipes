//
//  RecipeModifierViewController.swift
//  Recipes
//
//  Created by Nofel Mahmood on 31/08/2015.
//  Copyright © 2015 Hyper. All rights reserved.
//

import UIKit
import MobileCoreServices

let RecipePhotoTableViewCellIdentifier = "RecipePhotoTableViewCell"
let RecipeDescriptionTableViewCellIdentifier = "RecipeDescriptionTableViewCellI"
let RecipeInstructionTableViewCellIdentifier = "RecipeInstructionTableViewCell"
let RecipeCookingLevelTableViewCellIdentifier = "RecipeCookingLevelTableViewCell"

let RecipeModifierBarButtonItemActionName = "didPressBarButtonItem:"

// MARK: UITableViewDataSource
extension RecipeModifierViewController: UITableViewDataSource {
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    if self.editing {
      return 4
    } else {
      return 3
    }
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == 0 || section == 1 || section == 3 {
      return 1
    }
    guard let recipeInstructionsCount = self.recipe?.instructions?.count else {
      return 0
    }
    return recipeInstructionsCount
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    if indexPath.section == 0 {
      let cell = tableView.dequeueReusableCellWithIdentifier(RecipePhotoTableViewCellIdentifier, forIndexPath: indexPath) as! RecipePhotoTableViewCell
      cell.cameraButton.addTarget(self, action: "didRequestImagePickerForCamera:", forControlEvents: UIControlEvents.TouchUpInside)
      cell.photoLibraryButton.addTarget(self, action: "didRequestImagePickerForPhotoLibrary:", forControlEvents: UIControlEvents.TouchUpInside)
      if let image = self.cachedImage {
        cell.photoImageView.image = image
        cell.photoImageView.contentMode = UIViewContentMode.ScaleAspectFill
      }
      return cell
    } else if indexPath.section == 1 {
      let cell = tableView.dequeueReusableCellWithIdentifier(RecipeDescriptionTableViewCellIdentifier, forIndexPath: indexPath) as! RecipeDescriptionTableViewCell
      cell.descriptionDidChange = { self.recipe?.specification = $0 }
      cell.refreshCellUsingRecipeDescription(self.recipe?.specification)
      cell.descriptionTextView.inputAccessoryView = self.accessoryView
      cell.didBecomeFirstResponder = { self.firstResponderIndexPath = indexPath}
      return cell
    } else if indexPath.section == 2 {
      let cell = tableView.dequeueReusableCellWithIdentifier(RecipeInstructionTableViewCellIdentifier, forIndexPath: indexPath) as! RecipeInstructionTableViewCell
      if let instruction = self.recipe?.instructions?[indexPath.row] {
        cell.refreshCellUsingInstruction(instruction, number: indexPath.row + 1)
      }
      cell.instructionTextView.inputAccessoryView = self.accessoryView
      cell.instructionDidChange = { self.recipe?.instructions?[indexPath.row] = $0 }
      cell.didBecomeFirstResponder = { self.firstResponderIndexPath = indexPath }
      return cell
    } else if indexPath.section == 3 {
      let cell = tableView.dequeueReusableCellWithIdentifier(RecipeCookingLevelTableViewCellIdentifier, forIndexPath: indexPath) as! RecipeCookingLevelTableViewCell
      if let difficulty = self.recipe?.difficulty.integerValue {
        cell.levelSegmentedControl.selectedSegmentIndex = difficulty - 1
      }
      cell.cookingLevelDidChange = { selectedLevel in self.recipe?.difficulty = NSNumber(integer: selectedLevel) }
      return cell
    }
    return UITableViewCell()
  }
}

// MARK: UITableViewDelegate
extension RecipeModifierViewController: UITableViewDelegate {
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    guard let selectedCell = tableView.cellForRowAtIndexPath(indexPath) as? RecipeInstructionTableViewCell else {
      return
    }
    selectedCell.contentView.alpha = 1.0
    selectedCell.instructionTextView.textColor = UIColor.blackColor()
    selectedCell.instructionTextView.font = UIFont(name: "Avenir Book", size: 23.0)
    UIView.animateWithDuration(0.5, animations: { () -> Void in
      for visibleCell in tableView.visibleCells {
        guard visibleCell != selectedCell else {
          continue
        }
        visibleCell.contentView.alpha = 0.1
      }}, completion: { (completed) -> Void in
        if completed {
          self.tableView.beginUpdates()
          self.tableView.endUpdates()
          self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Top, animated: true)
        }
    })
  }
  
  func tableView(tableView: UITableView, shouldIndentWhileEditingRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    return false
  }
  
  func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    if section == 2 {
      return "Steps"
    } else if section == 3 {
      return "Cooking"
    }
    return nil
  }
  
  func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    if let view = view as? UITableViewHeaderFooterView {
      view.textLabel?.font = UIFont(name: "Avenir Book", size: 21.0)
      view.textLabel?.textColor = UIColor.darkGrayColor()
    }
  }
  
  func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
    return UITableViewCellEditingStyle.None
  }
  
  func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if indexPath.section == 2 {
      if editingStyle == UITableViewCellEditingStyle.Delete {
        if self.recipe?.instructions != nil {
          if let instruction = (tableView.cellForRowAtIndexPath(indexPath) as? RecipeInstructionTableViewCell)?.instructionTextView.text {
            let oldCount = self.recipe!.instructions!.count
            self.recipe!.instructions = self.recipe!.instructions!.filter {
              return $0 != instruction
            }
            let newCount = self.recipe!.instructions!.count
            if newCount < oldCount {
              tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
              tableView.reloadSections(NSIndexSet(index: 2), withRowAnimation: UITableViewRowAnimation.None)
            }
          }
        }
      }
    }
  }
}

// MARK: UITextFieldDelegate
extension RecipeModifierViewController: UITextFieldDelegate {
  func textFieldDidBeginEditing(textField: UITextField) {
    self.firstResponderIndexPath = nil
  }
  
  func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
    if range.location == 0 && string.isEmpty {
      self.navigationItem.leftBarButtonItem?.enabled = false
    } else {
      self.navigationItem.leftBarButtonItem?.enabled = true
    }
    return true
  }
  
  func textFieldDidEndEditing(textField: UITextField) {
    if let text = textField.text, let recipe = self.recipe {
      if text != recipe.name {
        self.recipe?.name = text
      }
    }
  }
}


// MARK: UIImagePickerControllerDelegate
extension RecipeModifierViewController: UIImagePickerControllerDelegate {
  
  func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
    picker.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    NSOperationQueue().addOperationWithBlock {
      self.recipe?.photoData = UIImageJPEGRepresentation(image,0.5)
      self.cachedImage = UIImage.scaledUIImageToSize(image, size: CGSize(width: 200, height: 200))
      NSOperationQueue.mainQueue().addOperationWithBlock {
        self.tableView.beginUpdates()
        self.tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Automatic)
        self.tableView.endUpdates()
      }
    }
  }
}

// MARK: UINavigationControllerDelegate
// UIImagePickerControllerDelegate requires to implement this protocol
extension RecipeModifierViewController: UINavigationControllerDelegate {
  
}

// MARK: -
class RecipeModifierViewController: UIViewController {
  
  @IBOutlet var tableView: UITableView!
  @IBOutlet var recipeNameTextField: UITextField!
  @IBOutlet var accessoryView: UIView!
  
  var recipe: Recipe?
  var cachedImage: UIImage?
  var firstResponderIndexPath: NSIndexPath?
  var isNewRecipe = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    self.accessoryView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 44)
    self.recipeNameTextField.inputAccessoryView = self.accessoryView
    tableView.estimatedRowHeight = 44.0
    tableView.rowHeight = UITableViewAutomaticDimension
    self.recipeNameTextField.tintAdjustmentMode = UIViewTintAdjustmentMode.Normal
    if let recipeName = self.recipe?.name {
      self.recipeNameTextField.text = recipeName
    }
    if let photo = self.recipe?.photoData {
      if let image = UIImage(data: photo) {
        self.cachedImage = UIImage.scaledUIImageToSize(image, size: CGSize(width: 200, height: 200))
      }
    }
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    // Keyboard Notifications
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    
  }
  
  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
    NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
  }
  
  
  override func viewDidAppear(animated: Bool) {
    self.tableView.reloadData()
    self.setEditing(self.isNewRecipe, animated: true)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: UIImagePickerController
  func didRequestImagePickerForPhotoLibrary(sender: AnyObject) {
    if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
      let imagePickerController = UIImagePickerController()
      imagePickerController.sourceType = .PhotoLibrary
      imagePickerController.delegate = self
      imagePickerController.mediaTypes = [kUTTypeImage as String]
      self.presentViewController(imagePickerController, animated: true, completion: nil)
    }
  }
  
  func didRequestImagePickerForCamera(sender: AnyObject) {
    if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
      let imagePickerController = UIImagePickerController()
      imagePickerController.sourceType = .Camera
      imagePickerController.delegate = self
      imagePickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureMode.Photo
      self.presentViewController(imagePickerController, animated: true, completion: nil)
    }
  }
  
  // MARK: Editing
  override func setEditing(editing: Bool, animated: Bool) {
    super.setEditing(editing, animated: animated)
    self.recipeNameTextField.userInteractionEnabled = editing
    self.tableView.setEditing(editing, animated: animated)
    if editing {
      self.tableView.reloadData()
      self.navigationItem.setLeftBarButtonItem(UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: Selector(RecipeModifierBarButtonItemActionName)), animated: true)
      if self.recipeNameTextField.text == nil || self.recipeNameTextField.text!.isEmpty {
        self.navigationItem.leftBarButtonItem?.enabled = false
      }
      self.navigationItem.setRightBarButtonItem(nil, animated: true)
      self.recipeNameTextField.becomeFirstResponder()
    } else {
      self.tableView.reloadData()
      self.navigationItem.setLeftBarButtonItem(UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Edit, target: self, action: Selector(RecipeModifierBarButtonItemActionName)), animated: true)
      self.navigationItem.setRightBarButtonItem(UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: Selector(RecipeModifierBarButtonItemActionName)), animated: true)
    }
  }
  
  // MARK: Keyboard
  func keyboardWillShow(notification: NSNotification) {
    guard let userInfo = notification.userInfo else {
      return
    }
    var keyboardFrame = userInfo["UIKeyboardFrameEndUserInfoKey"]!.CGRectValue
    keyboardFrame = self.tableView.convertRect(keyboardFrame, fromView: nil)
    let intersect = CGRectIntersection(keyboardFrame, self.tableView.bounds)
    if !CGRectIsNull(intersect) {
      let duration = userInfo["UIKeyboardAnimationDurationUserInfoKey"]!.doubleValue
      UIView.animateWithDuration(duration, animations: { () -> Void in
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, intersect.size.height, 0)
        self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, intersect.size.height, 0)
      })
    }
  }
  
  func keyboardWillHide(notification: NSNotification) {
    guard let userInfo = notification.userInfo else {
      return
    }
    let duration = userInfo["UIKeyboardAnimationDurationUserInfoKey"]!.doubleValue
    UIView.animateWithDuration(duration) { () -> Void in
      self.tableView.contentInset = UIEdgeInsetsZero
      self.tableView.scrollIndicatorInsets = UIEdgeInsetsZero
    }
  }
  
  // Responders
  func setNextResponderIndexPath() -> Bool {
    if let firstResponderIndexPath = firstResponderIndexPath {
      if let instructionsCount = self.recipe?.instructions?.count {
        if firstResponderIndexPath.section == 1 {
          if instructionsCount > 0 {
            self.firstResponderIndexPath = NSIndexPath(forRow: 0, inSection: 2)
            return true
          }
        } else if (firstResponderIndexPath.row + 1) < instructionsCount {
          self.firstResponderIndexPath = NSIndexPath(forRow: firstResponderIndexPath.row + 1, inSection: 2)
          return true
        }
      }
    } else {
      self.firstResponderIndexPath = NSIndexPath(forRow: 0, inSection: 1)
      return true
    }
    return false
  }
  
  func setPreviousResponderIndexPath() -> Bool {
    if let firstResponderIndexPath = firstResponderIndexPath {
      if firstResponderIndexPath.section == 1 {
        self.recipeNameTextField.becomeFirstResponder()
        return true
      } else if firstResponderIndexPath.section == 2 {
        if firstResponderIndexPath.row == 0 {
          self.firstResponderIndexPath = NSIndexPath(forRow: 0, inSection: 1)
          return true
        } else {
          self.firstResponderIndexPath = NSIndexPath(forRow: firstResponderIndexPath.row - 1, inSection: 2)
          return true
        }
      }
    }
    return false
  }
  
  // MARK: IBAction
  @IBAction func didPressBarButtonItem(sender: AnyObject) {
    if self.editing {
      if self.navigationItem.leftBarButtonItem! == sender as! NSObject {
        self.setEditing(false, animated: true)
      }
    } else {
      if self.navigationItem.leftBarButtonItem! == sender as! NSObject {
        self.setEditing(true, animated: true)
      } else if self.navigationItem.rightBarButtonItem! == sender as! NSObject {
        self.navigationItem.leftBarButtonItem?.enabled = false
        self.navigationItem.rightBarButtonItem?.enabled = false
        if let recipe = self.recipe {
          if recipe.changed() {
            self.recipe?.createOrUpdateOnRemote {
              if $0 {
                NSOperationQueue.mainQueue().addOperationWithBlock {
                  self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
                }
              } else {
                NSOperationQueue.mainQueue().addOperationWithBlock {
                  self.navigationItem.leftBarButtonItem?.enabled = true
                  self.navigationItem.rightBarButtonItem?.enabled = true
                  let alertController = UIAlertController(title: "Sorry !", message: "We failed to save your recipe on the server because of no internet connectivity. Please check your connection and try again ?", preferredStyle: UIAlertControllerStyle.Alert)
                  let cancelAlertAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { (alertAction: UIAlertAction) -> Void in
                    NSOperationQueue.mainQueue().addOperationWithBlock {
                      self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
                    }
                  })
                  let okAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                  alertController.addAction(cancelAlertAction)
                  alertController.addAction(okAlertAction)
                  self.presentViewController(alertController, animated: true, completion: nil)
                }
              }
            }
          } else {
            self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
          }
        }
      }
    }
  }
  
  @IBAction func didPressBarButtonInAccessoryView(sender: AnyObject) {
    guard let barButton = sender as? UIBarButtonItem else {
      return
    }
    var didSet = false
    if barButton.tag == 0 {
      didSet = self.setPreviousResponderIndexPath()
    } else if barButton.tag == 1 {
      didSet = self.setNextResponderIndexPath()
    } else if barButton.tag == 2 {
      self.recipe?.addInstruction("")
        if let instructionsCount = self.recipe?.instructions?.count {
          self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: instructionsCount - 1, inSection: 2)], withRowAnimation: UITableViewRowAnimation.Automatic)
          self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: instructionsCount - 1, inSection: 2), atScrollPosition: UITableViewScrollPosition.Top, animated: true)
          if let cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: instructionsCount - 1, inSection: 2)) as? RecipeInstructionTableViewCell {
            cell.refreshCellUsingInstruction("", number: instructionsCount)
            cell.instructionTextView.becomeFirstResponder()
        } else {
          self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 2)], withRowAnimation: UITableViewRowAnimation.Automatic)
          if let cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 2)) as? RecipeInstructionTableViewCell {
            cell.instructionTextView.becomeFirstResponder()
          }
        }
      }
    }
    if didSet || barButton.tag == 0 || barButton.tag == 1 {
      guard let firstResponderIndexPath = firstResponderIndexPath else {
        return
      }
      self.tableView.scrollToRowAtIndexPath(firstResponderIndexPath, atScrollPosition: UITableViewScrollPosition.Top, animated: true)
      if let cell = self.tableView.cellForRowAtIndexPath(firstResponderIndexPath) as? RecipeDescriptionTableViewCell {
        cell.descriptionTextView.becomeFirstResponder()
      } else if let cell = self.tableView.cellForRowAtIndexPath(firstResponderIndexPath) as? RecipeInstructionTableViewCell {
        cell.instructionTextView.becomeFirstResponder()
      }
    }
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
