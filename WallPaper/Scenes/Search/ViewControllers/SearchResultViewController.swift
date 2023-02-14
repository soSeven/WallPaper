//
//  SearchResultViewController.swift
//  WallPaper
//
//  Created by LiQi on 2020/4/30.
//  Copyright © 2020 Qire. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class SearchResultViewController: ViewController {
    
    var viewModel: SearchResultViewModel!
    private var dropList: ([String], [KindItemModel], [ColorItemModel])!
    
    private var chooseView: SearchChooseView!
    private var wallPaperListView = WallPaperCollectionView(frame: .zero)
    
    var searchRelay = BehaviorRelay<String>(value: "")
    var sortRelay = BehaviorRelay<Int>(value: 0)
    var kindRelay = BehaviorRelay<Int>(value: 0)
    var colorRelay = BehaviorRelay<Int>(value: 0)
    
    var showWallPaper = PublishRelay<(WallPaperInfoModel, UIImage?)>()
    var showNewWallPaper = PublishRelay<Void>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBinding()
    }
    
    // MARK: - Binding
    
    private func setupBinding() {
        
        let searchWallPaper = Observable.combineLatest(sortRelay, kindRelay, colorRelay, searchRelay).skip(1)
        let input = SearchResultViewModel.Input(search: searchWallPaper,
                                                footerRefresh: wallPaperListView.footerRefreshTrigger,
                                                requestList: Observable<Void>.just(()))
        let output = viewModel.transform(input: input)
        
        output.items.bind(to: wallPaperListView.itemsRelay).disposed(by: rx.disposeBag)
        
        wallPaperListView.itemSelected.bind { [weak self] indexPath in
            guard let self = self else { return }
            if indexPath.row >= output.items.value.count {
                return
            }
            let model = output.items.value[indexPath.row]
            let cell = self.wallPaperListView.collectionView.cellForItem(at: indexPath) as? WallPaperInfoCell
            self.showWallPaper.accept((model, cell?.imgView.image))
        }.disposed(by: rx.disposeBag)
        
        if let footer = wallPaperListView.collectionView.mj_footer {
            output.footerLoading.bind(to: footer.rx.refreshStatus).disposed(by: rx.disposeBag)
        }
        
        output.firstLoading.distinctUntilChanged().bind(to: view.rx.mbHudLoaing).disposed(by: rx.disposeBag)
        output.showEmptyView.distinctUntilChanged().bind(to: rx.showEmptyView(title: "呜呜，没有相关内容", btnTitle: "我想要这类壁纸", btnTap: showNewWallPaper, inset: .init(top: 30.uiX, left: 0, bottom: 0, right: 0))).disposed(by: rx.disposeBag)
        output.showErrorView.distinctUntilChanged().bind(to: rx.showErrorView(inset: .init(top: 30.uiX, left: 0, bottom: 0, right: 0))).disposed(by: rx.disposeBag)
        
        viewModel.parsedError.bind(to: view.rx.toastError).disposed(by: rx.disposeBag)
        
        output.list.subscribe(onNext: { [weak self] list in
            guard let self = self else { return }
            self.dropList = list
            self.setupUI()
        }).disposed(by: rx.disposeBag)
    }
    
    // MARK: - UI
    
    private func setupUI() {
        
        let chooseBtn1 = SearchChooseBtn()
        chooseBtn1.titleLbl.text = "按热度"
        let titles = dropList.0
        let sortView = SearchSortView(frame: .init(x: 0, y: 0, width: 0, height: 90.uiX), titles: titles)
        sortView.action = { [unowned chooseBtn1, weak self] idx in
            guard let self = self else { return }
            chooseBtn1.titleLbl.text = titles[idx]
            self.sortRelay.accept(idx)
            self.chooseView.dimiss()
        }
        chooseBtn1.containerView = sortView
        
        let chooseBtn2 = SearchChooseBtn()
        chooseBtn2.titleLbl.text = "全部分类"
        let kind = dropList.1
        var line = kind.count / 3
        if kind.count % 3 != 0 {
            line += 1
        }
        let kindViewHeight = CGFloat.minimum(300.uiX, CGFloat(line) * (50.uiX)) + 20.uiX
        let kindView = SearchKindView(frame: .init(x: 0, y: 0, width: 0, height:  kindViewHeight), titles: kind)
        kindView.action = { [unowned chooseBtn2, weak self] idx in
            guard let self = self else { return }
            chooseBtn2.titleLbl.text = kind[idx].name
            self.kindRelay.accept(kind[idx].id)
            self.chooseView.dimiss()
        }
        chooseBtn2.containerView = kindView
        
        let chooseBtn3 = SearchChooseBtn()
        chooseBtn3.titleLbl.text = "全部色系"
        let colors = dropList.2
        var colorLine = colors.count / 5
        if colors.count % 5 != 0 {
            colorLine += 1
        }
        let colorViewHeight = CGFloat.minimum(300.uiX, CGFloat(colorLine) * (55.uiX)) + 20.uiX
        let colorView = SearchColorView(frame: .init(x: 0, y: 0, width: 0, height: colorViewHeight), titles: colors)
        colorView.action = { [unowned chooseBtn3, weak self] idx in
            guard let self = self else { return }
            chooseBtn3.titleLbl.text = colors[idx].name
            self.colorRelay.accept(colors[idx].id)
            self.chooseView.dimiss()
        }
        chooseBtn3.containerView = colorView
        
        chooseView = SearchChooseView(frame: .zero, chooseBtns: [chooseBtn1, chooseBtn2, chooseBtn3])
        view.addSubview(chooseView)
        chooseView.containerView.backgroundColor = AppDefine.mainColor
        chooseView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(30.uiX)
        }
        
        wallPaperListView.collectionView.mj_header?.isHidden = true
        view.addSubview(wallPaperListView)
        wallPaperListView.snp.makeConstraints { make in
            make.top.equalTo(chooseView.snp.bottom)
            make.bottom.left.right.equalToSuperview()
        }
        wallPaperListView.collectionView.register(cellType: WallPaperInfoCell.self)
        
        wallPaperListView.collectionView.contentInset = .init(top: 0, left: 0, bottom: 40, right: 0)
    }

}
