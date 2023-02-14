//
//  WallPaperCollectionView.swift
//  WallPaper
//
//  Created by LiQi on 2020/4/11.
//  Copyright © 2020 Qire. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import MJRefresh

class WallPaperCollectionView: UIView {
    
    let headerRefreshTrigger = PublishSubject<Void>()
    let footerRefreshTrigger = PublishSubject<Void>()
    
//    private var items = [WallPaperInfoModel]()
    let itemsRelay = BehaviorRelay<[WallPaperInfoModel]>(value: [])
    let itemSelected = PublishRelay<IndexPath>()
    let didScroll = PublishRelay<CGFloat>()
    
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

        let layout = CHTCollectionViewWaterfallLayout()
        layout.minimumColumnSpacing = 15.uiX
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
        
        collectionView.register(cellType: WallPaperInfoCell.self)
        
        collectionView.dataSource = self
        collectionView.delegate = self
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
        
        itemsRelay.subscribe(onNext: {[weak self] models in
            guard let self = self else { return }
            self.collectionView.reloadData()
        }).disposed(by: rx.disposeBag)
        
    }
    
}

extension WallPaperCollectionView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemsRelay.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let m = itemsRelay.value[indexPath.row]
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: WallPaperInfoCell.self)
        cell.bind(m)
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        didScroll.accept(scrollView.offsetY)
    }
}

extension WallPaperCollectionView: CHTCollectionViewDelegateWaterfallLayout {
    
    func collectionView(_ collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, sizeForItemAt indexPath: IndexPath!) -> CGSize {
        var scale: CGFloat = 275.0/165
        let m = itemsRelay.value[indexPath.row]
        if m.coverWidth > 0, m.coverHeight > 0 {
            scale = CGFloat(m.coverHeight) / CGFloat(m.coverWidth)
        }
        let width = (UIDevice.screenWidth - 45.uiX)/2.0

        return .init(width: width, height: width*scale)

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        itemSelected.accept(indexPath)
    }
    
}
