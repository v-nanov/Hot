//
//  DishCollectionViewCell.swift
//  Hot
//
//  Created by 周欣 on 2016/12/30.
//  Copyright © 2016年 zhou. All rights reserved.
//

import UIKit

class DishCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
