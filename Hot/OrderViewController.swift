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

    override func viewDidLoad() {
        super.viewDidLoad()
        makeViewControllers()
        makeViews()
        makeViewLayouts()
        // Do any additional setup after loading the view.
    }
    
    func makeViewControllers() {
        addChildViewController(orderCategoryViewController)
        addChildViewController(orderDishViewController)
        orderDishViewController.dataList = DishViewModel.fetchAllDish() as! [[String: Any]]
        orderDishViewController.type = .dish
        addChildViewController(orderPotViewController)
        orderPotViewController.dataList = [DishViewModel.fetchAllPot()]
        orderPotViewController.type = .pot
        
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
        
        orderDishView = orderDishViewController.view
        contentView.addSubview(orderDishView)
        
        orderPotView = orderPotViewController.view
        contentView.addSubview(orderPotView)
        
    }
    
    func makeViewLayouts() {
        categoryView.snp.makeConstraints { (make) in
            make.top.left.equalTo(view)
            make.width.equalTo(144)
        }
        
        button.snp.makeConstraints { (make) in
            make.top.equalTo(categoryView.snp.bottom)
            make.left.bottom.equalTo(view)
            make.width.equalTo(categoryView)
            make.height.equalTo(60)
        }

        orderPotView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(contentView)
            make.size.equalTo(CGSize(width: 880, height: 768))
        }
        
        orderDishView.snp.makeConstraints { (make) in
            make.top.equalTo(orderPotView.snp.bottom)
            make.left.bottom.right.equalTo(contentView)
            make.size.equalTo(CGSize(width: 880, height: 768))
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
