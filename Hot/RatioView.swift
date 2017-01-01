//
//  RatioView.swift
//  HaidilaoPadV2
//
//  Created by 周欣 on 2016/11/30.
//  Copyright © 2016年 Hoperun. All rights reserved.
//

import UIKit
import SnapKit

class RatioCell: UICollectionViewCell {
    
    override var isSelected: Bool{
        didSet{
            if isSelected
            {
                self.titleLabel.backgroundColor = UIColor.colorWithHexString("d43d3d").withAlphaComponent(0.05)
                self.titleLabel.textColor = UIColor.colorWithHexString("d69393")
                self.titleLabel.layer.borderColor = UIColor.colorWithHexString("d43d3d").cgColor
            }else{
                self.titleLabel.backgroundColor = UIColor.white
                self.titleLabel.textColor = UIColor.colorWithHexString("858585")
                self.titleLabel.layer.borderColor = UIColor.colorWithHexString("aeaeae").cgColor
            }
        }
    }
    
    fileprivate lazy var baseView: UIView = {
        let view = UIView()
        return view
    }()
    
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .center
        label.layer.cornerRadius = 2
        label.textColor = UIColor.colorWithHexString("858585")
        label.layer.borderColor = UIColor.colorWithHexString("aeaeae").cgColor
        label.layer.borderWidth = 1
        
        return label
    }()
    
    //MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeView()
        makeViewLayouts()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Make Views
    
    fileprivate func makeView(){
        contentView.addSubview(baseView)
        baseView.addSubview(titleLabel)
    }
    
    fileprivate func makeViewLayouts(){
        baseView.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.edges.equalTo(baseView)
        }
    }
    
}

class RatioView: UIView {

    var itemWidth: CGFloat = 95
    var itemHeight: CGFloat = 26
    var maxColumn: Int = 4
    var allowsMultipleSelection: Bool = false
    var items :[String] = [String](){
        didSet{
            let itemCount = items.count
            if itemCount <= 4{
                itemWidth = (frame.width - 64 - CGFloat((itemCount - 1) * 6)) / CGFloat(itemCount)
            }else{
                itemWidth = (frame.width - 64 - 3 * 6) / 4
            }
            for item in items {
//                if  item.defult == "1" {
//                    item.selected = true
//                }else{
//                    item.selected = false
//                }
            }
        }
    }
    
    func getSelectIndexes() -> [Int] {
        var selectIndexes = [Int]()
        if let selectedItems = collectionView.indexPathsForSelectedItems {
            for indexPath in selectedItems {
                selectIndexes.append(indexPath.row)
            }
        }
        return selectIndexes
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.black
        return label
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: self.itemWidth, height: self.itemHeight)
        layout.minimumLineSpacing = 6
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.register(RatioCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = false
        collectionView.allowsMultipleSelection = self.allowsMultipleSelection
        collectionView.backgroundColor = UIColor.clear
        return collectionView
    }()
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        makeViews()
        makeViewLayouts()
    }
    
    //MARK: - Make Views
    func makeViews() {
        addSubview(titleLabel)
        addSubview(collectionView)
    }
    
    //MARK: - Make ViewLayouts
    func makeViewLayouts() {
        titleLabel.snp.makeConstraints { (make) in
            make.top.left.equalTo(self)
            make.centerY.equalTo(self)
            make.width.equalTo(64)
        }
        collectionView.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel.snp.right)
            make.bottom.right.top.equalTo(self)
        }
    }

}

extension RatioView: UICollectionViewDelegate, UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let ratioCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! RatioCell
        ratioCell.titleLabel.text = items[indexPath.row]
//        ratioCell.isSelected = items[indexPath.row].selected
        return ratioCell
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        for (index, item) in items.enumerated() {
            let ratioCell = collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as! RatioCell
            if  indexPath.row == index{
//                item.selected = true
                ratioCell.isSelected = true
            }else{
//                item.selected = false
                ratioCell.isSelected = false
            }
        }
        return true
    }
}
