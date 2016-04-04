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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        categoriesCollectionView.delegate = self
        categoriesCollectionView.dataSource = self
        hlCollectionView.delegate = self
        hlCollectionView.dataSource = self
        
        buildInfiniteHighlightList()
    }
        
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == hlCollectionView{
            return 3 //size of highlights
        }else{
            return 4 //size of categories
        }
    }
    
    func buildInfiniteHighlightList(){
        
    }
    
    func rebuildHighlightList(){
        
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if scrollView.tag == 100{
          print("acabou decel")
            rebuildHighlightList()
        }
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if collectionView == hlCollectionView{
            let cell = hlCollectionView.dequeueReusableCellWithReuseIdentifier(REUSE_INDENTIFIER_HIGHLIGHTS, forIndexPath: indexPath) as! HighlightCollectionViewCell
            cell.highlightProductImage.image = UIImage(named: "running")
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
    
    
}