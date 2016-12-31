//
//  DishViewModel.swift
//  Hot
//
//  Created by 周欣 on 2016/12/30.
//  Copyright © 2016年 zhou. All rights reserved.
//

import UIKit

class DishViewModel: NSObject {
    class func fetchAllDish() -> [Any] {
        let bigCategorys = DatabaseManager.shared.fetchAllDishCategory()
        let results = bigCategorys.map { (bigCategory) -> [String: Any] in
            var bigCategory = bigCategory
            let subCategory = DatabaseManager.shared.fetchSubCategorys(byCategroyID: bigCategory["CATEGORYID"] as! String)
            let subResults = subCategory.map({ (subCategory) -> [String: Any] in
                var subCategory = subCategory
                let dishes = DatabaseManager.shared.fetchDishes(bySubCategoryID: subCategory["CLASSID"] as! String)
                subCategory["dishes"] = dishes
                return subCategory
            }).filter({ ($0["dishes"] as! [Any]) .count > 0 })
            bigCategory["subCategorys"] = subResults
            return bigCategory
        }.filter({ ($0["subCategorys"] as! [Any]) .count > 0 })
        return results
    }
    
    class func fetchAllPot() -> [String: Any]{
        let categates = DatabaseManager.shared.fetchAllPotCategory()
        var result = [String: Any]()
        let results = categates.map { (category) -> [String: Any] in
            var category = category
            let pots = DatabaseManager.shared.fetchPot(byCategoryID: category["DISHTYPE"] as! String)
            category["dishes"] = pots
            return category
            }.filter ({ ($0["dishes"] as! [Any]).count > 0 })
        result["subCategorys"] = results
        result["CATEGORYNAME"] = "锅底"
        return result
    }
    
    static let dishCategorys = DishViewModel.fetchAllDish() as! [[String: Any]]
    static let potCategory = DishViewModel.fetchAllPot()
}

//    class func fetchAllDish() -> [Any] {
//        var mutableBigCategorys = [Any]()
//        let bigCategorys = DatabaseManager.shared.fetchAllDishCategory()
//        for bigCategory in bigCategorys {
//            var bigCategory = bigCategory
//            var mutableSubCategorys = [Any]()
//            let subCategorys = DatabaseManager.shared.fetchSubCategorys(byCategroyID: bigCategory["CATEGORYID"] as! String)
//            for subCategory in subCategorys {
//                var subCategory = subCategory
//                let dishes = DatabaseManager.shared.fetchDishes(bySubCategoryID: subCategory["CLASSID"] as! String)
//                if dishes.count > 0 {
//                    subCategory["dishes"] = dishes
//                    mutableSubCategorys.append(subCategory)
//                }
//            }
//            if mutableSubCategorys.count > 0 {
//                bigCategory["subCategorys"] = mutableSubCategorys
//                mutableBigCategorys.append(bigCategory)
//            }
//        }
//        return mutableBigCategorys
//    }
