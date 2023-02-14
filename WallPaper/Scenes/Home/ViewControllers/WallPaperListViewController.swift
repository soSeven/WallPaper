//
//  WallPaperListViewController.swift
//  WallPaper
//
//  Created by LiQi on 2020/4/17.
//  Copyright © 2020 Qire. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class WallPaperListViewController: ViewController {
    
    var viewModel: WallPapreListViewModel!
    var wallPaperListView: WallPaperCollectionView!
    var itemAction: ((WallPaperInfoModel, UIImage?) -> ())?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.random
        setupUI()
        setupBinding()
    }
    
    deinit {
        print("deinit \(self)")
    }
    
    // MARK: - UI
    
    private func setupUI() {
        
        wallPaperListView = WallPaperCollectionView(frame: self.view.bounds)
        view.addSubview(wallPaperListView)
        wallPaperListView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        wallPaperListView.collectionView.register(cellType: WallPaperInfoCell.self)
        
        wallPaperListView.collectionView.contentInset = .init(top: 0, left: 0, bottom: 40, right: 0)

    }
    
    // MARK: - Binding
    
    private func setupBinding() {
        
        let refresh = Observable.merge(wallPaperListView.headerRefreshTrigger, errorBtnTap.asObservable(), Observable.just(()))
        let input = WallPapreListViewModel.Input(headerRefresh: refresh,
                                        footerRefresh: wallPaperListView.footerRefreshTrigger)
        let output = viewModel.transform(input: input)
        
        output.items.bind(to: wallPaperListView.itemsRelay).disposed(by: rx.disposeBag)
        
        wallPaperListView.itemSelected.bind { [weak self] indexPath in
            guard let self = self else { return }
            if indexPath.row >= output.items.value.count {
                return
            }
            let model = output.items.value[indexPath.row]
            let cell = self.wallPaperListView.collectionView.cellForItem(at: indexPath) as? WallPaperInfoCell
            self.itemAction?(model, cell?.imgView.image)
        }.disposed(by: rx.disposeBag)
        
        if let footer = wallPaperListView.collectionView.mj_footer {
            output.footerLoading.bind(to: footer.rx.refreshStatus).disposed(by: rx.disposeBag)
        }
        if let header = wallPaperListView.collectionView.mj_header {
            output.headerLoading.asObservable().bind(to: header.rx.isAnimating).disposed(by: rx.disposeBag)
        }
        
        output.firstLoading.distinctUntilChanged().bind(to: view.rx.mbHudLoaing).disposed(by: rx.disposeBag)
        output.showEmptyView.distinctUntilChanged().bind(to: rx.showEmptyView()).disposed(by: rx.disposeBag)
        output.showErrorView.distinctUntilChanged().bind(to: rx.showErrorView()).disposed(by: rx.disposeBag)
        
        
        viewModel.parsedError.bind(to: view.rx.toastError).disposed(by: rx.disposeBag)
//        viewModel.loading.asObservable().take(1).bind(to: view.rx.mbHudLoaing)
        
    }

}
