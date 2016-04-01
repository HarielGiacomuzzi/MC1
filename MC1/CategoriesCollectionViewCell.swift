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
    }
    
    func changeVisibilityNameView(){
        if categoryNameView.hidden == false{
           categoryNameView.hidden = true
        }else{
            categoryNameView.hidden = false
        }
    }
    
}
