//
//  RecipeModifierInputAccessoryViewController.swift
//  Recipes
//
//  Created by Nofel Mahmood on 02/09/2015.
//  Copyright © 2015 Hyper. All rights reserved.
//

import UIKit

class RecipeModifierInputAccessoryViewController: UIViewController {
  
  @IBOutlet var toolbar: UIToolbar!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
  }
  
  override func viewDidAppear(animated: Bool) {
    self.toolbar.becomeFirstResponder()
  }
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: IBAction
  @IBAction func didPressBarButtonItem(sender: AnyObject) {
    print("Did Press bar button")
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
