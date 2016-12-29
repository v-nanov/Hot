//
//  DishModel.swift
//  Hot
//
//  Created by 周欣 on 2016/12/29.
//  Copyright © 2016年 zhou. All rights reserved.
//

import Foundation

struct DishModel {
    let dishID: String
    let dishName: String
    let dishPrice: String
    let dishUnit: String
    let dishCount: Int?
    
    let dishHalfID: String?
    let dishHalfName: String?
    let dishHalfPrice: String?
    let dishHalfUnit: String?
    let dishhalfCount: Int?
    
    let dishPicUrl: String
    let dishBigPicUrl: String
    let dishMidPicUrl: String
    let dishSmallPicUrl: String
    
    let dishIsPopular: Bool
    let dishIsSellout: Bool
    let dishIsTopped: Bool
    let dishIsImageUpdate: Bool
    let dishIsFree: Bool
    
    let dishKey: String
    let dishType: String?
    let type: String //套菜
    let dishSourceInfo: String?
    let dishInnerCategory: String
    let dishInnerClass: String
    let dishGuidePrice: String
    let dishCategory: String?
    let description: String?
    let dishRemark: String?
    let dishStoreType: String
    let dishDiscountFlag: String?
    
    let dishStatus: String?
    let dishHalfIndex: String?
    let dishBatchNo: Int?
    let dishHotRate: Int?
    let dishLastUpdate: Date
    let dishAmount: Int
    let dishProvider: String
    
    let dishReserve1: String
    let dishReserve2: String
    let dishReserve3: String
    let dishReserve4: String
    let dishReserve5: String
    let dishReserve6: String
    let dishReserve7: String
    let dishReserve8: String
    let dishReserve9: String
    let dishReserve10: String
}
