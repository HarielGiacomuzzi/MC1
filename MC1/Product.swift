//
//  Product.swift
//  MC1
//
//  Created by Hariel Giacomuzzi on 3/30/16.
//  Copyright © 2016 Giacomuzzi. All rights reserved.
//

import Foundation
import CloudKit

class Product: NSObject {
    var category : String?
    var desc : String?
    var photos : [String]?
    var name : String?
    var price : Double?
    var video : String?
    var highlight : Bool?
    var productReference : CKReference?
}
