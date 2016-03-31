//
//  ViewController.swift
//  MC1
//
//  Created by Hariel Giacomuzzi on 3/18/16.
//  Copyright © 2016 Giacomuzzi. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    let reuseIdentifier = "highlightsCellId"
    @IBOutlet weak var hlCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        CloudKitManager.SharedInstance.getProductsByCategory("cozinha") { (resultado) in
            for produto in resultado{
                print(produto.name!)
                print(produto.price!)
                print(produto.category!)
                print(produto.photos!)
            }
        }
        
        
        hlCollectionView.delegate = self
        hlCollectionView.dataSource = self
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(false)
//        hlCollectionView.scrollToItemAtIndexPath(NSIndexPath.init(forItem: 1, inSection: 0), atScrollPosition: .CenteredHorizontally, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 200, 0, 200)
    }

    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = hlCollectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! HighlightCell
        cell.highlightProductImage.image = UIImage(named: "running")
        print(indexPath)
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //vai para o video do produto
    }
    
    func collectionView(collectionView: UICollectionView, didHighlightItemAtIndexPath indexPath: NSIndexPath) {
        print(NSIndexPath)
    }
}

