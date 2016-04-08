//
//  PlayerView.swift
//  MC1
//
//  Created by Hariel Giacomuzzi on 4/5/16.
//  Copyright © 2016 Giacomuzzi. All rights reserved.
//

import UIKit

class PlayerView: UIView {

    var areFocus = false
    var layerVideo : CALayer?
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    override func canBecomeFocused() -> Bool {
        return true
    }

    override func didUpdateFocusInContext(context: UIFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
        
        if context.nextFocusedView == self {
            
            coordinator.addCoordinatedAnimations({ () -> Void in
                
                self.layer.backgroundColor = UIColor.blueColor().colorWithAlphaComponent(0.2).CGColor
                self.areFocus = true
                
                }, completion: nil)
            
        } else if context.previouslyFocusedView == self {
            
            coordinator.addCoordinatedAnimations({ () -> Void in
                
                self.layer.backgroundColor = UIColor.clearColor().CGColor
                self.areFocus = false
                
                }, completion: nil)
            
        }
        
    }
    
    override func shouldUpdateFocusInContext(context: UIFocusUpdateContext) -> Bool {
        return true
    }
}
