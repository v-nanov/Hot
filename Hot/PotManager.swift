//
//  PotManager.swift
//  HaidilaoPadV2
//
//  Created by 周欣 on 2016/12/2.
//  Copyright © 2016年 Hoperun. All rights reserved.
//

import UIKit

struct PotStruct {
    let potEntity: JSONDictionary
    var tastes: [[JSONDictionary]]?
    var remarks: [JSONDictionary]?
    var remarkText: String?
    var isPrivate: Bool = false
    
    init(potEntity: JSONDictionary, tastes: [[JSONDictionary]]?, remarks: [JSONDictionary]?, remarkText: String?) {
        self.potEntity = potEntity
        self.tastes = tastes
        self.remarks = remarks
        self.remarkText = remarkText
    }
}

enum PotType {
    case single
    case double
    case four
}

class PotManager {
    
    func updatePotType(withDishCategoryEntity entity: JSONDictionary){
        switch entity["DISHCATEGORY"] as! String {
        case "001001":
            potType = .single
        case "001006":
            potType = .double
        case "012003":
            potType = .four
        default:
            potType = .double
        }
    }

    var potType: PotType = .double {
        didSet{
            NotificationCenter.default.post(name: NSNotification.Name.PotDidChangedNotification, object: nil, userInfo: nil)
        }
    }
    
    
    static let shared = PotManager()
    private init() {}

    fileprivate var potCount: [String: Int] = [String: Int]()
    fileprivate var potsArray: [PotStruct] = [PotStruct]()
    func fetchAllPotsCount() -> Int{
        return potsArray.count
    }
    
    func fetchPotCount(withPotDishID dishID: String) -> Int {
        if let count = potCount[dishID]{
            return count
        }else{
            return 0
        }
    }
    
    func fetchPotCurrentCust() -> Double {
        var totalCust = 0.0
        for potStruct in potsArray {
            totalCust +=  (Double(potStruct.potEntity["PRICE"] as! String) ?? 0.0)
        }
        return totalCust
    }
    
    // 调用一次可增加一个
    @discardableResult
    func addPot(withPotStruct potStruct: PotStruct) -> Bool {
        if let dishID = potStruct.potEntity["DISHID"] as? String {

            potsArray.append(potStruct)
            if let existCount = potCount[dishID] {
                potCount[dishID] = existCount + 1
            }else{
                potCount[dishID] = 1
            }
            NotificationCenter.default.post(name: NSNotification.Name.PotDidChangedNotification, object: nil, userInfo: nil)
            return true
        }else{
            return false
        }
    }
    
    // 调用一次删除一个
    func removePot(withPotDishID dishID: String){
        if let existCount = potCount[dishID]{
            if existCount > 0{
                potCount[dishID] = existCount - 1
                var shouldRemoveIndex = -1
                let arrayCount = potsArray.count
                for (index, item) in potsArray.reversed().enumerated() {
                    if (item.potEntity["DISHID"] as! String) == dishID{
                        shouldRemoveIndex = arrayCount - 1 - index
                        break
                    }
                }
                if shouldRemoveIndex >= 0 {
                    potsArray.remove(at: shouldRemoveIndex)
                }else{
                    potsArray.removeLast()
                }
                NotificationCenter.default.post(name: NSNotification.Name.PotDidChangedNotification, object: nil, userInfo: nil)
            }else{
                potCount[dishID] = 0
            }
        }
    }
    
    func updatePots(withPotStructs potStructs: [PotStruct]){
        cleanAllPots()

        for potStruct in potStructs {
            addPot(withPotStruct: potStruct)
        }
    }
    
    func fetchPots() -> [PotStruct]{
        return potsArray
    }
    
    func cleanAllPots(){
        potsArray.removeAll()
        potCount.removeAll()
    }
}

extension Notification.Name {
    static let PotDidChangedNotification = Notification.Name(rawValue: "PotDidChangedNotification")
}
