//
//  ProductsViewController.swift
//  MC1
//
//  Created by Pablo Henrique Bertaco on 3/31/16.
//  Copyright © 2016 Giacomuzzi. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class ProductsViewController: UIViewController {
    
    var playerLayer:AVPlayerLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = NSURL(string: "https://apollo2.dl.playstation.net/cdn/UP3643/CUSA01608_00/FREE_CONTENTpybmPpILsFglhU1zQQYf/PREVIEW_GAMEPLAY_VIDEO_109467.mp4")
        
        self.playerLayer = AVPlayerLayer(player: AVPlayer(playerItem: AVPlayerItem(URL: url!)))
        self.playerLayer.frame = self.view.frame
        self.view.layer.addSublayer(self.playerLayer)
        self.playerLayer.player!.play()
        
        let swipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipedUp))
        swipeRecognizer.direction = .Up
        self.view.addGestureRecognizer(swipeRecognizer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func swipedUp() {
        self.playerLayer.frame = CGRect(x: 850, y: 90, width: 1000, height: 554)
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
