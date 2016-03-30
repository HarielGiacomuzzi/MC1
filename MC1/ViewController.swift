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
        CloudKitManager.SharedInstance.getProductsByCategory("cozinha") { (resultado) in
            for produto in resultado{
                print(produto["nome"])
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

