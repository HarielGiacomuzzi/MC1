//
//  ShoppingManager.swift
//  MC1
//
//  Created by Hariel Giacomuzzi on 3/30/16.
//  Copyright © 2016 Giacomuzzi. All rights reserved.
//

import Foundation

class ShoppingManager: NSObject {
    let sharedInstance : ShoppingManager = ShoppingManager()
    
    func realizeNewShop(product : Product) -> Bool{
        let aux = Shop()
        aux.product = product.productReference
        aux.date = NSDate()
        aux.processed = 1;
        return CloudKitManager.SharedInstance.saveNewShopping(aux)
    }
}
