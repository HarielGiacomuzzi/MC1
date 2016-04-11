//
//  CenterCellCollectionViewFlowLayout.swift
//  MC1
//
//  Created by Vinicius Valvassori on 31/03/16.
//  Copyright © 2016 Giacomuzzi. All rights reserved.
//

import UIKit

class CenterCellCollectionViewFlowLayout: UICollectionViewFlowLayout {

    override func targetContentOffsetForProposedContentOffset(proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {

        var offSetAdjustment = CGFloat.max
        var horizontalCenter = (proposedContentOffset.x + (self.collectionView!.bounds.size.width / 2.0))
        var targetRect = CGRect(x: proposedContentOffset.x, y: 0.0, width: self.collectionView!.bounds.size.width, height: self.collectionView!.bounds.size.height);
        var array = layoutAttributesForElementsInRect (targetRect)
        for layoutAttributes in array! {
            var itemHorizontalCenter = layoutAttributes.center.x;
            if (abs (itemHorizontalCenter - horizontalCenter) < abs(offSetAdjustment)) {
                offSetAdjustment = itemHorizontalCenter - horizontalCenter;
            }
        }
        print(CGPoint (x: proposedContentOffset.x + offSetAdjustment, y: proposedContentOffset.y))
        return CGPoint (x: (proposedContentOffset.x + offSetAdjustment)*1, y: proposedContentOffset.y)
        
        
//        if let cv = self.collectionView {
//            
//            let cvBounds = cv.bounds
//            let halfWidth = cvBounds.size.width * 0.5;
//            let proposedContentOffsetCenterX = proposedContentOffset.x + halfWidth;
//            
//            if let attributesForVisibleCells = self.layoutAttributesForElementsInRect(cvBounds)! as? [UICollectionViewLayoutAttributes] {
//                
//                var candidateAttributes : UICollectionViewLayoutAttributes?
//                for attributes in attributesForVisibleCells {
//                    
//                    // == Skip comparison with non-cell items (headers and footers) == //
//                    if attributes.representedElementCategory != UICollectionElementCategory.Cell {
//                        continue
//                    }
//                    
//                    if let candAttrs = candidateAttributes {
//                        
//                        let a = attributes.center.x - proposedContentOffsetCenterX
//                        let b = candAttrs.center.x - proposedContentOffsetCenterX
//                        
//                        if fabsf(Float(a)) < fabsf(Float(b)) {
//                            candidateAttributes = attributes;
//                        }
//                        
//                    }
//                    else { // == First time in the loop == //
//                        
//                        candidateAttributes = attributes;
//                        continue;
//                    }
//                    
//                    
//                }
//                //print(round(candidateAttributes!.center.x - halfWidth*0.97), proposedContentOffset.y)
//                return CGPoint(x: round(candidateAttributes!.center.x - halfWidth*0.97), y: proposedContentOffset.y)
//                
//            }
//            
//        }
//        
//        // Fallback
//        return super.targetContentOffsetForProposedContentOffset(proposedContentOffset)
    }
    


}
