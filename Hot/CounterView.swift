//
//  CounterView.swift
//  HaidilaoPadV2
//
//  Created by 周欣 on 2016/11/30.
//  Copyright © 2016年 Hoperun. All rights reserved.
//

import UIKit

protocol CounterViewDelegate {
    func counterView(_ view: CounterView, didPressAddButton button: UIButton);
    func counterView(_ view: CounterView, didPressDeleteButton button: UIButton);
}

class CounterView: UIView {
    
    var delegate: CounterViewDelegate?

//    var dish = HTDishEntity()
    
    var count: Int  {
        set{
            if  newValue > 0{
                countLabel.text = "\(newValue)"
                deleteButton.isHidden = false
            }else{
                countLabel.text = ""
                deleteButton.isHidden = true
            }
        }
        get{
            if let text = countLabel.text {
                if let textInt = Int(text){
                    return textInt
                }else{
                    return 0
                }
            }else{
                return 0
            }
        }
    }

    fileprivate lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named:"deleteCount"), for: .normal)
        button.addTarget(self, action: #selector(didPressDeleteButton(_:)), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    fileprivate lazy var countLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    fileprivate lazy var addButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named:"addCount"), for: .normal)
        button.addTarget(self, action: #selector(didPressAddButton(_:)), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        makeViews()
        makeViewLayouts()
    }
    
    fileprivate func makeViews() {
        addSubview(deleteButton)
        addSubview(countLabel)
        addSubview(addButton)
    }
    
    fileprivate func makeViewLayouts() {
        deleteButton.snp.makeConstraints { (make) in
            make.top.left.bottom.equalTo(self)
            make.height.equalTo(32)
            make.size.equalTo(CGSize(width: 32, height: 32))
        }
        countLabel.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(self)
            make.left.equalTo(deleteButton.snp.right)
        }
        addButton.snp.makeConstraints { (make) in
            make.top.right.bottom.equalTo(self)
            make.width.equalTo(deleteButton.snp.width)
            make.left.equalTo(countLabel.snp.right)
        }
    }
    
    @objc fileprivate func didPressAddButton(_ button: UIButton) {
        
        deleteButton.isHidden = false
        guard let countString = countLabel.text else {
            countLabel.text = "1"
            delegate?.counterView(self, didPressAddButton: button)
            return
        }
        
        guard let count = Int(countString) else {
            countLabel.text = "1"
            delegate?.counterView(self, didPressAddButton: button)
            return
        }
        
        countLabel.text = "\(count + 1)"
        delegate?.counterView(self, didPressAddButton: button)
    }
    
    @objc fileprivate func didPressDeleteButton(_ button: UIButton) {
        
        guard let countString = countLabel.text else {
            countLabel.text = ""
            button.isHidden = true
            delegate?.counterView(self, didPressDeleteButton: button)
            return
        }
        guard let count = Int(countString) else {
            countLabel.text = ""
            button.isHidden = true
            delegate?.counterView(self, didPressDeleteButton: button)
            return
        }
        
        if count > 1 {
            countLabel.text = "\(count - 1)"
        }else{
            countLabel.text = ""
            button.isHidden = true
        }
        delegate?.counterView(self, didPressDeleteButton: button)
    }
}
