//
//  HUDManager.swift
//  HaidilaoPadV2
//
//  Created by 周欣 on 2016/11/16.
//  Copyright © 2016年 Hoperun. All rights reserved.
//

import UIKit
import SnapKit
import MBProgressHUD

class HUDManager {
 
    class func showIndicatorMessage(_ message:String){
        if  let window = UIApplication.shared.keyWindow {
            
            let hud = MBProgressHUD.showAdded(to: window, animated: true)
            let angle =  M_PI * 2
            
            hud.transform = CGAffineTransform(rotationAngle:CGFloat(angle));
            hud.mode = .indeterminate
            hud.removeFromSuperViewOnHide = true
            hud.label.text = message
        }
    }
    
    class func hideAllIndicators() {
        if let window = UIApplication.shared.keyWindow {
            for view in window.subviews {
                if let hud = view as? MBProgressHUD {
                    if hud.mode == .indeterminate {
                        hud.hide(animated: false)
                    }
                }
            }
        }
    }
    
    //    2. 白色95%透明度；红色字体#d43d3d，搭配对勾icon（成功类）
    class func showAutoDismissSuccessMessage(_ message: String) {
        showAutoDismissMessage(message: message, type: HUDType.succeed)
    }
    //    3. 白色95%透明度；中灰字体#666666 （错误类、拒绝类）
    class func showAutoDismissFailedMessage(_ message: String) {
        showAutoDismissMessage(message: message, type: HUDType.failed)
    }
    //    4. 黑色75%透明度；白色字体#ffffff （只在提示锅底信息是使用）
    class func showAutoDismissPotMessage(_ message: String) {
        showAutoDismissMessage(message: message, type: HUDType.pot)
    }
    
    class func showAutoDismissMessage(message: String, type:HUDType) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate ,
            let window = appDelegate.window{
            let hud = MBProgressHUD(frame: UIScreen.main.bounds)
            hud.removeFromSuperViewOnHide = true
            hud.mode = .customView
            hud.bezelView.color = UIColor.clear
            hud.margin = 0
            hud.backgroundView.color = UIColor.black.withAlphaComponent(0.5)

            let customView = CustomHUDView(frame:CGRect(x: 0, y: 0, width: 350, height: 120))
            customView.type = type
            customView.titleLabel.text = message
            hud.customView = customView
            hud.minSize = CGSize(width: 350, height: 120)
            window.addSubview(hud)
            hud.show(animated: true)
            hud.hide(animated: true, afterDelay: 1.5)
        }
    }
}

enum HUDType: Int {
    case succeed = 0
    case failed
    case pot
}

class CustomHUDView: UIView {
    
    var type :HUDType = .succeed {
        didSet{
            switch self.type {
            case .succeed:
                self.backgroundColor = UIColor.white.withAlphaComponent(0.95)
                titleLabel.textColor = UIColor.colorWithHexString("d43d3d")
            case .failed:
                self.backgroundColor = UIColor.white.withAlphaComponent(0.95)
                titleLabel.textColor = UIColor.colorWithHexString("666666")
            case .pot:
                self.backgroundColor = UIColor.black.withAlphaComponent(0.75)
                titleLabel.textColor = UIColor.colorWithHexString("ffffff")
            }
        }
    }
    
    lazy var contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var iconView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named:"complete-check"))
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 26)
        label.textAlignment = .center
        
        return label
    }()
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        makeViews()
        makeViewLayouts()
    }
    
    func makeViews()  {
        switch self.type {
        case .succeed:
            addSubview(contentView)
            addSubview(iconView)
        default:
            break
        }
        addSubview(titleLabel)
    }
    
    func makeViewLayouts() {
        switch self.type {
        case .succeed:
            contentView.snp.makeConstraints({ (make) in
                make.left.equalTo(iconView.snp.left)
                make.left.greaterThanOrEqualToSuperview().offset(20)
                make.right.equalTo(titleLabel.snp.right)
                make.right.lessThanOrEqualToSuperview().offset(20)
                make.center.equalTo(self)
            })
            iconView.snp.makeConstraints({ (make) in
                make.right.equalTo(titleLabel.snp.left).offset(-10)
                make.centerY.equalTo(contentView)
            })
            titleLabel.snp.makeConstraints({ (make) in
                make.centerY.equalTo(contentView)
            })
        default:
            titleLabel.snp.makeConstraints({ (make) in
                make.edges.equalTo(self)
            })
            break
        }
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 350, height: 120)
    }
}
