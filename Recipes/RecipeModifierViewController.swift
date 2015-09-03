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

let RecipeModifierBarButtonItemActionName = "didPressBarButtonItem:"

// MARK: UITableViewDataSource
extension RecipeModifierViewController: UITableViewDataSource {
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 3
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == 0 || section == 1 {
      return 1
    }
    guard let recipeInstructions = self.recipeInstructions else {
      return 0
    }
    
    return recipeInstructions.count
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
      cell.descriptionTextView.inputAccessoryView = self.accessoryView
      if let recipeDescription = self.recipe?.specification {
        cell.descriptionTextView.text = recipeDescription
      }
      return cell
    } else if indexPath.section == 2 {
      let cell = tableView.dequeueReusableCellWithIdentifier(RecipeInstructionTableViewCellIdentifier, forIndexPath: indexPath) as! RecipeInstructionTableViewCell
      let instruction = self.recipeInstructions![indexPath.row]
      cell.instructionTextView.text = "\(instruction). This is the instruction you have been waiting for. You can either die as a hero or you can live long enough to become a villian and I can do those things."
      cell.instructionTextView.inputAccessoryView = self.accessoryView
      cell.instructionNumberLabel.text = "\(indexPath.row + 1)"
      return cell
    }
    return UITableViewCell()
  }
}

// MARK: UITableViewDelegate
extension RecipeModifierViewController: UITableViewDelegate {

  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    //Todo : Implement Cooking Mode
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
  
  func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
    return UITableViewCellEditingStyle.None
  }
  
  func tableView(tableView: UITableView, shouldIndentWhileEditingRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    return false
  }
}

// MARK: UITextFieldDelegate
extension RecipeModifierViewController: UITextFieldDelegate {
  func textFieldDidBeginEditing(textField: UITextField) {
    self.firstResponderIndexPath = nil
  }

  func textFieldDidEndEditing(textField: UITextField) {
    self.recipe?.name = textField.text
  }
}


// MARK: UIImagePickerControllerDelegate
extension RecipeModifierViewController: UIImagePickerControllerDelegate {

  func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
    picker.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    NSOperationQueue().addOperationWithBlock {
      self.recipe?.photo?.data = UIImageJPEGRepresentation(image,0.5)
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

class RecipeModifierViewController: UIViewController {
  
  @IBOutlet var tableView: UITableView!
  @IBOutlet var recipeNameTextField: UITextField!
  @IBOutlet var accessoryView: UIView!
  
  var recipe: Recipe?
  var cachedImage: UIImage?
  var recipeInstructions: [String]?
  var cookingMode = false
  var firstResponderIndexPath: NSIndexPath?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    self.accessoryView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 44)
    self.recipeNameTextField.inputAccessoryView = self.accessoryView
    self.setEditing(false, animated: true)
    tableView.estimatedRowHeight = 44.0
    tableView.rowHeight = UITableViewAutomaticDimension
    self.recipeNameTextField.tintAdjustmentMode = UIViewTintAdjustmentMode.Normal
    if let recipeName = self.recipe?.name {
      self.recipeNameTextField.text = recipeName
    }
    if let recipeInstructions = self.recipe?.instructions {
      self.recipeInstructions = recipeInstructions.allObjects as? [String]
      self.recipeInstructions!.append("Here's Another Step. Stay Healthy")
      self.recipeInstructions!.append("Stay fine. This is a very important step. This must be done in order to keep the food well cooked. This would allow you to stay fit")
    }
    
    if let photo = self.recipe?.photo?.data {
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
      self.navigationItem.setLeftBarButtonItem(UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: Selector(RecipeModifierBarButtonItemActionName)), animated: true)
      self.navigationItem.setRightBarButtonItem(nil, animated: true)
      self.recipeNameTextField.becomeFirstResponder()
    } else {
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

  // MARK: IBAction
  @IBAction func didPressBarButtonItem(sender: AnyObject) {
    if self.editing && self.navigationItem.leftBarButtonItem! == sender as! NSObject {
      self.setEditing(false, animated: true)
    } else if !self.editing {
      if self.navigationItem.leftBarButtonItem! == sender as! NSObject {
        self.setEditing(true, animated: true)
      } else if self.navigationItem.rightBarButtonItem! == sender as! NSObject {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
      }
    }
  }

  func nextResponderIndexPath() -> NSIndexPath? {
    guard let firstResponderIndexPath = self.firstResponderIndexPath else {
      return nil
    }
    if firstResponderIndexPath.section == 1 {
      if self.recipeInstructions?.first != nil {
        self.firstResponderIndexPath = NSIndexPath(forRow: 0, inSection: 2)
        return firstResponderIndexPath
      }
    } else if firstResponderIndexPath.section == 2 {
      if self.recipeInstructions != nil && (firstResponderIndexPath.row + 1) < self.recipeInstructions!.count {
        self.firstResponderIndexPath = NSIndexPath(forRow: firstResponderIndexPath.row + 1, inSection: 2)
        return self.firstResponderIndexPath
      }
    }
    return nil
  }
  
  @IBAction func didPressBarButtonInAccessoryView(sender: AnyObject) {
    guard let barButton = sender as? UIBarButtonItem else {
      return
    }
    if let title = barButton.title {
      if title == "Next" {
        guard let nextResponderIndexPath = self.nextResponderIndexPath() else {
          return
        }
        self.tableView.scrollToRowAtIndexPath(nextResponderIndexPath, atScrollPosition: UITableViewScrollPosition.Top, animated: true)
        if let cell = self.tableView.cellForRowAtIndexPath(nextResponderIndexPath) as? RecipeDescriptionTableViewCell {
          cell.descriptionTextView.becomeFirstResponder()
        }
        if let cell = self.tableView.cellForRowAtIndexPath(nextResponderIndexPath) as? RecipeInstructionTableViewCell {
          cell.instructionTextView.becomeFirstResponder()
        }
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
