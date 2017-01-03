//
//  SectionModel.swift
//  Hot
//
//  Created by 周欣 on 2016/12/30.
//  Copyright © 2016年 zhou. All rights reserved.
//

import UIKit
import RxDataSources

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


struct RxSectionModel {
    
    var identifier = "RxSectionModel"
    var isSelected = false
    var items: [Item]
    
    var headTitle: String?
    var sectionHeadHeight = 0.0
    var footTitle: String?
    var sectionheadHeight = 0.0
    
    init(headTitle: String? = nil, items: [Item]) {
        self.headTitle = headTitle
        self.items = items
    }
}

extension RxSectionModel: SectionModelType
{
    typealias Item = RxRowModel
    init(original: RxSectionModel, items:[Item])
    {
        self = original
        self.items = items
    }
}
