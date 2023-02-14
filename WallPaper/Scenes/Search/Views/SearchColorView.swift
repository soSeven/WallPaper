//
//  SearchColorView.swift
//  WallPaper
//
//  Created by LiQi on 2020/5/6.
//  Copyright © 2020 Qire. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class SearchColorViewAllCell: CollectionViewCell, ColorPageItemSelect {
    
    let colorView = UIView()
    let innerView = UIView()
    let lbl = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(innerView)
        self.clipsToBounds = true
        lbl.text = "全部"
        lbl.font = .init(style: .regular, size: 11.uiX)
        innerView.backgroundColor = .init(hex: "#999999")
        colorView.backgroundColor = AppDefine.mainColor
        innerView.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 2.uiX, left: 2.uiX, bottom: 2.uiX, right: 2.uiX))
        }
        self.addSubview(colorView)
        colorView.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 4.uiX, left: 4.uiX, bottom: 4.uiX, right: 4.uiX))
        }
        self.addSubview(lbl)
        lbl.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        colorView.layer.cornerRadius = (self.width/2.0 - 4.uiX)
        innerView.layer.cornerRadius = (self.width/2.0 - 2.uiX)
        layer.cornerRadius = self.width/2.0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSelect(selected: Bool) {
        if selected {
            lbl.textColor = .init(hex: "#FF2071")
            backgroundColor = .init(hex: "#FF2071")
            innerView.backgroundColor = AppDefine.mainColor
        } else {
            lbl.textColor = .init(hex: "#999999")
            innerView.backgroundColor = .init(hex: "#999999")
            backgroundColor = .clear
        }
    }
    
}

class SearchColorViewCell: CollectionViewCell, ColorPageItemSelect {
    
    let colorView = UIView()
    let innerView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(innerView)
        self.clipsToBounds = true
        innerView.backgroundColor = AppDefine.mainColor
        colorView.backgroundColor = .white
        innerView.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 2.uiX, left: 2.uiX, bottom: 2.uiX, right: 2.uiX))
        }
        self.addSubview(colorView)
        colorView.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 4.uiX, left: 4.uiX, bottom: 4.uiX, right: 4.uiX))
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        colorView.layer.cornerRadius = (self.width/2.0 - 4.uiX)
        innerView.layer.cornerRadius = (self.width/2.0 - 2.uiX)
        layer.cornerRadius = self.width/2.0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSelect(selected: Bool) {
        if selected {
            backgroundColor = .init(hex: "#FF2071")
        } else {
            backgroundColor = .clear
        }
    }
    
}

class SearchColorView: UIView {

    var collectionView: UICollectionView!
    var titles: [ColorItemModel]
    var selectedIndex = 0
    var action: ((Int)->())?
    
    required init(frame: CGRect, titles: [ColorItemModel]) {
        self.titles = titles
        super.init(frame: frame)
        setupCollectionView()
        setupBinding()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: 41.uiX, height: 41.uiX)
        layout.minimumLineSpacing = 16.uiX
        layout.minimumInteritemSpacing = 28.uiX
        layout.sectionInset = .init(top: 10.uiX, left: 15.uiX, bottom: 10.uiX, right: 15.uiX)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        if #available(iOS 11, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        }
        collectionView.register(cellType: SearchColorViewAllCell.self)
        collectionView.register(cellType: SearchColorViewCell.self)
        addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupBinding() {
        
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, ColorItemModel>>(configureCell:{ (dataSource, collectionView, indexPath, model) -> UICollectionViewCell in
            if indexPath.row == 0 {
                let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: SearchColorViewAllCell.self)
                cell.setupSelect(selected: self.selectedIndex == indexPath.row)
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: SearchColorViewCell.self)
                cell.setupSelect(selected: self.selectedIndex == indexPath.row)
                cell.colorView.backgroundColor = .init(hex: model.hex)
                return cell
            }
        })
        let section = SectionModel<String, ColorItemModel>(model: "color", items: titles)
        Observable.just([section]).bind(to: collectionView.rx.items(dataSource: dataSource)).disposed(by: rx.disposeBag)
        
        collectionView.rx.itemSelected.subscribe(onNext: {[weak self] indexPath in
            guard let self = self else { return }
            self.selectedIndex = indexPath.row
            self.collectionView.reloadData()
            self.action?(indexPath.row)
        }).disposed(by: rx.disposeBag)
    }
    

}
