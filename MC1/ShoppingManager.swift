//
//  ShoppingManager.swift
//  MC1
//
//  Created by Hariel Giacomuzzi on 3/30/16.
//  Copyright © 2016 Giacomuzzi. All rights reserved.
//

import Foundation

func -(data : NSDate, int : Int)-> NSDate{
    let unitFlags: NSCalendarUnit = [.Hour, .Day, .Month, .Year]
    let components = NSCalendar.currentCalendar().components(unitFlags, fromDate: data)
    (components.hour + int ) < 24 ? components.hour + int : components.day+1
    return NSDate()
}

class ShoppingManager: NSObject {
    
    static let sharedInstance : ShoppingManager = ShoppingManager()
    
    func realizeNewShop(product : Product, completionHandler : ((error :NSError?, shop :Shop?) -> Void)){
        CloudKitManager.SharedInstance.loadShopHistory(NSDate(), endDate: NSDate()-1, processed: nil) { (results, error) in
            if error != nil && results != nil {
                var controll = true
                for shop in results!{
                    if shop.product == product {
                        controll = false
                    }
                }
                if controll{
                    let aux = Shop()
                    aux.product = product.productReference
                    aux.date = NSDate()
                    aux.processed = 1;
                    aux.productName = product.name
                    CloudKitManager.SharedInstance.saveNewShopping(aux, completionHandler:  {(error)in
                        if error != nil{
                            completionHandler(error: error,shop:  aux)
                        }else{
                            completionHandler(error: nil,shop:
                                
                                aux)
                        }
                    })
                    
                    }
            }else{
                completionHandler(error: error, shop: nil)
            }
        }
    }
}
