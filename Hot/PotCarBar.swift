//
//  PotCarBar.swift
//  HaidilaoPadV2
//
//  Created by Jane on 01/12/2016.
//  Copyright © 2016 Hoperun. All rights reserved.
//

import UIKit
import SnapKit

protocol PotCarBarDelegate: NSObjectProtocol {
    func potCarBar(_ carBar: PotCarBar, didPressSureButton button: UIButton)
    func potCarBar(_ carBar: PotCarBar, didPressClearButton button: UIButton)
}

enum PotCarBarStyle: String {
    case labelStyle
    case buttonStyle
}

enum PotOrDishBarStyle {
    case pot
    case dish
}

class PotCarBar: UIView {
    
    var delegate: PotCarBarDelegate?
    
    init(frame: CGRect, potStyle style: PotCarBarStyle) {
        super.init(frame: frame)
        self.setupInterface(style, carStyle: .pot)
    }
    
    init(frame: CGRect, carStyle style: PotOrDishBarStyle, style labelStyle: PotCarBarStyle) {
        super.init(frame: frame)
        self.setupInterface(labelStyle, carStyle: style)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var bg: UIView = {
        var bg = UIView()
        bg.backgroundColor = UIColor.black
        bg.alpha = 0.5
        return bg
    }()
    
    lazy var carImage: UIImageView = {
        var imageView = UIImageView()
        return imageView
    }()
    
    lazy var badge: UIButton = {
        var button = UIButton()
        button.backgroundColor = UIColor.colorWithHexString("d43d3d")
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.layer.cornerRadius = 9
        button.layer.masksToBounds = true
        button.isHidden = true
        return button
    }()
    
    lazy var moneyLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = UIColor.white
        return label
    }()
    
    lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24)
        label.textColor = UIColor.white
        return label
    }()
    
    lazy var sureBtn: UIButton = {
        var button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24)
        button.backgroundColor = UIColor.colorWithHexString("d43d3d")
        button.addTarget(self, action: #selector(didPressSureButton(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var clearButton: UIButton = {
        var button = UIButton()
        button.addTarget(self, action: #selector(didPressClearButton(_:)), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    lazy var contentLabel: UILabel = {
        var label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 24)
        label.textColor = UIColor.white
        return label
    }()
    
    func setupInterface(_ style: PotCarBarStyle, carStyle  car: PotOrDishBarStyle) {
        self.addSubview(bg)
        self.addSubview(carImage)
        self.addSubview(badge)
        self.addSubview(titleLabel)
        self.addSubview(moneyLabel)
        self.addSubview(sureBtn)
        
        self.addSubview(contentLabel)
        
        switch car {
        case .dish:
            sureBtn.setTitle(NSLocalizedString("确认菜品", comment: ""), for: UIControlState())
            carImage.image = UIImage.init(named: "trolley-white")
            contentLabel.text = NSLocalizedString("请选择菜品", comment: "")
        case .pot:
            sureBtn.setTitle(NSLocalizedString("确认锅底", comment: ""), for: UIControlState())
            carImage.image = UIImage.init(named: "pot_car")
            self.addSubview(clearButton)
            clearButton.snp.makeConstraints { (make) in
                make.right.top.equalTo(self)
                make.width.equalTo(165)
                make.height.equalTo(69)
            }
        }
        
        bg.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        carImage.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(22)
            make.centerY.equalTo(self)
            switch car {
            case .dish:
                make.width.equalTo(30)
                make.height.equalTo(28)
            case .pot:
                make.width.equalTo(35)
                make.height.equalTo(27)
            }
        }
        
        badge.snp.makeConstraints { (make) in
            make.width.height.equalTo(18)
            switch car {
            case .dish:
                make.left.equalTo(carImage.snp.right).offset(-3)
                make.bottom.equalTo(carImage.snp.top).offset(5)
            case .pot:
                make.left.equalTo(carImage.snp.right).offset(-6)
                make.bottom.equalTo(carImage.snp.top).offset(9)
            }

        }
        
        moneyLabel.snp.makeConstraints { (make) in
            make.left.equalTo(carImage.snp.right).offset(14)
            make.centerY.equalTo(self)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(moneyLabel.snp.right).offset(2)
            make.centerY.equalTo(self)
        }
        
        contentLabel.snp.makeConstraints({ (make) in
            make.right.equalTo(self).offset(-35)
            make.centerY.equalTo(self)
        })
        sureBtn.snp.makeConstraints { (make) in
            make.right.top.equalTo(self)
            make.width.equalTo(165)
            make.height.equalTo(69)
        }
        
        changePotCarStyle(style)
    }
    
    func changePotCarStyle(_ style: PotCarBarStyle)  {
        switch style {
        case .labelStyle:
            self.sureBtn.isHidden = true
            self.contentLabel.isHidden = false
            self.clearButton.isHidden = false
        case .buttonStyle:
            self.sureBtn.isHidden = false
            self.contentLabel.isHidden = true
            self.clearButton.isHidden = true
        }
    }
    
    func showBadge(_ willShow: Bool, num number: Int) {
        if willShow {
            badge.isHidden = false
            badge.setTitle("\(number)", for: .normal)
        } else {
            badge.isHidden = true
        }
    }
    
    func didPressSureButton(_ button: UIButton) {
        delegate?.potCarBar(self, didPressSureButton: button)
    }
    
    func didPressClearButton(_ button: UIButton){
        delegate?.potCarBar(self, didPressClearButton: button)
    }
}
