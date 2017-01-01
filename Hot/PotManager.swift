////
////  PotManager.swift
////  HaidilaoPadV2
////
////  Created by 周欣 on 2016/12/2.
////  Copyright © 2016年 Hoperun. All rights reserved.
////
//
//import UIKit
//
//struct PotStruct {
//    let potEntity: HTDishEntity
//    var tastes: [[PlotTasteEntity]]?
//    var remarks: [PlotTasteEntity]?
//    var remarkText: String?
//    var isPrivate: Bool
//    
//    mutating func update(withPotStruct potStruct: PotStruct)
//    {
//        self.tastes = potStruct.tastes
//        self.remarks = potStruct.remarks
//        self.remarkText = potStruct.remarkText
//        self.isPrivate = potStruct.isPrivate
//    }
//    
//    init(potEntity: HTDishEntity, tastes: [[PlotTasteEntity]]?, remarks: [PlotTasteEntity]?, remarkText: String?) {
//        self.potEntity = potEntity
//        var isPrivate = false
//        if let remarkText = remarkText {
//            if !remarkText.isEmpty {
//                isPrivate = true
//            }
//        }
//        
//        if !isPrivate, let remarks = remarks {
//            for remark in remarks {
//                if remark.selected {
//                    isPrivate = true
//                    break
//                }
//            }
//        }
//        if let temp = tastes{
//            self.tastes = temp
//            if  !isPrivate{
//                for taste in temp {
//                    for item in taste{
//                        if item.selected && item.defult != "1"{
//                            isPrivate = true
//                        }
//                    }
//                    if isPrivate{
//                        break
//                    }
//                }
//            }
//        }else{
//            let tasteArray = DishRemarkManagement.newSearchTastetCustomizationWithkeyId(potEntity.strReserve6, andType: "1") as! [[PlotTasteEntity]]
//            for taste in tasteArray {
//                for item in taste{
//                    if  item.defult == "1"{
//                        item.selected = true
//                    }
//                }
//            }
//            self.tastes = tasteArray
//        }
//        if let remarks = remarks {
//            self.remarks = remarks
//        }else{
//            let remarkArray = DishRemarkManagement.newSearchTastetCustomizationWithkeyId(potEntity.strReserve6, andType: "2") as! [PlotTasteEntity]
//            self.remarks = remarkArray
//        }
//        self.remarkText = remarkText
//        self.isPrivate = isPrivate
//    }
//}
//
//enum PotType {
//    case single
//    case double
//    case four
//}
//
//class PotManager {
//    
//    func updatePotType(withDishCategoryEntity entity:HTDishCategoryEntity){
//        switch entity.strCategoryType {
//        case "001001":
//            potType = .single
//        case "001006":
//            potType = .double
//        case "012003":
//            potType = .four
//        default:
//            potType = .double
//        }
//    }
//
//    var potType: PotType = .double {
//        didSet{
//            NotificationCenter.default.post(name: NSNotification.Name.PotDidChangedNotification, object: nil, userInfo: nil)
//        }
//    }
//    
//    
//    static let shared = PotManager()
//    private init() {}
//
//    fileprivate var potCount: [String: Int] = [String: Int]()
//    fileprivate var potsArray: [PotStruct] = [PotStruct]()
//    func fetchAllPotsCount() -> Int{
//        return potsArray.count
//    }
//    
//    func fetchPotCount(withPotDishID dishID: String) -> Int {
//        if let count = potCount[dishID]{
//            return count
//        }else{
//            return 0
//        }
//    }
//    
//    func fetchPotCurrentCust() -> Double {
//        var totalCust = 0.0
//        for potStruct in potsArray {
//            totalCust +=  (Double(potStruct.potEntity.strPRICE) ?? 0.0)
//        }
//        return totalCust
//    }
//    
//    // 调用一次可增加一个
//    @discardableResult
//    func addPot(withPotStruct potStruct: PotStruct) -> Bool {
//        if let dishID = potStruct.potEntity.strReserve6 {
//
//            potsArray.append(potStruct)
//            if let existCount = potCount[dishID] {
//                potCount[dishID] = existCount + 1
//            }else{
//                potCount[dishID] = 1
//            }
//            NotificationCenter.default.post(name: NSNotification.Name.PotDidChangedNotification, object: nil, userInfo: nil)
//            return true
//        }else{
//            return false
//        }
//    }
//    
//    // 调用一次删除一个
//    func removePot(withPotDishID dishID: String){
//        if let existCount = potCount[dishID]{
//            if existCount > 0{
//                potCount[dishID] = existCount - 1
//                var shouldRemoveIndex = -1
//                let arrayCount = potsArray.count
//                for (index, item) in potsArray.reversed().enumerated() {
//                    if item.potEntity.strReserve6 == dishID{
//                        shouldRemoveIndex = arrayCount - 1 - index
//                        break
//                    }
//                }
//                if shouldRemoveIndex >= 0 {
//                    potsArray.remove(at: shouldRemoveIndex)
//                }else{
//                    potsArray.removeLast()
//                }
//                NotificationCenter.default.post(name: NSNotification.Name.PotDidChangedNotification, object: nil, userInfo: nil)
//            }else{
//                potCount[dishID] = 0
//            }
//        }
//    }
//    
//    func updatePots(withPotStructs potStructs: [PotStruct]){
//        cleanAllPots()
//
//        for potStruct in potStructs {
//            addPot(withPotStruct: potStruct)
//        }
//    }
//    
//    func fetchPots() -> [PotStruct]{
//        return potsArray
//    }
//    
//    func cleanAllPots(){
//        potsArray.removeAll()
//        potCount.removeAll()
//    }
//}
