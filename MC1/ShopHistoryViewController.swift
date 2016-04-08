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
    
    let tableViewFrame = CGRect(x: 143, y: 212, width: 1636, height: 868)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let label = UILabel(frame: CGRect(x: 140, y: 77, width: 1199, height: 68))
        label.font = UIFont(name: "Menlo", size: 57)
        label.textColor = UIColor(red: 45/255, green: 91/255, blue: 148/255, alpha: 1)
        label.text = "Historic"
        self.view.addSubview(label)
        
        self.tableView = UITableView(frame: tableViewFrame, style: UITableViewStyle.Grouped)
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
        return self.products.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var tableViewCell = tableView.dequeueReusableCellWithIdentifier("cell")
            
        if tableViewCell == nil {
            tableViewCell = ShopHistoryProductTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        }
        
        if let tableViewCell = tableViewCell as? ShopHistoryProductTableViewCell {
            
            let product = self.products[indexPath.row]
            
            tableViewCell.awakeFromNib()
            tableViewCell.label0.text = product.name
            tableViewCell.label1.text = "Código " + arc4random().description
            
            return tableViewCell
        }
        
        return UITableViewCell(frame: CGRect.zero)
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
