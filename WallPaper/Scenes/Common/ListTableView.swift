//
//  ListTableView.swift
//  WallPaper
//
//  Created by LiQi on 2020/4/29.
//  Copyright © 2020 Qire. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import MJRefresh

class ListTableView: UIView {
    
    let headerRefreshTrigger = PublishSubject<Void>()
    let footerRefreshTrigger = PublishSubject<Void>()
    
    // MARK: - UI
    var collectionView: UICollectionView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = AppDefine.mainColor
        setupUI()
        setupBinding()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupUI() {

        let layout = UICollectionViewFlowLayout()
        let scale: CGFloat = 275.0/165
        let width = (UIDevice.screenWidth - 45.uiX)/2.0
        layout.itemSize = .init(width: width, height: width*scale)
        layout.minimumLineSpacing = 15.uiX
        layout.minimumInteritemSpacing = 15.uiX
        layout.sectionInset = .init(top: 0, left: 15.uiX, bottom: 0, right: 15.uiX)
        collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        if #available(iOS 11, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        }
        self.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }
    
    private func setupBinding() {
        
        collectionView.mj_header = RefreshHeader(refreshingBlock: {[weak self] in
            guard let self = self else { return }
            self.headerRefreshTrigger.onNext(())
        })
        
        collectionView.mj_footer = RefreshFooter(refreshingBlock: {[weak self] in
            guard let self = self else { return }
            self.footerRefreshTrigger.onNext(())
        })
        
    }
    
}
