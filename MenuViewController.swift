//
//  MenuViewController.swift
//  MC1
//
//  Created by Vinicius Valvassori on 13/04/16.
//  Copyright © 2016 Giacomuzzi. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITabBarDelegate {
    
    let mainView = ViewController()
    let historyView = ShopHistoryViewController()
    
    @IBOutlet weak var menuTabbar: UITabBar!
    
    @IBOutlet weak var catalogContainerView: UIView!
    @IBOutlet weak var historyContainerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuTabbar.delegate = self
        //mainView.view.frame = self.view.frame
        //self.view.addSubview(mainView.view)
        //mainView.didMoveToParentViewController(self)
        //super.viewDidLoad()
        //self.addChildViewController(ShopHistoryViewController())
        //self.transitionFromViewController(mainView, toViewController: historyView, duration: 1.0, options: .CurveEaseInOut, animations: nil, completion: nil)
        //displayContentController(mainView)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayContentController(content: UIViewController)
    {
        self.addChildViewController(content)
        content.view.frame = self.view.frame
        self.view.addSubview(content.view)
        content.didMoveToParentViewController(self)
    }
    
    override func didUpdateFocusInContext(context: UIFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
        if context.nextFocusedView != nil{
            if context.nextFocusedView!.isDescendantOfView(menuTabbar){
                UIView.animateWithDuration(1, animations: {
                    self.menuTabbar.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.menuTabbar.frame.height)
                    },completion: nil)
            }else{
                UIView.animateWithDuration(1, animations: {
                    self.menuTabbar.frame = CGRect(x: 0, y: -self.menuTabbar.frame.height, width: self.view.frame.width, height: self.menuTabbar.frame.height)
                    },completion: nil)
            }
        }
    }
    
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        if item.title != nil{
            if item.title == "Categorias"{
                UIView.animateWithDuration(0.5, delay: 0.125, options: .CurveEaseInOut, animations: {
                    self.catalogContainerView.alpha = 1.0
                    self.historyContainerView.alpha = 0.0
                    }, completion: nil)
            }else if item.title == "Histórico"{
                UIView.animateWithDuration(0.5, delay: 0.125, options: .CurveEaseInOut, animations: {
                    self.catalogContainerView.alpha = 0.0
                    self.historyContainerView.alpha = 1.0
                    }, completion: nil)
            }
        }
    }
    
    override func pressesBegan(presses: Set<UIPress>, withEvent event: UIPressesEvent?) {
        let press = presses.first
        if press!.type == .Menu{
            UIView.animateWithDuration(1, animations: {
                self.menuTabbar.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.menuTabbar.frame.height)
                },completion: {(success) in
                    print("deve mudar o foco para a tab bar")
                    self.catalogContainerView.resignFirstResponder()
                    self.historyContainerView.resignFirstResponder()
            })
        }
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
