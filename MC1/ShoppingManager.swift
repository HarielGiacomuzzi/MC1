//
//  ShoppingManager.swift
//  MC1
//
//  Created by Hariel Giacomuzzi on 3/30/16.
//  Copyright © 2016 Giacomuzzi. All rights reserved.
//

import Foundation

class ShoppingManager: NSObject {
    
    static let sharedInstance : ShoppingManager = ShoppingManager()
    
    func realizeNewShop(product : Product){
//        let dateFormater = NSDateFormatter()
//        dateFormater.timeZone = NSTimeZone.init(abbreviation: "UTC")
//        dateFormater.defaultDate = NSDate()
        let aux = Shop()
        aux.product = product.productReference
        aux.date = NSDate()
        aux.processed = 1;
        CloudKitManager.SharedInstance.saveNewShopping(aux)
    }
}
