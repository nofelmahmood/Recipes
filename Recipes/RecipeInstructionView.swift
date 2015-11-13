//
//  RecipeInstructionView.swift
//  Recipes
//
//  Created by Nofel Mahmood on 21/10/2015.
//  Copyright © 2015 Hyper. All rights reserved.
//

import UIKit
import QuartzCore

class RecipeInstructionView: UIView {
  @IBOutlet var mainStackView: UIStackView!
  @IBOutlet var instructionTextView: UITextView!
  @IBOutlet var numberLabel: UILabel!
  @IBOutlet var numberLabelBackgroundView: UIView!
  
  class var view: RecipeInstructionView? {
    let nibContents = NSBundle.mainBundle().loadNibNamed("RecipeInstructionView", owner: nil, options: nil)
    if let view = nibContents.last as? RecipeInstructionView {
      view.backgroundColor = UIColor.clearColor()
      view.numberLabel.backgroundColor = UIColor.whiteColor()
      view.numberLabel.layer.cornerRadius = view.numberLabel.frame.size.width/2
      view.numberLabel.clipsToBounds = true
      return view
    }
    return nil
  }
  
  func setUpWithInstruction(instruction: String, number: Int) {
    self.instructionTextView.text = instruction
    self.numberLabel.text = "\(number)"
  }
  
  /*
  // Only override drawRect: if you perform custom drawing.
  // An empty implementation adversely affects performance during animation.
  override func drawRect(rect: CGRect) {
  // Drawing code
  }
  */
  
}
