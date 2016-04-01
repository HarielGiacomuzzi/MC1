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
    private let messageView = UIView()
    static let SharedInstance = CloudKitManager()
    
    func getProductsByCategory(category : String, completion : ([Product] -> Void)){
            let queryCategory = CKQuery(recordType: self.RECORD_TYPE_PRODUTOS, predicate: NSPredicate(format: "categoria == %@", category))
        
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
                        prod.highlight = (i.valueForKey("destaque") as? Int)! == 1 ? true : false
                        prod.productReference = CKReference(recordID: i.recordID, action: CKReferenceAction.None)
                        aux.append(prod)
                    }
                    completion(aux)
                }
        })
    }
    
    func getHighlightProducts(completion : ([Product] -> Void)){
        let queryCategory = CKQuery(recordType: self.RECORD_TYPE_PRODUTOS, predicate: NSPredicate(format: "destaque == 1"))
        
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
                    prod.highlight = (i.valueForKey("destaque") as? Int)! == 1 ? true : false
                    prod.productReference = CKReference(recordID: i.recordID, action: CKReferenceAction.None)
                    aux.append(prod)
                }
                completion(aux)
            }
        })
    }
    
    private func getProductsByID(prodReference : CKReference, completion : (Product -> Void)){
        let queryCategory = CKQuery(recordType: self.RECORD_TYPE_PRODUTOS, predicate: NSPredicate(value: true))
        publicDB.performQuery(queryCategory, inZoneWithID: nil, completionHandler: {records, error in
            if let e = error {
                print("\(e.localizedDescription)")
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
                completion(aux)
            }
        })
    }
    
    func saveNewShopping(shop : Shop){
        let record = CKRecord(recordType: RECORD_TYPE_COMPRA)
        record["date"] = shop.date
        record["processed"] = shop.processed
        record["productReference"] = shop.product
        record["productName"] = shop.productName
        privateDB.saveRecord(record) { (record, error) in
            if let e = error {
                print(e.localizedDescription)
            }
            self.getProductsByID(shop.product!, completion: { (prod) in
                self.notification("A compra de \(shop.productName!) foi concluida com sucesso !")
            })
        }
    }
    
    private func notification(message : String){
        dispatch_async(dispatch_get_main_queue()) {
            let activeView = ViewManager.sharedInstance.activeView!
            let errorMessage = UILabel()
            self.messageView.frame = CGRectMake(activeView.view.frame.width+600,+40.0, 600.0, 150.0)
            self.messageView.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.4)
            self.messageView.layer.cornerRadius = 15.0
            self.messageView.clipsToBounds = true
            activeView.view.addSubview(self.messageView)
            errorMessage.frame = CGRectMake(10,0, 580.0, 130.0)
            errorMessage.textColor = UIColor.blackColor()
            errorMessage.text = message
            errorMessage.lineBreakMode = NSLineBreakMode.ByWordWrapping
            errorMessage.numberOfLines = 2
            errorMessage.font = UIFont.boldSystemFontOfSize(30)
            self.messageView.addSubview(errorMessage)
            UIView.animateWithDuration(2, animations: { 
                    self.messageView.frame = CGRectMake(activeView.view.frame.width-630,+40.0, 600.0, 150.0)
            }, completion: { (completed) in
                    if completed{
                        let timer = NSTimer.scheduledTimerWithTimeInterval(4.0, target: self, selector: #selector(CloudKitManager.undoNotification), userInfo: nil, repeats: false)
                    }
            })
        }
    }
    
    @objc private func undoNotification(){
        dispatch_async(dispatch_get_main_queue()) {
            UIView.animateWithDuration(1.8, animations: {
                    self.messageView.frame = CGRectMake(ViewManager.sharedInstance.activeView!.view.frame.width+600,+40.0, 600.0, 150.0)
            }, completion: { (completed) in
                    if completed {
                        self.messageView.removeFromSuperview()
                    }
            })
        }
    }
    
    func loadShopHistory(startDate : NSDate, endDate : NSDate ,processed : Bool? ,completion : ([Shop] -> Void)){
        var predicate = NSPredicate()
        if processed != nil {
            predicate = NSPredicate(format: "(date >= %@) AND (date <= %@) AND (processed == %i)", startDate, endDate, processed! ? 1 : 0)
        }else{
            predicate = NSPredicate(format: "(date >= %@) AND (date <= %@)", startDate, endDate)
        }
        
                let query = CKQuery(recordType: RECORD_TYPE_COMPRA, predicate: predicate)
        privateDB.performQuery(query, inZoneWithID: nil, completionHandler:  { records, error in
            if let e = error {
                print("\(e.localizedDescription)")
            } else {
                var aux = [Shop]()
                for i in records!{
                    let item = Shop()
                    item.date = i["date"] as? NSDate
                    item.processed = i["processed"] as? Int
                    item.product = i["productReference"] as? CKReference
                    aux.append(item)
                }
                completion(aux)
            }
        })
    }
}
