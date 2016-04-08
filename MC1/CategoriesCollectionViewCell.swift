//
//  CategoriesCollectionViewCell.swift
//  MC1
//
//  Created by Vinicius Valvassori on 31/03/16.
//  Copyright © 2016 Giacomuzzi. All rights reserved.
//

import UIKit

class CategoriesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var categoryNameView: UIView!
    
    override func awakeFromNib() {
        categoryNameView.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.4)
        categoryNameView.hidden = true
        categoryImage.adjustsImageWhenAncestorFocused = true
        
        //resetAnimation()
        //animateToTop()
        
    }
    
    
    func changeVisibilityNameView(){
        if categoryNameView.hidden == false{
           categoryNameView.hidden = true
            resetAnimation()
        }else{
            categoryNameView.hidden = false
            performAnimation()
        }
    }
    
    func performAnimation(){
        UIView.animateWithDuration(0.25, delay: 0.1, options: .CurveEaseOut, animations: {
            var frameTemp = self.categoryNameView.frame
            frameTemp.origin.x = -27
            frameTemp.origin.y = self.bounds.height - self.categoryNameView.frame.height + 13
            self.categoryNameView.frame = frameTemp
            },completion: nil )
    }
    
    func resetAnimation(){
        categoryNameView.frame = CGRectMake(-28, 255, categoryNameView.frame.width, categoryNameView.frame.height)
    }
    
    
}
