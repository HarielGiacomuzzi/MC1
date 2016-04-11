//
//  ShopHistoryProductTableViewCell.swift
//  MC1
//
//  Created by Pablo Henrique Bertaco on 4/8/16.
//  Copyright © 2016 Giacomuzzi. All rights reserved.
//

import UIKit

class ShopHistoryProductTableViewCell: UITableViewCell {
    
    let tableViewCellFrame = CGRect(x: 0, y: 0, width: 1636, height: 997)
    
    var label0:UILabel!
    var lable0Frame = CGRect(x: 72, y: 14, width: 1357, height: 37)
    var lable0Font = UIFont(name: "Menlo", size: 31)
    
    var label1:UILabel!
    var label1Frame = CGRect(x: 72, y: 54, width: 1357, height: 29)
    var label1Font = UIFont(name: "Menlo", size: 25)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.frame = self.tableViewCellFrame
        self.backgroundColor = UIColor.lightGrayColor()
        
        self.label0 = UILabel(frame: lable0Frame)
        self.label0.text = "..."
        self.contentView.addSubview(self.label0)
        
        self.label1 = UILabel(frame: label1Frame)
        self.label1.text = "..."
        self.contentView.addSubview(self.label1)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
