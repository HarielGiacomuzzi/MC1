//
//  ShopHistoryViewController.swift
//  MC1
//
//  Created by Pablo Henrique Bertaco on 4/7/16.
//  Copyright © 2016 Giacomuzzi. All rights reserved.
//

import UIKit

class ShopHistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var products = [Product]()
    
    var tableView:UITableView!
    var tableViewCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView = UITableView(frame: self.view.frame, style: UITableViewStyle.Plain)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.view.addSubview(tableView)
        
        CloudKitManager.SharedInstance.getHighlightProducts { [weak self] (products:[Product]?, error:NSError?) in
            guard let shopHistoryViewController = self else { return }
            
            if let someError = error {
                print("error: " + someError.localizedDescription)
            } else {
                if let someProducts = products {
                    shopHistoryViewController.products.appendContentsOf(someProducts)
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        shopHistoryViewController.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10//return self.products.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //let tableViewCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        let tableViewCell = UITableViewCell(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        tableViewCell.backgroundColor = UIColor.redColor()
        return tableViewCell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
