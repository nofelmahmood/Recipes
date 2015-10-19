//
//  RecipeDetailCollectionViewCell.swift
//  Recipes
//
//  Created by Nofel Mahmood on 12/10/2015.
//  Copyright © 2015 Hyper. All rights reserved.
//

import UIKit

extension RecipeDetailCollectionViewCell: UIScrollViewDelegate {
  func scrollViewDidScroll(scrollView: UIScrollView) {
    self.scrollViewDidScroll?(contentOffset: scrollView.contentOffset)
  }
}

class RecipeDetailCollectionViewCell: UICollectionViewCell {
  @IBOutlet var scrollView: UIScrollView!
  @IBOutlet var nameTextField: UITextField!
  @IBOutlet var photoImageView: UIImageView!
  @IBOutlet var descriptionTextView: UITextView!
  @IBOutlet var backgroundImageView: UIImageView!
  @IBOutlet var mainStackView: UIStackView!
  @IBOutlet var instructionsStackView: UIStackView!
  
  var scrollViewDidScroll: ((contentOffset: CGPoint) -> Void)?
  
  var storyboard: UIStoryboard {
    return UIStoryboard(name: "Main", bundle: nil)
  }
  
  override func awakeFromNib() {
    self.scrollView.delegate = self
  }
  
  func configureCellWithRecipe(recipe: RecipeViewModel) {
    self.nameTextField.text = recipe.name
    if let specification = recipe.specification {
      self.descriptionTextView.text = specification
    }
    if let instructions = recipe.instructions {
      var number = 1
      for instruction in instructions {
        let instructionViewController = self.storyboard.instantiateViewControllerWithIdentifier("RecipeInstructionViewController") as! RecipeInstructionViewController
        _ = instructionViewController.view
        instructionViewController.setUpWithInstruction("\(instruction) danjd jasnd jasdnj ndjsna jdsan jndsaj njasdn jasdnj njd njsadnj njsdnajsdanjd sanjnds ajndsaj njsdanjsdajsdan jdsna jds anj dsanjds anjdasnjadsn jas dnjasdnjdas nj anj asdn sadjn adsjnads jnads jnads jndas jads nj dasnjadsnj dasnjdas n adsjndsa jndas jndas jndasj n adsjna dsjnasdjnda sjnd asjdna sjadns jdas njdasnjads nj dasnjads njads njads njads n adsjnad sjnads jnads jnads jnads jads njads njsad nasd jn adsjans djdas njd asjnads jnjad nsjndas jnd asjnads njads jnd sanj adsnjnjads jndas jnads jnda sjnads jnad sjndas jnd asjnadsj njn adsjnd asjnads jnads jndas njda nsjjnads njdas jn adsnjdas jnad sjnd asjnads jnad sjnads jnadsjn jnads jnads jnad sjnad sjnads jna dsjna dsjnad sjnjnads jnads jnads jn asjn adsjn dsajnasd jnasd jnas djn adsjnajdns jnads jnads jnads jnads jnas djnads jnjnads jnads jna ds", number: number)
        self.instructionsStackView.addArrangedSubview(instructionViewController.mainStackView)
        number++
      }
    }
  }
  
  override func prepareForReuse() {
    self.scrollView.contentOffset = CGPoint(x: 0, y: 0)
    for view in self.instructionsStackView.subviews {
      view.removeFromSuperview()
    }
  }
}
