//
//  OrderViewController.swift
//  Hot
//
//  Created by 周欣 on 2016/12/30.
//  Copyright © 2016年 zhou. All rights reserved.
//

import UIKit
import SnapKit

class OrderViewController: UIViewController {
    
    let orderCategoryViewController = OrderCategoryViewController()
    let orderDishViewController = OrderDishViewController()
    let orderPotViewController = OrderDishViewController()
    let potCarViewController = PotCarViewController()
    
    var categoryView: UIView!
    fileprivate lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("切换", for: .normal)
        button.backgroundColor = UIColor.red
        button.addTarget(self, action: #selector(didPressButton(_:)), for: .touchUpInside)
        return button
    }()
    
    @IBOutlet weak var contentView: UIScrollView!
    var orderPotView: UIView!
    var orderDishView: UIView!
    var potCarView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        makeNavigationView()
        makeViewControllers()
        makeViews()
        makeViewLayouts()
        // Do any additional setup after loading the view.
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    func makeNavigationView() {
        makeLeftItem()
        makeRightItems()
    }
    
    func makeLeftItem() {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 150, height: 44))
        let attrTitle = NSAttributedString(string: "16号桌", attributes: [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont.systemFont(ofSize: 18)])
        button.setAttributedTitle(attrTitle, for: .normal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
    }
    
    func makeRightItems() {
        let button1 = UIButton(frame: CGRect(x: 0, y: 0, width: 150, height: 44))
        let attrTitle1 = NSAttributedString(string: "登录", attributes: [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont.systemFont(ofSize: 18)])
        button1.setAttributedTitle(attrTitle1, for: .normal)
        
        let button2 = UIButton(frame: CGRect(x: 0, y: 0, width: 150, height: 44))
        let attrTitle2 = NSAttributedString(string: "中文", attributes: [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont.systemFont(ofSize: 18)])
        button2.setAttributedTitle(attrTitle2, for: .normal)
        
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: button1), UIBarButtonItem(customView: button2)]
    }
    
    func makeViewControllers() {
        
        addChildViewController(orderCategoryViewController)
        addChildViewController(orderDishViewController)
        orderDishViewController.dataList = DishViewModel.fetchAllDish()
        orderDishViewController.type = .dish
        addChildViewController(orderPotViewController)
        orderPotViewController.dataList = [DishViewModel.fetchAllPot()]
        orderPotViewController.type = .pot
        
        addChildViewController(potCarViewController)
        
        orderCategoryViewController.delegate = self
        orderCategoryViewController.orderPotController = orderPotViewController
        orderCategoryViewController.orderDishController = orderDishViewController
        orderPotViewController.orderCategoryController = orderCategoryViewController
        orderDishViewController.orderCategoryController = orderCategoryViewController
    }
    
    func makeViews() {
        categoryView = orderCategoryViewController.view
        view.addSubview(categoryView)
        
        view.addSubview(button)
        
        contentView.isScrollEnabled = false
        
        potCarView = potCarViewController.view
        view.addSubview(potCarView)
        
        orderDishView = orderDishViewController.view
        contentView.addSubview(orderDishView)
        
        orderPotView = orderPotViewController.view
        contentView.addSubview(orderPotView)
        
    }
    
    func makeViewLayouts() {
        categoryView.snp.makeConstraints { (make) in
            make.top.equalTo(view).offset(64)
            make.left.equalTo(view)
            make.width.equalTo(144)
        }
        
        button.snp.makeConstraints { (make) in
            make.top.equalTo(categoryView.snp.bottom)
            make.left.bottom.equalTo(view)
            make.width.equalTo(categoryView)
            make.height.equalTo(60)
        }
        
        potCarView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 440, height: 69))
            make.bottom.right.equalTo(view)
        }

        orderPotView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(contentView)
            make.size.equalTo(CGSize(width: 880, height: 704))
        }
        
        orderDishView.snp.makeConstraints { (make) in
            make.top.equalTo(orderPotView.snp.bottom)
            make.left.bottom.right.equalTo(contentView)
            make.size.equalTo(CGSize(width: 880, height: 704))
        }
    }
    
    @objc func didPressButton(_ button: UIButton){
        if contentView.contentOffset.y > 0 {
            contentView.setContentOffset(CGPoint.zero, animated: true)
        }else{
            contentView.setContentOffset(CGPoint(x: 0, y: 768), animated: true)
        }
    }
}

extension OrderViewController: OrderCategoryViewControllerDelegate
{
    func orderCategoryViewController(_ controller: OrderCategoryViewController, isSelectDish: Bool) {
        if  isSelectDish {
            contentView.setContentOffset(CGPoint(x: 0, y: 768), animated: true)
        }else{
            contentView.setContentOffset(CGPoint.zero, animated: true)
        }
    }
}
