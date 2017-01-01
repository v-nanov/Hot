//
//  OrderDishViewController.swift
//  Hot
//
//  Created by 周欣 on 2016/12/30.
//  Copyright © 2016年 zhou. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class OrderDishViewController: UIViewController {
    enum OrderDishViewControllerType {
        case pot
        case dish
    }
    var type = OrderDishViewControllerType.pot
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 440, height: 232)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.sectionHeadersPinToVisibleBounds = true
        layout.headerReferenceSize = CGSize(width: 880, height: 30)
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.register(UINib(nibName: "DishCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        collectionView.register(UINib(nibName: "DishCollectionReusableHeadView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "head")
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    var dataList : [[String: Any]]!
    
    weak var orderCategoryController: OrderCategoryViewController?
    
    var subCategorys :[[String: Any]] {
        return dataList.reduce([[String: Any]](), { (result, category) -> [[String: Any]] in
            var temp = [[String: Any]]()
            temp.append(contentsOf: result)
            temp.append(contentsOf:category["subCategorys"] as! [[String: Any]])
            return temp
        })
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        makeViews()
        makeViewLayouts()
    }
    
    fileprivate func makeViews() {
        view.addSubview(collectionView)
    }
    
    fileprivate func makeViewLayouts(){
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
    }
    
    func scrollToCategoryIndexPath(_ indexPath: IndexPath)
    {
        var indexPath = indexPath
        switch type {
        case .dish:
            indexPath.section = indexPath.section - 1
        case .pot:
            break
        }
        var section = 0
        for i in 0..<indexPath.section {
            let category = dataList[i]
            section += (category["subCategorys"] as! [Any]).count
        }
        section += indexPath.item
        self.scrollToSectionHead(at: section)
    }
    
    func scrollToSectionHead(at section: Int){
        let sectionHeadHeights = section * 30
        var sectionRowsHeights = 0
        for i in 0..<section {
            let dishes = (subCategorys[i]["dishes"] as! [Any])
            sectionRowsHeights += (dishes.count + 1) / 2 * 232
        }
        collectionView.setContentOffset(CGPoint(x: 0, y: sectionHeadHeights + sectionRowsHeights) , animated: true)
    }
}

extension OrderDishViewController: UICollectionViewDelegate, UICollectionViewDataSource
{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return subCategorys.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let dishes = subCategorys[section]["dishes"] as! [[String: String]]
        return dishes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let dishCategory = subCategorys[indexPath.section]
        let headView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "head", for: indexPath) as! DishCollectionReusableHeadView
        headView.titleLabel.text = dishCategory["CLASSNAME"] as! String + "(菜品已实物为准)"
        return headView
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let dishCategory = subCategorys[indexPath.section]
        let dishes = dishCategory["dishes"] as! [[String: Any]]
        let element = dishes[indexPath.item] as! [String: String]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! DishCollectionViewCell
        cell.imageView.image = UIImage(named: "medium_" + element["DISHPICURL"]!)
        cell.nameLabel.text = element["NAME"]
        cell.priceLabel.text = element["PRICE"]
        cell.descriptionLabel.text = element["DESCRIPTION"]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let dishCategory = subCategorys[indexPath.section]
        let dishes = dishCategory["dishes"] as! [[String: Any]]
        let element = dishes[indexPath.item] as! [String: String]
        let controller = PotDetailViewController(withPotModel: element)
        controller.delegate = self
        present(controller, animated: false, completion: nil)
        
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        guard let orderCategoryController = orderCategoryController else {
            return
        }
        orderCategoryController.scrollType = .fromCollectionView
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let orderCategoryController = orderCategoryController else {
            return
        }
        switch orderCategoryController.scrollType {
        case .fromUser:
            break
        case .fromCollectionView:
            guard scrollView === collectionView else {
                return
            }
            if let indexPath = collectionView.indexPathsForVisibleItems.first{
                var indexPath = indexPath
                switch type {
                case .dish:
                    indexPath.section = indexPath.section + 3
                case .pot:
                    break
                }
                orderCategoryController.scrollToIndexPath(indexPath)
            }
        }
    }
}

extension OrderDishViewController: PotDetailViewControllerDelegate
{
    func potDetailViewController(_ controller: PotDetailViewController, didPressCloseButton button: UIButton) {
        controller.dismiss(animated: false, completion: nil)
    }
    
    func potDetailViewController(_ controller: PotDetailViewController, didPressConfirmButton button: UIButton) {
        controller.dismiss(animated: false, completion: nil)
    }
}
