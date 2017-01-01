
//
//  PotDetailViewController.swift
//  HaidilaoPadV2
//
//  Created by 周欣 on 2016/11/30.
//  Copyright © 2016年 Hoperun. All rights reserved.
//

import UIKit

protocol PotDetailViewControllerDelegate : NSObjectProtocol {
    func potDetailViewController(_ controller: PotDetailViewController, didPressCloseButton button: UIButton)
    func potDetailViewController(_ controller: PotDetailViewController, didPressConfirmButton button: UIButton)
}

class PotDetailViewController: UIViewController {

    var completed:(()->())?
    let potModel: [String: String]!
    
    var delegate: PotDetailViewControllerDelegate?
    
    var tasteArray: [JSONDictionary]
    
    // 只取第一个
    var remarks: [JSONDictionary]
    
    //MARK: - Lazy
    
    fileprivate lazy var darkView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.6)
        return view
    }()
    
    fileprivate lazy var contentView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        return view
    }()
    
    fileprivate lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    fileprivate lazy var confirmButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.colorWithHexString("D43D3D")
        let attriTitle = NSAttributedString(string: NSLocalizedString("确定", comment: ""), attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 18),NSForegroundColorAttributeName:UIColor.white])
        button.setAttributedTitle(attriTitle, for: .normal)
        button.addTarget(self, action: #selector(didPressConfirmButton(_:)), for: .touchUpInside)
        return button
    }()
    
    fileprivate lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named:"closePot"), for: .normal)
        button.addTarget(self, action: #selector(didPressCloseButton(_:)), for: .touchUpInside)
        return button
    }()
    
    fileprivate lazy var topView: UIView = {
       let view = UIView()
        return view
    }()
    
    fileprivate lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = UIColor.white
        imageView.image = UIImage(named:"medium_" + self.potModel["DISHPICURL"]!)
        return imageView
    }()
    
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.colorWithHexString("272727")
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.text = self.potModel["NAME"]!
        return label
    }()
    
    fileprivate lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.colorWithHexString("272727")
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = self.potModel["DESCRIPTION"]!
        return label
    }()
    
    fileprivate lazy var priceLabel: UILabel = {
       let label = UILabel()
        label.textColor = UIColor.colorWithHexString("d43d3d")
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.text = "¥ " + self.potModel["PRICE"]! + " / " + self.potModel["UNIT"]!
        return label
    }()
    
    fileprivate lazy var counterView: CounterView = {
        let view = CounterView(frame: CGRect(x: 0, y: 0, width:124 ,height:32))
        view.delegate = self
        return view;
    }()
    
    var ratioViews: [RatioView] = [RatioView]()
    var checkBoxView: CheckBoxView?

    
    fileprivate lazy var textView: UITextView = {
        let textView = UITextView()
        textView.placeholder = NSLocalizedString("这里可以输入其他个性化需求", comment: "")
        textView.backgroundColor = UIColor.colorWithHexString("f9f9f9")
        textView.font = UIFont.systemFont(ofSize: 14)
        return textView
    }()
    
    init(withPotModel potModel: [String: String]){
        self.potModel = potModel
        tasteArray = DatabaseManager.shared.fetchDishTastes(byDishID: potModel["DISHID"]!)
        remarks = DatabaseManager.shared.fetchDishRemarks(byDishID: potModel["DISHID"]!)
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .custom
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeViews()
        makeViewLayouts()
    }
    
    //MARK: - Make ViewLayouts
    fileprivate func makeViews() {
        view.addSubview(darkView)
        makeContentView()
        view.addSubview(contentView)
        view.addSubview(closeButton)
    }
    
    fileprivate func makeContentView(){
        makeContainerView()
        contentView.addSubview(containerView)
        contentView.addSubview(confirmButton)
    }
    
    
    fileprivate func makeContainerView(){
        
        for item in tasteArray {
            let ratioView = makeRatioView(withModel: item)
            containerView.addSubview(ratioView)
            ratioViews.append(ratioView)
        }
        
        if remarks.count > 0 {
            let checkBoxView = makeCheckBoxView(withModel: remarks.first!)
            containerView.addSubview(checkBoxView)
            self.checkBoxView = checkBoxView
        }
        containerView.addSubview(textView)
        
        containerView.addSubview(topView)
        containerView.addSubview(iconImageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(subTitleLabel)
        containerView.addSubview(priceLabel)
        containerView.addSubview(counterView)
    }
    
    fileprivate func makeRatioView(withModel list:JSONDictionary) -> RatioView {
        let ratioView = RatioView(frame: CGRect(x: 0, y: 0, width: 400 - 52, height: 26))
        let tastes = list["subTastes"] as! [JSONDictionary]
        let strings = tastes.map { (taste) -> String in
            return taste["TASTENAME"] as! String
        }
        ratioView.items = strings
        ratioView.titleLabel.text = list["TASTETYPENAME"] as? String
        return ratioView
    }
    
    fileprivate func makeCheckBoxView(withModel list: JSONDictionary) -> CheckBoxView{
        let checkBoxView = CheckBoxView(frame: CGRect(x: 0, y: 0, width: 400 - 52, height: 26))
        let tastes = list["subTastes"] as! [JSONDictionary]
        let strings = tastes.map { (taste) -> String in
            return taste["TASTENAME"] as! String
        }
        checkBoxView.items = strings
        checkBoxView.titleLabel.text = "备注"
        return checkBoxView
    }
    
    //MARK: - Make ViewLayouts
    
    fileprivate func makeViewLayouts() {
        
        darkView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        makeContentViewLayouts()
        
        contentView.snp.makeConstraints { (make) in
            make.center.equalTo(view)
        }
        
        closeButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(contentView.snp.right)
            make.centerY.equalTo(contentView.snp.top)
            make.size.equalTo(CGSize(width: 53, height: 53))
        }
    }
    
    fileprivate func makeContentViewLayouts() {
        
        makeContainerViewLayouts()
        
        containerView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(contentView)
            make.width.equalTo(400)
        }
        
        confirmButton.snp.makeConstraints { (make) in
            make.top.equalTo(containerView.snp.bottom)
            make.height.equalTo(53)
            make.bottom.left.right.equalTo(contentView)
        }
    }
    
    fileprivate func makeContainerViewLayouts(){
        topView.snp.makeConstraints { (make) in
            make.top.right.left.equalTo(containerView)
            make.height.equalTo(1)
        }
        
        iconImageView.snp.makeConstraints { (make) in
            make.top.right.left.equalTo(containerView)
            make.height.equalTo(282)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(iconImageView.snp.bottom).offset(24)
            make.left.equalTo(containerView).offset(26)
        }
        
        subTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(9)
            make.left.equalTo(titleLabel)
        }
        
        counterView.snp.makeConstraints { (make) in
            make.right.equalTo(containerView).offset(-26)
            make.size.equalTo(CGSize(width: 124, height: 32))
            make.centerY.equalTo(priceLabel)
        }
        
        makeRemarkViewLayout(hide: true)
    }
    
    func makeRemarkViewLayout(hide: Bool){
        
        var lastView: UIView = priceLabel as UIView
        
        if hide{
            lastView = topView as UIView
            priceLabel.snp.remakeConstraints { (make) in
                make.top.equalTo(subTitleLabel.snp.bottom).offset(14)
                make.left.equalTo(titleLabel)
                make.bottom.equalTo(containerView).offset(-10)
            }
        }else{
            priceLabel.snp.remakeConstraints { (make) in
                make.top.equalTo(subTitleLabel.snp.bottom).offset(14)
                make.left.equalTo(titleLabel)
            }
        }
        
        for ratioView in ratioViews {
            ratioView.snp.remakeConstraints { (make) in
                make.left.equalTo(titleLabel)
                make.height.equalTo(26)
                make.right.equalTo(counterView)
                make.top.equalTo(lastView.snp.bottom).offset(24)
            }
            lastView = ratioView as UIView
        }
        
        checkBoxView?.snp.remakeConstraints { (make) in
            make.top.equalTo(lastView.snp.bottom).offset(14)
            make.left.right.equalTo(lastView)
            make.height.equalTo((26 + 6) * ((remarks.count - 1) / 3 + 1))
        }
        
        textView.snp.remakeConstraints { (make) in
            make.top.equalTo((checkBoxView ?? lastView).snp.bottom).offset(14)
            make.left.equalTo(containerView).offset(80)
            make.height.equalTo(55)
            make.right.equalTo(counterView)
            if hide{
                
            }else{
                make.bottom.equalTo(containerView).offset(-25)
            }
        }
    }
    
    @objc fileprivate func didPressCloseButton(_ button: UIButton){
        delegate?.potDetailViewController(self, didPressCloseButton: button)
    }
    
    @objc fileprivate func didPressConfirmButton(_ button: UIButton){
        let count = counterView.count
        var tasteResult = [JSONDictionary]()
        for (index, ratioView) in ratioViews.enumerated() {
            let selectIndexes = ratioView.getSelectIndexes()
            let tastes = tasteArray[index]["subTastes"] as! [JSONDictionary]
            for item in selectIndexes {
                tasteResult.append(tastes[item])
            }
        }

        var remarkResult = [JSONDictionary]()
        if let selectIndexes = checkBoxView?.getSelectIndexes() {
            let remark = remarks[0]["subTastes"] as! [JSONDictionary]
            for item in selectIndexes {
                remarkResult.append(remark[item])
            }
        }

        let remarkText = textView.text

        if count > 0{
            for _ in 0..<count {
                                
                let potStruct = PotStruct(potEntity: potModel, tastes: nil, remarks: remarkResult, remarkText: remarkText)
                let _ = PotManager.shared.addPot(withPotStruct: potStruct)
            }
        }
        
        delegate?.potDetailViewController(self, didPressConfirmButton: button)
    }
}

extension PotDetailViewController: CounterViewDelegate
{
    func counterView(_ view: CounterView, didPressAddButton button: UIButton) {
        if view.count == 1{
            makeRemarkViewLayout(hide: false)
            self.view.layoutIfNeeded()
        }
    }
    
    func counterView(_ view: CounterView, didPressDeleteButton button: UIButton) {
        if  view.count == 0{
            makeRemarkViewLayout(hide: true)
            self.view.layoutIfNeeded()
        }
    }
}
