//
//  ViewManager.swift
//  MC1
//
//  Created by Hariel Giacomuzzi on 4/1/16.
//  Copyright © 2016 Giacomuzzi. All rights reserved.
//

import UIKit

enum ErrorType {
    case ERROR_TYPE_SAVE_SHOP
    case ERROR_TYPE_LOAD_PRODUCTS
}

class ViewManager: NSObject {
    static let sharedInstance : ViewManager = ViewManager()
    
    var activeView : UIViewController?
    private let messageView = UIView()
    
    func displayErrorMessage(message : String, retry: (Void -> Void)?){
        let alert = UIAlertController(title: "Oops :/", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let actionCancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
        alert.addAction(actionCancel)
        if retry != nil {
            let actionRetry = UIAlertAction(title: "Tentar Novamente", style: UIAlertActionStyle.Default) { (action) in
                retry!()
            }
            alert.addAction(actionRetry)
        }
        dispatch_async(dispatch_get_main_queue()) {
            ViewManager.sharedInstance.activeView!.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func notification(message : String){
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
                        _ = NSTimer.scheduledTimerWithTimeInterval(4.0, target: self, selector: #selector(ViewManager.undoNotification), userInfo: nil, repeats: false)
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
}
