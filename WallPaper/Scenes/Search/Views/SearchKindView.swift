//
//  SearchKindView.swift
//  WallPaper
//
//  Created by LiQi on 2020/4/30.
//  Copyright © 2020 Qire. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SearchKindViewCell: CollectionViewCell {
    
    lazy var titleLbl: UILabel = {
        let l = UILabel()
        l.textColor = .init(hex: "#ffffff")
        l.font = .init(style: .regular, size: 14.uiX)
        l.textAlignment = .center
        return l
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        cornerRadius = 3.uiX
        contentView.addSubview(titleLbl)
        titleLbl.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class SearchKindView: UIView {

    var collectionView: UICollectionView!
    var titles: [KindItemModel]
    var selectedIndex = 0
    var action: ((Int)->())?
    
    required init(frame: CGRect, titles: [KindItemModel]) {
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
        layout.itemSize = .init(width: 100.uiX, height: 34.uiX)
        layout.minimumLineSpacing = 16.uiX
        layout.sectionInset = .init(top: 10.uiX, left: 15.uiX, bottom: 10.uiX, right: 15.uiX)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        if #available(iOS 11, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        }
        collectionView.register(cellType: SearchKindViewCell.self)
        addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupBinding() {
        
        Observable.just(titles).bind(to: collectionView.rx.items(cellIdentifier: SearchKindViewCell.reuseIdentifier, cellType: SearchKindViewCell.self)) {[weak self] (row, element, cell) in
            guard let self = self else { return }
            if self.selectedIndex == row {
                cell.backgroundColor = .init(hex: "#FF2071")
            } else {
                cell.backgroundColor = .init(hex: "#383A43")
            }
            cell.titleLbl.text = element.name
        }.disposed(by: rx.disposeBag)
        
        collectionView.rx.itemSelected.subscribe(onNext: {[weak self] indexPath in
            guard let self = self else { return }
            self.selectedIndex = indexPath.row
            self.collectionView.reloadData()
            self.action?(indexPath.row)
        }).disposed(by: rx.disposeBag)
    }
    

}
