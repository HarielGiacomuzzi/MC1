//
//  ViewManager.swift
//  MC1
//
//  Created by Hariel Giacomuzzi on 4/1/16.
//  Copyright © 2016 Giacomuzzi. All rights reserved.
//

import UIKit

class ViewManager: NSObject {
    static let sharedInstance : ViewManager = ViewManager()
    
    var activeView : UIViewController?
}
