//
//  HighlightProductNameGradientView.swift
//  MC1
//
//  Created by Vinicius Valvassori on 01/04/16.
//  Copyright © 2016 Giacomuzzi. All rights reserved.
//

import UIKit

class HighlightProductNameGradientView: UIView {

    override func awakeFromNib() {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = [UIColor.whiteColor().CGColor, UIColor.whiteColor().colorWithAlphaComponent(0).CGColor]
        gradient.startPoint = CGPointMake(0.0,0.0)
        gradient.endPoint = CGPointMake(1.0,0.0)
        self.layer.insertSublayer(gradient, atIndex: 0)
    }
    
}