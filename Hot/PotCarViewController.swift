//
//  PotCarViewController.swift
//  HaidilaoPadV2
//
//  Created by 周欣 on 2016/12/2.
//  Copyright © 2016年 Hoperun. All rights reserved.
//

import UIKit
import SnapKit


class PotCarViewController: UIViewController {
    
    
    lazy var potCarBar: PotCarBar = {
        let bar = PotCarBar(frame: CGRect(x: 0, y: 0, width: 165, height: 69), potStyle: PotCarBarStyle.labelStyle)
        bar.delegate = self
        return bar
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didReceivePotDidChangeNotification(_:)), name: NSNotification.Name.PotDidChangedNotification, object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeViews()
        makeViewLayouts()
    }
    
    func makeViews(){
        view.addSubview(potCarBar)
        potCarBar.delegate = self
    }
    
    func makeViewLayouts(){
        potCarBar.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
    }
}

extension PotCarViewController {
    
    func didReceivePotDidChangeNotification(_ notification: Notification) {
        let count = PotManager.shared.fetchAllPotsCount()
        if  count > 0 {
            potCarBar.showBadge(true, num: count)
        }else{
            potCarBar.showBadge(false, num: 0)
        }
        
        potCarBar.changePotCarStyle(.labelStyle)
        potCarBar.moneyLabel.text = "$" + " " + "\(PotManager.shared.fetchPotCurrentCust())"
        switch PotManager.shared.potType {
        case .single:
            if  count < 1{
                potCarBar.contentLabel.text = "请选" + "1" + "个锅底"
            }else if count == 1{
                potCarBar.changePotCarStyle(.buttonStyle)
            }else{
                potCarBar.contentLabel.text = "单锅只能选1个锅底"
            }
        case .double:
            if count < 1{
                potCarBar.contentLabel.text = "请选" + "2" + "个锅底"
            }else if count < 2{
                potCarBar.contentLabel.text = "还差" + "\(2 - count)" + "个锅底"
            }else if count == 2{
                potCarBar.changePotCarStyle(.buttonStyle)
            }else{
                potCarBar.contentLabel.text = "鸳鸯锅只能选2个锅底"
            }
        case .four:
            if  count < 1{
                potCarBar.contentLabel.text = "请选" + "4" + "个锅底"
            }else if count < 4{
                potCarBar.contentLabel.text = "还差" + "\(4 - count)" + "个锅底"
            }else if count == 4{
                potCarBar.changePotCarStyle(.buttonStyle)
            }else{
                potCarBar.contentLabel.text = "四宫锅只能选4个锅底"
            }
        }
    }
}

extension PotCarViewController: PotCarBarDelegate
{
    func potCarBar(_ carBar: PotCarBar, didPressSureButton button: UIButton) {

        let potStructs: [PotStruct]? = PotManager.shared.fetchPots()
        
//        let thousandsVC =  ThousandsFlavorViewController()
//        thousandsVC.potStructs = potStructs
//        thousandsVC.modalPresentationStyle = .custom
//        self.present(thousandsVC, animated: false, completion: nil)
    }
    
    func potCarBar(_ carBar: PotCarBar, didPressClearButton button: UIButton) {
        switch PotManager.shared.potType {
        case .single:
            if  PotManager.shared.fetchAllPotsCount() > 1{
                HUDManager.showAutoDismissPotMessage(NSLocalizedString("单锅只能选择\n1个锅底哦", comment: ""))
            }
        case .double:
            if  PotManager.shared.fetchAllPotsCount() > 2{
                HUDManager.showAutoDismissPotMessage(NSLocalizedString("鸳鸯锅只能选择\n2个锅底哦", comment: ""))
            }
        case .four:
            if  PotManager.shared.fetchAllPotsCount() > 4{
                HUDManager.showAutoDismissPotMessage(NSLocalizedString("四宫锅只能选择\n4个锅底哦", comment: ""))
            }
        }
    }
    
}

//extension PotCarViewController: OrderDishOrPotViewControllerDataSource
//{
//    func orderDishOrPotViewController(_ controller: OrderDishOrPotViewController, shouldChangePotTypeCallback callback: @escaping (Bool) -> ()) {
//        if PotManager.shared.fetchAllPotsCount() > 0{
//            let label = UILabel()
//            let attrText = NSAttributedString(string: GLOBAL_LANGUAGE("切换清空当前锅底哦！"), attributes: [NSForegroundColorAttributeName: UIColor.black, NSFontAttributeName: UIFont.systemFont(ofSize: 30)])
//            label.textAlignment = .center
//            label.attributedText = attrText
//            label.backgroundColor = UIColor.white
//            let alertController = HDLAlertViewController(withTitleView: label, height: 200, leftButtonCallback: { (button) in
//                PotManager.shared.cleanAllPots()
//                callback(true)
//            }, rightButtonCallback: { (button) in
//                callback(false)
//            })
//            alertController.leftButtonTitle = GLOBAL_LANGUAGE("确认")
//            alertController.rightButtonTitle = GLOBAL_LANGUAGE("取消")
//            self.present(alertController, animated: false, completion: nil)
//        }else{
//            callback(true)
//        }
//    }
//}
