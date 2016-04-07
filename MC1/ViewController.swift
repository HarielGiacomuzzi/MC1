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
    let CATEGORIES = ["Fitness","Brinquedos","Beleza","Cozinha","Games"]
    
    @IBOutlet weak var hlCollectionView: UICollectionView!
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    
    var highlightedProducts = [Product]()
    var productSelected:Product!
    var categorySelected = "Fitness"
    var carouselTimer = NSTimer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        hlCollectionView.delegate = self
        hlCollectionView.dataSource = self
        categoriesCollectionView.delegate = self
        categoriesCollectionView.dataSource = self
        
        //carouselTimer = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: #selector(ViewController.nextHlItem), userInfo: nil, repeats: true)
        
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
                    self.hlCollectionView.scrollToItemAtIndexPath(NSIndexPath(forRow: (self.highlightedProducts.count)/2, inSection: 0), atScrollPosition: .None, animated: false)
                    self.setNeedsFocusUpdate()
                }
            }
        }
    }
    
    func nextHlItem(){
        let midPoint = CGPointMake(1900,hlCollectionView.frame.midY)
        print(midPoint)
        hlCollectionView.scrollToItemAtIndexPath(hlCollectionView.indexPathForItemAtPoint(midPoint)!, atScrollPosition: .None, animated: true)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == hlCollectionView{
            return highlightedProducts.count //size of highlights
        }else{
            return CATEGORIES.count //size of categories
        }
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
            cell.categoryImage.image = UIImage(named: String(format: "category_%@",CATEGORIES[indexPath.row]))
            cell.categoryNameLabel.text = CATEGORIES[indexPath.row]
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
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if collectionView == hlCollectionView{
            productSelected = highlightedProducts[indexPath.row]
            categorySelected = productSelected.category!
        }else if collectionView == categoriesCollectionView{
            categorySelected = CATEGORIES[indexPath.row]
        }
        print(indexPath.row)
        //performSegueWithIdentifier("showProductVideo", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let productsVC = segue.destinationViewController as! ProductsViewController
//        productsVC.actualProduct = productSelected
//        productsVC.categorySelected = categorySelected
    }
}