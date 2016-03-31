//
//  ProductsViewController.swift
//  MC1
//
//  Created by Pablo Henrique Bertaco on 3/31/16.
//  Copyright © 2016 Giacomuzzi. All rights reserved.
//

import UIKit

class ProductsViewController: UIViewController {
    
    var playerViewController:ProductPlayerViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.playerViewController = ProductPlayerViewController()
        
        self.addChildViewController(self.playerViewController)
        
        self.playerViewController.loadView(self.view.frame)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
