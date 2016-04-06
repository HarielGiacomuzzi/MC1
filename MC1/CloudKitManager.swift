//
//  CloudKitManager.swift
//  MC1
//
//  Created by Hariel Giacomuzzi on 3/28/16.
//  Copyright © 2016 Giacomuzzi. All rights reserved.
//

import CloudKit
import Foundation
import UIKit
import QuartzCore

class CloudKitManager: NSObject {
    
    let RECORD_TYPE_PRODUTOS = "Produto"
    let RECORD_TYPE_COMPRA = "Compra"
    
    let publicDB: CKDatabase = CKContainer.defaultContainer().publicCloudDatabase
    let privateDB: CKDatabase = CKContainer.defaultContainer().privateCloudDatabase
    static let SharedInstance = CloudKitManager()
    
    func getProductsByCategory(category : String, completion : ([Product]?, NSError? )-> Void){
            let queryCategory = CKQuery(recordType: self.RECORD_TYPE_PRODUTOS, predicate: NSPredicate(format: "categoria == %@", category))
        
            queryCategory.sortDescriptors = [NSSortDescriptor(key: "nome", ascending: true)]
        
            publicDB.performQuery(queryCategory, inZoneWithID: nil, completionHandler: {records, error in
                if let e = error {
                    completion(nil, e)
                    return
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
                        prod.highlight = (i.valueForKey("destaque") as? Int)! == 1 ? true : false
                        prod.productReference = CKReference(recordID: i.recordID, action: CKReferenceAction.None)
                        aux.append(prod)
                    }
                    completion(aux, nil)
                }
        })
    }
    
    func getHighlightProducts(completion : ([Product]?, NSError?) -> Void){
        let queryCategory = CKQuery(recordType: self.RECORD_TYPE_PRODUTOS, predicate: NSPredicate(format: "destaque == 1"))
        
        queryCategory.sortDescriptors = [NSSortDescriptor(key: "nome", ascending: true)]
        
        publicDB.performQuery(queryCategory, inZoneWithID: nil, completionHandler: {records, error in
            if let e = error {
                completion(nil, e)
                return
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
                    prod.highlight = (i.valueForKey("destaque") as? Int)! == 1 ? true : false
                    prod.productReference = CKReference(recordID: i.recordID, action: CKReferenceAction.None)
                    aux.append(prod)
                }
                completion(aux, nil)
            }
        })
    }
    
    private func getProductsByID(prodReference : CKReference, completion : (Product?, NSError?) -> Void){
        let queryCategory = CKQuery(recordType: self.RECORD_TYPE_PRODUTOS, predicate: NSPredicate(value: true))
        publicDB.performQuery(queryCategory, inZoneWithID: nil, completionHandler: {records, error in
            if let e = error {
                completion(nil ,e)
                return
            } else {
                let aux = Product()
                for i in records!{
                    if i.recordID == prodReference.recordID{
                        aux.name = (i.valueForKey("nome") as? String)!
                        aux.price = (i.valueForKey("preco") as? Double)!
                        aux.desc = (i.valueForKey("desc") as? String)!
                        aux.category = (i.valueForKey("categoria") as? String)!
                        aux.video = (i.valueForKey("video") as? String)!
                        aux.photos = (i.valueForKey("fotos") as? [String])!
                        aux.highlight = (i.valueForKey("destaque") as? Int)! == 1 ? true : false
                        aux.productReference = CKReference(recordID: i.recordID, action: CKReferenceAction.None)
                    }
                }
                completion(aux, nil)
            }
        })
    }
    
    func saveNewShopping(shop : Shop, completionHandler : (NSError? -> Void)){
        let record = CKRecord(recordType: RECORD_TYPE_COMPRA)
        record["date"] = shop.date
        record["processed"] = shop.processed
        record["productReference"] = shop.product
        record["productName"] = shop.productName
        privateDB.saveRecord(record) { (record, error) in
            if let e = error {
                completionHandler(e)
            }else{
                completionHandler(nil)
            }
        }
    }
    
    func loadShopHistory(startDate : NSDate, endDate : NSDate ,processed : Bool? ,completion : ([Shop]?, NSError?) -> Void){
        var predicate = NSPredicate()
        if processed != nil {
            predicate = NSPredicate(format: "(date >= %@) AND (date <= %@) AND (processed == %i)", startDate, endDate, processed! ? 1 : 0)
        }else{
            predicate = NSPredicate(format: "(date >= %@) AND (date <= %@)", startDate, endDate)
        }
        
                let query = CKQuery(recordType: RECORD_TYPE_COMPRA, predicate: predicate)
        privateDB.performQuery(query, inZoneWithID: nil, completionHandler:  { records, error in
            if let e = error {
                completion(nil, e)
                return
            } else {
                var aux = [Shop]()
                for i in records!{
                    let item = Shop()
                    item.date = i["date"] as? NSDate
                    item.processed = i["processed"] as? Int
                    item.product = i["productReference"] as? CKReference
                    aux.append(item)
                }
                completion(aux, nil)
            }
        })
    }
}
