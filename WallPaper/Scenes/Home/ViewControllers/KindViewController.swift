//
//  KindViewController.swift
//  WallPaper
//
//  Created by LiQi on 2020/4/17.
//  Copyright © 2020 Qire. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol KindViewControllerDelegate: AnyObject {
    
    func showWallPaperController(controller: KindViewController, model: WallPaperInfoModel, image: UIImage?, categoryId: Int)
    
}


class KindViewController: ViewController {

    var viewModel: KindViewModel!
    private var items: [KindItemModel] = []
    
    weak var delegate: KindViewControllerDelegate?
    
    private var menuView: RankPageMenuView!
    private var pageController: QXPageController!

    override func viewDidLoad() {
        super.viewDidLoad()
        hbd_barTintColor = AppDefine.mainColor
        hbd_barShadowHidden = true
        navigationItem.title = "全部分类"
        setupBinding()
    }
    
    // MARK: - UI
    
    private func setupUI() {
        
        let btn = UIButton()
        btn.setImage(UIImage(named: "classification_icon_more"), for: .normal)
        btn.sizeToFit()
        btn.contentHorizontalAlignment = .left
        let btnWidth = btn.width + 15.uiX
        btn.frame = .init(x: UIDevice.screenWidth - btnWidth, y: 0, width: btnWidth, height: 50.uiX)
        btn.rx.tap.bind {[weak self] _ in
            guard let self = self else { return }
            let kindPop = KindPopView(frame: self.view.bounds, titles: self.items.map({$0.name}), selectIndex: self.pageController.selectedIndex)
            kindPop.show(view: self.view)
            kindPop.selectedRelay.subscribe(onNext: {[weak self] index in
                guard let self = self else { return }
                self.menuView.select(index: index, with: false)
            }).disposed(by: self.rx.disposeBag)
        }.disposed(by: rx.disposeBag)
        view.addSubview(btn)
        
        let menuView = RankPageMenuView(frame: .init(x: 0, y: 0, width: UIDevice.screenWidth - btnWidth - 5.uiX, height: 50.uiX), titles: items.map({$0.name}), itemMargin: 15.uiX)
        view.addSubview(menuView)
        self.menuView = menuView
        
        let pageController = QXPageController()
        pageController.dataSource = self
        pageController.itemBar = menuView
        self.addChild(pageController)
        self.view.insertSubview(pageController.view, at: 0)
        pageController.view.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 50.uiX, left: 0, bottom: 0, right: 0))
        }
        self.pageController = pageController

        menuView.pageController = pageController
    }
    
    // MARK: - Binding
    
    private func setupBinding() {
        
        let refresh = Observable.merge(Observable.just(()), errorBtnTap.asObservable())
        let input = KindViewModel.Input(tap: refresh.asDriver(onErrorJustReturn: ()))
        let output = viewModel.transform(input: input)
        
        output.showErrorView.bind(to: rx.showErrorView()).disposed(by: rx.disposeBag)
        output.showloading.bind(to: view.rx.mbHudLoaing).disposed(by: rx.disposeBag)
        output.items.subscribe(onNext: {[weak self] colors in
            guard let self = self else { return }
            self.items = colors
            self.setupUI()
        }).disposed(by: rx.disposeBag)
        
    }


}

extension KindViewController: QXPageControllerDataSource {

    func numberOfChildViewController(in pageController: QXPageController) -> Int {
        return items.count
    }

    func pageController(_ pageController: QXPageController, childViewControllerAt index: Int) -> UIViewController {
        let list = WallPaperListViewController()
        let itemId = items[index].id ?? 0
        let service = KindWallPaperListService(id: itemId)
        let viewModel = WallPapreListViewModel(service: service)
        list.viewModel = viewModel
        list.itemAction = {[weak self] model, image in
            guard let self = self else { return }
            self.delegate?.showWallPaperController(controller: self, model: model, image: image, categoryId: itemId)
        }
        return list
    }

}
