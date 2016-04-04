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
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productNameView: UIView!
    
    
    let gradient = CAGradientLayer()
    
    override func awakeFromNib() {
        productNameView.hidden = true
        highlightProductImage.adjustsImageWhenAncestorFocused = true
        
    }
    
    func changeVisibilityNameView(){
        //print(1)
        //gradient.hidden = true
        if productNameView.hidden == false{
            productNameView.hidden = true
        }else{
            productNameView.hidden = false
        }
    }
    
    
    
}
