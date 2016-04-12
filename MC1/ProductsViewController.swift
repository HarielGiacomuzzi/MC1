//
//  ProductsViewController.swift
//  MC1
//
//  Created by Pablo Henrique Bertaco on 3/31/16.
//  Copyright © 2016 Giacomuzzi. All rights reserved.
//

import UIKit
import AVKit
import MediaPlayer
import AVFoundation

class ProductsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    private var playerLayer:AVPlayerLayer!
    var categorySelected : String?
    private var isPlaying : Bool = true
    private var numberOfPhotos = 0
    private var playlistItems = 0
    var actualProduct : Product?
    private var playlist : [Product]!
    private var playlistActive = false
    @IBOutlet var tittleLabel: UILabel!
    @IBOutlet var textView: UITextView!
    @IBOutlet var buyButton: UIButton!
    @IBOutlet var playerView: PlayerView!
    @IBOutlet var blurView: UIVisualEffectView!
    @IBOutlet var collectionView: UICollectionView!
    private var imageView : UIImageView?
    private var isFullScreen = true
    @IBOutlet var viewPlaylist: UIView!
    @IBOutlet var collectionViewPlaylist: UICollectionView!
    private let videoFocusGuide = UIFocusGuide()
    private let backFromPlaylistFocusGuide = UIFocusGuide()
    var originalImageFrame:CGRect!
    var playlistIndex = 0
    @IBOutlet var loaderIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ViewManager.sharedInstance.activeView = self
        
        loadProducts({ (success) in
            dispatch_async(dispatch_get_main_queue(), {
                self.initPlay()
                self.setupPlaylistView()
            })
        })
        
        addSwipeControls()
        
        createFocusGuide()
        TurnOffVideoFocusGuide()
        
        self.collectionView.backgroundColor = UIColor.clearColor()
        self.collectionViewPlaylist.backgroundColor = UIColor.clearColor()
        
        initialLoad()
    }
    
    func createFocusGuide(){
        let firstFocusGuide = UIFocusGuide()
        self.view.addLayoutGuide(firstFocusGuide)
        firstFocusGuide.leftAnchor.constraintEqualToAnchor(self.tittleLabel.leftAnchor).active = true
        firstFocusGuide.topAnchor.constraintEqualToAnchor(self.tittleLabel.bottomAnchor).active = true
        firstFocusGuide.heightAnchor.constraintEqualToAnchor(self.textView.heightAnchor).active = true
        firstFocusGuide.widthAnchor.constraintEqualToAnchor(self.tittleLabel.widthAnchor).active = true
        
        firstFocusGuide.preferredFocusedView = self.buyButton
        
        self.playerView.addLayoutGuide(videoFocusGuide)
        videoFocusGuide.heightAnchor.constraintEqualToConstant(100).active = true
        videoFocusGuide.bottomAnchor.constraintEqualToAnchor(self.view.topAnchor).active = true
        videoFocusGuide.widthAnchor.constraintEqualToConstant(self.view.frame.width).active = true
        
        self.playerView.addLayoutGuide(backFromPlaylistFocusGuide)
        backFromPlaylistFocusGuide.heightAnchor.constraintEqualToConstant(100).active = true
        backFromPlaylistFocusGuide.topAnchor.constraintEqualToAnchor(self.view.bottomAnchor).active = true
        backFromPlaylistFocusGuide.widthAnchor.constraintEqualToConstant(self.view.frame.width).active = true

        
        self.backFromPlaylistFocusGuide.preferredFocusedView = self.playerView
        self.videoFocusGuide.preferredFocusedView = self.collectionViewPlaylist
    }
    
    func addSwipeControls(){
        let swipeRecognizerUp = UISwipeGestureRecognizer(target: self, action: #selector(swipedUp))
        swipeRecognizerUp.direction = .Up
        let swipeRecognizerDown = UISwipeGestureRecognizer(target: self, action: #selector(swipedDown))
        swipeRecognizerDown.direction = .Down
        self.view.addGestureRecognizer(swipeRecognizerUp)
        self.view.addGestureRecognizer(swipeRecognizerDown)
    }
    
    func loadProducts(completionHandler: (success:Bool) -> Void){
        //if self.actualProduct != nil {
        CloudKitManager.SharedInstance.getProductsByCategory(self.categorySelected!, completion: { (products, error) in
            if error == nil{
                self.playlist = products
                if self.actualProduct != nil{
                    self.playlist.removeAtIndex(self.playlist.indexOf({$0.name == self.actualProduct!.name})!)
                    self.playlist.insert(self.actualProduct!, atIndex: 0)
                }
                completionHandler(success: true)
            }
            else{
                print(error?.localizedDescription)
            }
        })
        //}
    }
    
    func setNotificationCenter(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.playNextVideo), name: AVPlayerItemDidPlayToEndTimeNotification, object: self.playerLayer.player?.currentItem)
        
    }
    
    func setupPlaylistView(){
        self.playlistItems = self.playlist!.count
        self.collectionViewPlaylist.reloadData()
        self.setNeedsFocusUpdate()
        
    }
    
    @IBAction func buyButtonAction(sender: AnyObject) {
        let retry : (NSError?, Shop?) -> Void = {error, shop in
            if error == nil{
                ViewManager.sharedInstance.notification(String(format: "A compra do produto %@ foi concluída com sucesso",self.actualProduct!.name!))
            }else{
                ShoppingManager.sharedInstance.realizeNewShop(self.actualProduct!, completionHandler: { (error, shop) in
                    if error == nil {
                        print(error!.localizedDescription)
                        ViewManager.sharedInstance.displayErrorMessage(String(format:"Ooops\nA compra do produto %@ não pode ser concluída.",self.actualProduct!.name!), retry: nil)
                    }
                })
            }
        }
        
        let completion :(NSError?, Shop?) -> Void = {error,shop in
            if error == nil {
                ViewManager.sharedInstance.notification(String(format: "A compra do produto %@ foi concluída com sucesso",self.actualProduct!.name!))
            }else {
                print(error!.localizedDescription)
                ViewManager.sharedInstance.displayErrorMessage(String(format:"Ooops\nA compra do produto %@ não pode ser concluída.",self.actualProduct!.name!), retry: { Void in
                    ShoppingManager.sharedInstance.realizeNewShop(self.actualProduct!, completionHandler: retry)
                })
            }
            
        }
        
        ShoppingManager.sharedInstance.realizeNewShop(self.actualProduct!, completionHandler: completion)
    }
    
    override func pressesEnded(presses: Set<UIPress>, withEvent event: UIPressesEvent?) {
        if self.playerView.frame != self.view.frame{
            setFullScreen()
        }else{
            exitFullScreen()
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?){
        if isPlaying && self.playerView.areFocus {
            pauseVideo()
            isPlaying = false
            return
        }
        if !isPlaying && self.playerView.areFocus{
            playVideo()
            isPlaying = true
        }
    }
    
    func setDetails(){
        self.tittleLabel.text = self.actualProduct?.name
        self.textView.text = self.actualProduct?.desc
        self.buyButton.setTitle(String(format: "R$ %.2f" ,self.actualProduct!.price!), forState: .Normal)
        self.numberOfPhotos = (self.actualProduct?.photos?.count)!
        self.collectionView.reloadData()
    }
    
    
    //MARK:Video Controlls
    func setFullScreenImage(){
        self.playerView.hidden =  true
        self.blurView.hidden = true
        self.textView.hidden = true
        self.buyButton.hidden = true
        self.tittleLabel.hidden = true
        
        self.isFullScreen = true
    }
    
    
    func setFullScreen(){
        self.collectionView.hidden = true
        self.blurView.hidden = true
        self.textView.hidden = true
        self.buyButton.hidden = true
        self.tittleLabel.hidden = true
        self.viewPlaylist.hidden = true
        self.playerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.playerLayer.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        if self.imageView != nil {
            self.imageView?.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        }
        self.isFullScreen = true
    }
    
    func exitFullScreen(){
        self.playerView.frame = CGRect(x: 750, y: 190, width: 1100, height: 525)
        self.playerLayer.frame = CGRect(x: 0, y: 0, width: 1100, height: 525)
        self.collectionView.hidden = false
        self.blurView.hidden = false
        self.textView.hidden = false
        self.buyButton.hidden = false
        self.tittleLabel.hidden = false
        self.playerView.hidden = false
        if playlistActive{
            UIView.animateWithDuration(2, animations: {
                self.viewPlaylist.frame = CGRect(x: 0, y: self.view.frame.height+300, width: self.view.frame.width, height: 200)
            })
            self.playlistActive = false
            self.viewPlaylist.hidden = true
        }
        if self.imageView != nil {
            self.imageView?.frame = CGRect(x: 0, y: 0, width: 1100, height: 525)
        }
        self.isFullScreen = false
        self.updateFocusIfNeeded()
    }
    
    override func viewDidLayoutSubviews() {
        if !isFullScreen{
            self.playerView.frame = CGRect(x: 750, y: 190, width: 1100, height: 525)
            self.playerLayer.frame = CGRect(x: 0, y: 0, width: 1100, height: 525)
        }
        if playlistActive{
            self.viewPlaylist.frame = CGRect(x: 0, y: self.view.frame.height-300, width: self.view.frame.width, height: 300)
        }
    }
    
    func swipedDown() {
        if self.playerView.frame == self.view.frame && playlistActive {
            TurnOffVideoFocusGuide()
            UIView.animateWithDuration(2, animations: {
                self.viewPlaylist.frame = CGRect(x: 0, y: self.view.frame.height+300, width: self.view.frame.width, height: 200)
            })
            self.playlistActive = false
            self.viewPlaylist.hidden = true
            self.updateFocusIfNeeded()
        }
        
    }
    
    func swipedUp() {
        if self.playerView.frame == self.view.frame{
            TurnOnVideoFocusGuide()
            self.viewPlaylist.hidden = false
            UIView.animateWithDuration(1, animations: {
                self.viewPlaylist.frame = CGRect(x: 0, y: self.view.frame.height-300, width: self.view.frame.width, height: 300)
                },completion:{(success) in
                    print(self.viewPlaylist.frame)
            })
            self.playlistActive = true
            self.updateFocusIfNeeded()
        }
    }
    
    func TurnOnVideoFocusGuide(){
        videoFocusGuide.enabled = true
        backFromPlaylistFocusGuide.enabled = true
    }
    
    func TurnOffVideoFocusGuide(){
        videoFocusGuide.enabled = false
        backFromPlaylistFocusGuide.enabled = false
    }
    
    func playVideo(){
        self.playerLayer.player?.play()
    }
    
    func pauseVideo(){
        self.playerLayer.player?.pause()
    }
    
    func removeEndVideoNotification(){
        NSNotificationCenter.defaultCenter().removeObserver(self, name: AVPlayerItemDidPlayToEndTimeNotification, object: self.playerLayer.player?.currentItem)
    }
    
    func initPlay(){
        if self.playlist.count != 0 {
            self.actualProduct = self.playlist[playlistIndex]
            playlistIndex = playlistIndex.successor()
            let url = NSURL(string: (self.actualProduct?.video)!)
            if self.playerLayer != nil{
                removeEndVideoNotification()
                self.playerLayer.removeFromSuperlayer()
            }
            self.playerLayer = AVPlayerLayer(player: AVPlayer(playerItem: AVPlayerItem(URL: url!)))
            self.playerView.layer.addSublayer(self.playerLayer)
            self.setNotificationCenter()
            playVideo()
            setFullScreen()
            setDetails()
            self.loaderIndicator.stopAnimating()
        }
    }
    
    func playNextVideo(){
        if self.isFullScreen && playlistIndex < playlist.count{
            initPlay()
        }
    }
    
    //MARK:CollectionView
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionViewPlaylist {
            return self.playlistItems
        }else{
            return self.numberOfPhotos
        }
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if collectionView == self.collectionViewPlaylist{
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PlaylistCell", forIndexPath: indexPath) as! PlaylistCollectionViewCell
            cell.image.image = UIImage(data: NSData(contentsOfURL: NSURL(string: self.playlist[indexPath.row].photos![0])!)!)
            cell.product = self.playlist[indexPath.row]
            return cell
        }else{
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! detailsCell
            if self.actualProduct != nil {
                let data = NSData(contentsOfURL: NSURL(string:
                    (self.actualProduct?.photos![indexPath.row])!)!)
                cell.image.image = UIImage(data: data!)
            }
            return cell
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if collectionView == self.collectionView{
            let cellFrame = collectionView.cellForItemAtIndexPath(indexPath)?.frame
            if imageView == nil{
                let image = UIImage(data: NSData(contentsOfURL: NSURL(string: (self.actualProduct?.photos![indexPath.row])!)!)!)
                self.imageView = UIImageView(image: image)
                let pointInSuperview = self.view.convertPoint(CGPointZero, fromView:collectionView.cellForItemAtIndexPath(indexPath))
                self.imageView?.frame = cellFrame!
                originalImageFrame = self.imageView?.frame
                self.imageView?.frame.origin = pointInSuperview
                UIView.animateWithDuration(0.5, animations: {
                    self.imageView!.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
                    },completion: { (sucess) in
                        self.setFullScreenImage()
                })
                self.view.addSubview(self.imageView!)
            }else{
                UIView.animateWithDuration(0.5, animations: {
                    self.imageView!.frame = CGRectMake(self.view.convertPoint(CGPointZero, fromView:collectionView.cellForItemAtIndexPath(indexPath)).x,self.view.convertPoint(CGPointZero, fromView:collectionView.cellForItemAtIndexPath(indexPath)).y,self.originalImageFrame.width,self.originalImageFrame.height)
                    },completion: { (sucess) in
                        self.imageView?.removeFromSuperview()
                        self.imageView = nil
                        self.exitFullScreen()
                })
            }
        }
        }else if collectionView == self.collectionViewPlaylist{
            self.playNextVideo((collectionView.cellForItemAtIndexPath(indexPath) as! PlaylistCollectionViewCell).product)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
