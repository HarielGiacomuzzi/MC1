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
    let RECORD_TYPE_COMPRA = "Compra"
    let publicDB: CKDatabase = CKContainer.defaultContainer().publicCloudDatabase
    let privateDB: CKDatabase = CKContainer.defaultContainer().privateCloudDatabase
    static let SharedInstance = CloudKitManager()
    
    // if the category is nil the default is the promotional category
    func getProductsByCategory(category : String, completion : ([Product] -> Void)){
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
                    var aux = [Product]()
                    for i in records!{
                        let prod = Product()
                        prod.name = (i.valueForKey("nome") as? String)!
                        prod.price = (i.valueForKey("preco") as? Double)!
                        prod.desc = (i.valueForKey("desc") as? String)!
                        prod.category = (i.valueForKey("categoria") as? String)!
                        prod.video = (i.valueForKey("video") as? String)!
                        prod.photos = (i.valueForKey("fotos") as? [String])!
                        prod.productReference = CKReference(recordID: i.recordID, action: CKReferenceAction.None)
                        aux.append(prod)
                    }
                    completion(aux)
                }
        })
    }
    
    func saveNewShopping(shop : Shop) -> Bool{
        
        return true
    }
}
