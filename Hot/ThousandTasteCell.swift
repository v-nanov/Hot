//
//  ThousandTasteCell.swift
//  Hot
//
//  Created by 周欣 on 2017/1/1.
//  Copyright © 2017年 zhou. All rights reserved.
//

import UIKit

class ThousandTasteCell: UICollectionViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var separatorLine: UIView!
    var tasteViews: [RatioView]?
    var remarkView: CheckBoxView?
    @IBOutlet weak var remarkTextView: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
