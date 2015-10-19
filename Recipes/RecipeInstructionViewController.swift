//
//  RecipeInstructionViewController.swift
//  Recipes
//
//  Created by Nofel Mahmood on 15/10/2015.
//  Copyright © 2015 Hyper. All rights reserved.
//

import UIKit
import QuartzCore


class RecipeInstructionViewController: UIViewController {
  @IBOutlet var mainStackView: UIStackView!
  @IBOutlet var instructionTextView: UITextView!
  @IBOutlet var numberLabel: UILabel!
  @IBOutlet var numberLabelBackgroundView: UIView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.numberLabel.backgroundColor = UIColor.whiteColor()
    self.numberLabel.layer.cornerRadius = self.numberLabel.frame.size.width/2
    self.numberLabel.clipsToBounds = true
  }
  
  func setUpWithInstruction(instruction: String, number: Int) {
    self.instructionTextView.text = instruction
    self.numberLabel.text = "\(number)"
  }
}
