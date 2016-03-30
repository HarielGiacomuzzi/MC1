//
//  CloudKitManager.swift
//  MC1
//
//  Created by Hariel Giacomuzzi on 3/28/16.
//  Copyright © 2016 Giacomuzzi. All rights reserved.
//

import CloudKit
import Foundation

class CloudKitManager: NSObject {
    
    let RECORD_TYPE_PRODUTOS = "Produto"
    let publicDB: CKDatabase = CKContainer.defaultContainer().publicCloudDatabase
    static let SharedInstance = CloudKitManager()
    
    // if the category is nil the default is the promotional category
    func getProductsByCategory(category : String, completion : (NSArray -> Void)){
        var ctg = category
        if ctg.isEmpty {
            ctg = "promotional"
        }
            let queryCategory = CKQuery(recordType: self.RECORD_TYPE_PRODUTOS, predicate: NSPredicate(format: "categoria == %@", ctg))
        
            queryCategory.sortDescriptors = [NSSortDescriptor(key: "nome", ascending: true)]
        
            publicDB.performQuery(queryCategory, inZoneWithID: nil, completionHandler: {records, error in
                if let e = error {
                    print("\(e.localizedDescription)")
                } else {
                    completion(records!)
                }
        })
    }
}
