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
    var isPlaying : Bool = true
    var aux = true
    @IBOutlet var tittleLabel: UILabel!
    @IBOutlet var textView: UITextView!
    @IBOutlet var buyButton: UIButton!
    @IBOutlet var playerView: PlayerView!
    @IBOutlet var blurView: UIVisualEffectView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = NSURL(string: "https://apollo2.dl.playstation.net/cdn/UP3643/CUSA01608_00/FREE_CONTENTpybmPpILsFglhU1zQQYf/PREVIEW_GAMEPLAY_VIDEO_109467.mp4")
        self.playerView.frame = self.view.frame
        self.playerLayer = AVPlayerLayer(player: AVPlayer(playerItem: AVPlayerItem(URL: url!)))
        self.playerLayer.frame = self.playerView.frame
        self.playerView.layer.addSublayer(self.playerLayer)
        
        let swipeRecognizerUp = UISwipeGestureRecognizer(target: self, action: #selector(swipedUp))
        swipeRecognizerUp.direction = .Up
        let swipeRecognizerDown = UISwipeGestureRecognizer(target: self, action: #selector(swipedDown))
        swipeRecognizerDown.direction = .Down
        self.view.addGestureRecognizer(swipeRecognizerUp)
        self.view.addGestureRecognizer(swipeRecognizerDown)
        
//        self.playerLayer.player!.play()
        loadProducts()
     
        let firstFocusGuide = UIFocusGuide()
        self.view.addLayoutGuide(firstFocusGuide)
        firstFocusGuide.leftAnchor.constraintEqualToAnchor(self.tittleLabel.leftAnchor).active = true
        firstFocusGuide.topAnchor.constraintEqualToAnchor(self.tittleLabel.bottomAnchor).active = true
        firstFocusGuide.heightAnchor.constraintEqualToAnchor(self.textView.heightAnchor).active = true
        firstFocusGuide.widthAnchor.constraintEqualToAnchor(self.tittleLabel.widthAnchor).active = true
        
        firstFocusGuide.preferredFocusedView = self.buyButton
    }
    
    func loadProducts(){
        CloudKitManager.SharedInstance.getHighlightProducts { (resultado, erro) in
            if erro == nil{
                dispatch_async(dispatch_get_main_queue(), {
                    let aux = resultado![0]
                    self.textView.text = aux.desc!
                    self.buyButton.titleLabel?.text = "R$ \(aux.price!)"
                    self.tittleLabel.text = aux.name!
                })
            }
            else{
                print(erro?.localizedDescription)
            }
        }
    }
    
    override func pressesBegan(presses: Set<UIPress>, withEvent event: UIPressesEvent?) {
        if isPlaying && self.playerView.areFocus {
            self.playerLayer.player?.pause()
            isPlaying = false
            return
        }
        if !isPlaying && self.playerView.areFocus{
            self.playerLayer.player?.play()
            isPlaying = true
        }
    }
    
    func swipedDown() {
        self.playerView.frame = self.view.frame
        self.playerLayer.frame = self.playerView.frame
    }
    
    func swipedUp() {
        if aux{
            self.playerView.frame = CGRect(x: 850, y: 90, width: 1000, height: 554)
            self.playerLayer.frame = CGRect(x: 0, y: 0, width: 1000, height: 554)
            self.updateFocusIfNeeded()
            aux = false
        }else{
            self.playerView.frame = self.view.frame
            self.playerLayer.frame = self.playerView.frame
            aux = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
