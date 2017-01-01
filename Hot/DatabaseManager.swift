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
    func fetchAllDishCategory() -> [JSONDictionary] {
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
    func fetchSubCategorys(byCategroyID categoryID: String) -> [JSONDictionary] {
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
    
    func fetchAllPotCategory() -> [JSONDictionary] {
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
    
    
    func fetchDishTastes(byDishID dishID: String) -> [JSONDictionary] {
        let dishID = fetchTransformPotID(byPotID: dishID)
        var results = [JSONDictionary]()
        
        let stmt = try! database
                        .prepare("select * from potTasteCookingConfig where DISHID=?")
                        .run(dishID)
        
        for row in stmt {
            var result = JSONDictionary()
            for (index, name) in stmt.columnNames.enumerated() {
                result[name] = "\(row[index]!)"
            }
            let (isUse, title) = isTasteIDStillUse(result["TASTEID"] as! String, type: "1")
            if isUse {
                result["subTastes"] = fetchSortedPotSubTastes(byTasteID: result["TASTEID"] as! String)
                result["TASTETYPENAME"] = title!
                results.append(result)
            }
        }
        return results
    }
    
    /// 此处现根据锅底dishID 映射 privatepan,若存在就用这个id，不存在用dishID
    func fetchTransformPotID(byPotID potID: String) -> String {
        let temp = try? database.prepare("SELECT * FROM panprivatepanmap WHERE PAN = ?")
                                .run(potID)
        guard let stmt = temp else {
            return potID
        }
        var result: String = potID
        for row in stmt {
            for (index, name) in stmt.columnNames.enumerated() {
                if name == "PRIVATEPAN" {
                    result = "\(row[index]!)"
                    break
                }
            }
        }
        return result
    }
    
    /// 判断口味是否继续使用了,type =="1"锅底，type == "2"备注
    func isTasteIDStillUse(_ tasteID: String, type: String) -> (Bool, String?){
        let temp = try? database.prepare("select * from tasteCookingConfig where TASTETYPEID=? and TYPE=?")
            .run([tasteID, type])
        guard let stmt = temp else {
            return (false, nil)
        }
        var result: (Bool, String?) = (false, nil)
        for row in stmt {
            var title: String?
            for (index, name) in stmt.columnNames.enumerated() {
                if name == "TASTETYPENAME" {
                    title = "\(row[index]!)"
                }
            }
            result = (true, title)
            break
        }
        return result
    }
    
    func fetchSortedPotSubTastes(byTasteID tasteID: String) -> [[String:String]] {
        var results = [[String: String]]()
        let stmt = try! database
            .prepare("select * from tasteCookingDetailConfig where  TASTETYPEID= ? ORDER BY ORDERNUM")
            .run(tasteID)
        for row in stmt {
            var result = [String: String]()
            for (index, name) in stmt.columnNames.enumerated() {
                result[name] = "\(row[index]!)"
            }
            results.append(result)
        }
        return results
    }
    
    func fetchDishRemarks(byDishID dishID: String) -> [JSONDictionary] {
        let dishID = fetchTransformPotID(byPotID: dishID)
        var results = [JSONDictionary]()
        
        let stmt = try! database
            .prepare("select * from potTasteCookingConfig where DISHID=?")
            .run(dishID)
        
        for row in stmt {
            var result = JSONDictionary()
            for (index, name) in stmt.columnNames.enumerated() {
                result[name] = "\(row[index]!)"
            }
            let (isUse, _) = isTasteIDStillUse(result["TASTEID"] as! String, type: "2")
            if  isUse {
                result["subTastes"] = fetchSortedPotSubTastes(byTasteID: result["TASTEID"] as! String)
                result["TASTETYPENAME"] = "备注"
                results.append(result)
            }
        }
        return results
    }
}



