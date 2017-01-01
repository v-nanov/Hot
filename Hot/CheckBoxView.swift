//
//  CheckBoxView.swift
//  HaidilaoPadV2
//
//  Created by 周欣 on 2016/11/30.
//  Copyright © 2016年 Hoperun. All rights reserved.
//

import UIKit
import SnapKit

class CheckBoxCell: UICollectionViewCell {
    
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

class CheckBoxView: UIView {
    
    var itemWidth: CGFloat = 95
    var itemHeight: CGFloat = 26
    var maxColumn: Int = 3
    var allowsMultipleSelection: Bool = false
    var items :[String] = [String](){
        didSet{
            itemWidth = (frame.width - 64 - 3 * 6) / 3
        }
    }
    
    func getSelectIndexes() -> [Int] {
        var results = [Int]()
        if let selectedItems = collectionView.indexPathsForSelectedItems {
            for indexPath in selectedItems {
                results.append(indexPath.row)
            }
        }
        return results
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
        layout.minimumInteritemSpacing = 4
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.register(CheckBoxCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = false
        collectionView.allowsMultipleSelection = true
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

extension CheckBoxView: UICollectionViewDelegate, UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let ratioCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CheckBoxCell
        ratioCell.titleLabel.text = items[indexPath.row]
        return ratioCell
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let ratioCell = collectionView.cellForItem(at: indexPath) as! CheckBoxCell
        let item = items[indexPath.row]
        
        if ratioCell.isSelected
        {
            collectionView.deselectItem(at: indexPath, animated: false)
//            item.selected = false
            return false
        }
//        item.selected = true
        return true
    }
}
