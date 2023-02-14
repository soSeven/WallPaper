//
//  KindPopView.swift
//  WallPaper
//
//  Created by LiQi on 2020/4/18.
//  Copyright © 2020 Qire. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Reusable

class KindPopViewItem: UICollectionViewCell, Reusable {
    
    let lbl = UILabel()
    
    override init(frame: CGRect) {
        lbl.textColor = .init(hex: "#999999")
        lbl.textAlignment = .center
        lbl.font = .init(style: .regular, size: 15.uiX)
        super.init(frame: frame)
        self.addSubview(lbl)
        lbl.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class KindPopView: UIView {
    
    private let bgBtn = UIButton()
    private var collectionView: UICollectionView!
    private let titleItems: [String]
    private var selectIndex = 0
    
    let selectedRelay = PublishRelay<Int>()
    
    required init(frame: CGRect, titles:[String], selectIndex: Int) {
        titleItems = titles
        super.init(frame: frame)
        setupUI()
        setupBinding()
        self.selectIndex = selectIndex
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show(view: UIView) {
        view.addSubview(self)
        view.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.3, animations: {
            self.collectionView.frame = .init(x: 0, y: 0, width: self.collectionView.width, height: self.collectionView.height)
            self.bgBtn.alpha = 0.6
        }, completion: { finished in
            view.isUserInteractionEnabled = true
        })
    }
    
    func hide() {
        let view = self.superview
        view?.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.3, animations: {
            self.collectionView.frame = .init(x: 0, y: -self.collectionView.height, width: self.collectionView.width, height: self.collectionView.height)
            self.bgBtn.alpha = 0
        }, completion: { finished in
            self.removeFromSuperview()
            view?.isUserInteractionEnabled = true
        })
    }
    
    // MARK: - UI
    
    private func setupUI() {
        
        bgBtn.frame = bounds
        bgBtn.backgroundColor = .init(hex: "#000000")
        bgBtn.alpha = 0
        self.addSubview(bgBtn)
        bgBtn.rx.tap.bind { [weak self] _ in
            guard let self = self else { return }
            self.hide()
        }.disposed(by: rx.disposeBag)
        
        let layout = UICollectionViewFlowLayout()
        let width = frame.width / 3.0
        let height = 41.uiX
        layout.itemSize = .init(width: width, height: height)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        var lineNumber = titleItems.count/3
        let i = titleItems.count % 3
        if i != 0 {
            lineNumber += 1
        }
        
        let collectionViewHeight = CGFloat(lineNumber) * height + 12.uiX
        let collectionViewFrame = CGRect(x: 0.uiX, y: -collectionViewHeight, width: frame.width, height: collectionViewHeight)
        collectionView = UICollectionView(frame: collectionViewFrame, collectionViewLayout: layout)
        collectionView.register(cellType: KindPopViewItem.self)
        collectionView.backgroundColor = AppDefine.mainColor
        self.addSubview(collectionView)
    }
    
    // MARK: - Binding
    
    private func setupBinding() {
        
        let items = Observable.just(titleItems)
        
        items.bind(to: collectionView.rx.items(cellIdentifier: KindPopViewItem.reuseIdentifier, cellType: KindPopViewItem.self)) {[weak self] (row, element, cell) in
            if let s = self?.selectIndex, s == row {
                cell.lbl.textColor = .init(hex: "#FF2071")
            } else {
                cell.lbl.textColor = .init(hex: "#999999")
            }
            cell.lbl.text = element
        }.disposed(by: rx.disposeBag)
        
        collectionView.rx.itemSelected.bind {[weak self] indexPath in
            guard let self = self else { return }
            self.selectedRelay.accept(indexPath.row)
            self.hide()
        }.disposed(by: rx.disposeBag)
        
    }

}
