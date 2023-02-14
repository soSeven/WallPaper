//
//  HelpInputMarkView.swift
//  WallPaper
//
//  Created by LiQi on 2020/4/28.
//  Copyright © 2020 Qire. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class HelpInputMarkView: UIView {
    
    var selectedId = -1
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: UIDevice.screenWidth/2.0, height: 40.uiX)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let c = UICollectionView(frame: .zero, collectionViewLayout: layout)
        c.backgroundColor = .clear
        c.register(cellType: HelpInputCell.self)
        return c
    }()
    
    required init(frame: CGRect, items: [HelpTypeModel]) {
        super.init(frame: frame)
        addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let viewModels = items.map({ i -> HelpInputCellViewModel in
            let v = HelpInputCellViewModel()
            v.name.accept(i.name)
            v.id = i.id
            return v
        })
        let array = Observable.just(viewModels)
        array.bind(to: collectionView.rx.items(cellIdentifier: HelpInputCell.reuseIdentifier, cellType: HelpInputCell.self)) { (row, element, cell) in
            cell.bind(to: element)
        }.disposed(by: rx.disposeBag)
        collectionView.rx.itemSelected.subscribe(onNext: {[weak self] indexPath in
            guard let self = self else { return }
            viewModels.filter { $0.selected.value }.forEach { $0.selected.accept(false) }
            let current = viewModels[indexPath.row]
            current.selected.accept(true)
            self.selectedId = current.id
        }).disposed(by: rx.disposeBag)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
