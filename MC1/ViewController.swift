//
//  ViewController.swift
//  MC1
//
//  Created by Hariel Giacomuzzi on 3/18/16.
//  Copyright © 2016 Giacomuzzi. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    
    let REUSE_INDENTIFIER_HIGHLIGHTS = "highlightsCellId"
    let REUSE_IDENTIFIERS_CATEGORIES = "categoriesCellId"
    
    @IBOutlet weak var hlCollectionView: UICollectionView!
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    var highlightedProducts = [Product]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        hlCollectionView.delegate = self
        hlCollectionView.dataSource = self
        categoriesCollectionView.delegate = self
        categoriesCollectionView.dataSource = self
        
        ViewManager.sharedInstance.activeView = self
        
        categoriesCollectionView.hidden = true
        
        CloudKitManager.SharedInstance.getHighlightProducts { (hlProds, error) in
            if let e = error {
                print("Deu pau!",e) //send alert
            }else{
                self.highlightedProducts = hlProds!
                
                print("terminou de carregar")
                dispatch_async(dispatch_get_main_queue()) {
                    self.highlightedProducts.appendContentsOf(self.highlightedProducts)
                    self.hlCollectionView.reloadData()
                    self.categoriesCollectionView.hidden = false
                    self.setNeedsFocusUpdate()

                }
            }
        }
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == hlCollectionView{
            return highlightedProducts.count //size of highlights
        }else{
            return 4 //size of categories
        }
    }
    
    func growHighlightKist(){
        
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if scrollView.tag == 100{
            print(scrollView.contentSize.width-hlCollectionView.visibleCells().first!.frame.width)
            print(scrollView.contentOffset.x , scrollView.contentSize.width-hlCollectionView.visibleCells().first!.frame.width*2)
            if scrollView.contentOffset.x >= scrollView.contentSize.width*0.7 {
                print("vai recarregar a lista")
                highlightedProducts.appendContentsOf(highlightedProducts)
                hlCollectionView.reloadData()
            }
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if collectionView == hlCollectionView{
            let cell = hlCollectionView.dequeueReusableCellWithReuseIdentifier(REUSE_INDENTIFIER_HIGHLIGHTS, forIndexPath: indexPath) as! HighlightCollectionViewCell
            if let product:Product = highlightedProducts[indexPath.row]{
                cell.productNameLabel.text = product.name
                cell.highlightProductImage.image = UIImage()
                dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)) {
                    let url = NSURL(string: product.photos![0])!
                    if let data = NSData(contentsOfURL: url){
                        if let image = UIImage(data: data){
                            dispatch_async(dispatch_get_main_queue()) {
                                cell.highlightProductImage.image = image
                            }
                        }
                    }
                }
            }
            return cell
            
        }else{
            let cell = categoriesCollectionView.dequeueReusableCellWithReuseIdentifier(REUSE_IDENTIFIERS_CATEGORIES, forIndexPath: indexPath) as! CategoriesCollectionViewCell
            cell.categoryImage.image = UIImage(named: "cat_running")
            
            return cell
        }
    }
    
    func collectionView(collectionView: UICollectionView, didUpdateFocusInContext context: UICollectionViewFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
        
        if collectionView == hlCollectionView{
            if let prevCell = context.previouslyFocusedView as? HighlightCollectionViewCell {
                prevCell.changeVisibilityNameView()
            }
            
            if let nextCell = context.nextFocusedView as? HighlightCollectionViewCell {
                nextCell.clipsToBounds = false
                nextCell.changeVisibilityNameView()
            }
            
        }else{
            if let prevCell = context.previouslyFocusedView as? CategoriesCollectionViewCell {
                prevCell.changeVisibilityNameView()
            }
            if let nextCell = context.nextFocusedView as? CategoriesCollectionViewCell {
                nextCell.clipsToBounds = false
                nextCell.changeVisibilityNameView()
            }
        }
    }
    
    //    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
    //        if cell.isKindOfClass(CategoriesCollectionViewCell){
    //            (cell as! CategoriesCollectionViewCell).resetAnimation()
    //            (cell as! CategoriesCollectionViewCell).animateToTop()
    //        }
    //    }
    
}