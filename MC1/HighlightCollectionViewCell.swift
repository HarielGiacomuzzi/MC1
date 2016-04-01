//
//  HighlightCell.swift
//  MC1
//
//  Created by Vinicius Valvassori on 31/03/16.
//  Copyright © 2016 Giacomuzzi. All rights reserved.
//

import UIKit

class HighlightCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var highlightProductImage: UIImageView!
    
    @IBOutlet weak var productNameView: UIView!
    
    override func awakeFromNib() {
        productNameView.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.4)
        productNameView.hidden = true
        highlightProductImage.adjustsImageWhenAncestorFocused = true
        
    }
    
    func changeVisibilityNameView(){
        if productNameView.hidden == false{
            productNameView.hidden = true
        }else{
            productNameView.hidden = false
        }
    }
    
    
}
