//
//  DatabaseManager.swift
//  Hot
//
//  Created by 周欣 on 2016/12/29.
//  Copyright © 2016年 zhou. All rights reserved.
//

import Foundation
import SQLite

class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    let database = try! Connection((Bundle.main.bundlePath + "/OrderDishesDB.db"))
    
    /// CATEGORYID ！= 001（锅底）,008(早餐),011（套餐）,012（私人订制） 都是需要过滤的
    /// CATEGORYID 是3位的表示对外的菜品分类
    func fetchAllDishCategory() -> [[String: Any]] {
        var results = [[String: String]]()
        
        let stmt = try! database.prepare("SELECT * FROM DISHCATEGORY WHERE CATEGORYID != '001' AND CATEGORYID != '008' AND CATEGORYID != '011' AND CATEGORYID != '012' ")
        
        for row in stmt {
            var result = [String: String]()
            for (index, name) in stmt.columnNames.enumerated() {
                result[name] = (row[index] as? String) ?? ""
            }
            if result["CATEGORYID"]!.characters.count == 3 {
                results.append(result)
            }
        }
        return results
    }
    
    /// 根据大分类ID查询子分类
    /// CLASSID != '001006' (DIY锅底) 需要过滤 CATEGORYTYPE != '0' 也需要过滤
    func fetchSubCategorys(byCategroyID categoryID: String) -> [[String: Any]] {
        var results = [[String: String]]()
        
        let stmt = try! database.prepare("select * from dishclass where CLASSID != '001006' AND categoryType != '0' AND categoryid = '\(categoryID)'")
        
        for row in stmt {
            var result = [String: String]()
            for (index, name) in stmt.columnNames.enumerated() {
                result[name] = (row[index] as? String) ?? ""
            }
            results.append(result)
        }
        
        return results
    }
    
    /// 根据大分类ID查询菜品
    func fetchDishes(byCategoryID categoryID: String) -> [Any] {
        var results = [[String: String]]()
        let stmt = try! database.prepare("SELECT * FROM dish where DISHCATEGORY='\(categoryID)'")
        
        for row in stmt {
            var result = [String: String]()
            for (index, name) in stmt.columnNames.enumerated() {
                result[name] = (row[index] as? String) ?? ""
            }
            results.append(result)
        }
        return results
    }
    
    /// 根据子分类ID查询菜品
    func fetchDishes(bySubCategoryID subCategoryID: String) -> [Any] {
        var results = [[String: String]]()
        let stmt = try! database.prepare("SELECT * FROM dish where DISHTYPE='\(subCategoryID)'")
        
        for row in stmt {
            var result = [String: String]()
            for (index, name) in stmt.columnNames.enumerated() {
                result[name] = (row[index] as? String) ?? ""
            }
            results.append(result)
        }
        return results
    }
    
    func fetchAllPotCategory() -> [[String: Any]] {
        var results = [[String: String]]()
        let stmt = try! database.prepare("SELECT * FROM potTypeConfig")
        
        for row in stmt {
            var result = [String: String]()
            for (index, name) in stmt.columnNames.enumerated() {
                result[name] = "\(row[index]!)"
                if name == "COUNT" {
                    if let count = result[name] {
                        switch count {
                        case "1":
                            result["DISHTYPE"] = "001001"
                        case "2":
                            result["DISHTYPE"] = "001006"
                        case "4":
                            result["DISHTYPE"] = "012003"
                        default:
                            break
                        }
                    }
                }
            }
            result["CLASSNAME"] = result["NAME"]
            results.append(result)
        }
        return results
    }
    
    func fetchPot(byCategoryID potCategoryID: String) -> [Any] {
        
        var results = [[String: String]]()
        let stmt = try! database.prepare("SELECT * FROM dish where (DISHCATEGORY = '001' or DISHCATEGORY = '012') AND  TYPE = '单品' AND DISHTYPE = '\(potCategoryID)'")
        
        for row in stmt {
            var result = [String: String]()
            for (index, name) in stmt.columnNames.enumerated() {
                result[name] = (row[index] as? String) ?? ""
            }
            results.append(result)
        }
        return results
    }
}



