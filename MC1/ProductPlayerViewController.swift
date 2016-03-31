//
//  ProductVideoViewController.swift
//  MC1
//
//  Created by Pablo Henrique Bertaco on 3/31/16.
//  Copyright © 2016 Giacomuzzi. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class ProductPlayerViewController: AVPlayerViewController {
    
    func loadView(frame:CGRect) {
        super.loadView()
        
        if let parentViewController = self.parentViewController {
            //iniciando frame com a tela inteira
            self.view.frame = frame
            parentViewController.view.addSubview(self.view)
            self.play()
        }
    }
    
    func play() {
        if let url = NSURL(string: "https://apollo2.dl.playstation.net/cdn/UP3643/CUSA01608_00/FREE_CONTENTpybmPpILsFglhU1zQQYf/PREVIEW_GAMEPLAY_VIDEO_109467.mp4") {
            
            self.player = AVPlayer(playerItem: AVPlayerItem(URL: url))
            self.player!.play()
        }
    }
}
