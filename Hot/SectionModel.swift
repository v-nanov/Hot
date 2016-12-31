//
//  SectionModel.swift
//  Hot
//
//  Created by 周欣 on 2016/12/30.
//  Copyright © 2016年 zhou. All rights reserved.
//

import UIKit

class SectionModel: NSObject {
    var identifier = "SectionModel"
    var rawData: Any?
    var rows = [Any]()
    var isSelected = false
    
    var headTitle: String?
    var sectionHeadHeight = 0.0
    
    var footTitle: String?
    var sectionFootHeight = 0.0
}
