//
//  ViewController.swift
//  MC1
//
//  Created by Hariel Giacomuzzi on 3/18/16.
//  Copyright © 2016 Giacomuzzi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let a = NSDateFormatter()
        a.dateFormat = "dd/MM/yyyy - HH:mm:ss"
        
        CloudKitManager.SharedInstance.loadShopHistory(a.dateFromString("31/03/2016 - 00:00:00")!, endDate: a.dateFromString("01/04/2016 - 00:00:00")!, processed: true) { (results) in
            let b = results[0]
            print(a.stringFromDate(b.date!))
            print(b.product!)
            print(b.processed!)
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

