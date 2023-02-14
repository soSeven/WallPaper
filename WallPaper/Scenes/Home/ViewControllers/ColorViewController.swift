//
//  ColorViewController.swift
//  WallPaper
//
//  Created by LiQi on 2020/4/17.
//  Copyright © 2020 Qire. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol ColorViewControllerDelegate: AnyObject {
    
    func showWallPaperController(controller: ColorViewController, model: WallPaperInfoModel, image: UIImage?, colorId: Int)
    
}

class ColorViewController: ViewController {
    
    weak var delegate: ColorViewControllerDelegate?
    
    var viewModel: ColorViewModel!
    var items: [ColorItemModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        hbd_barTintColor = AppDefine.mainColor
        hbd_barShadowHidden = true
        navigationItem.title = "色系"
        setupBinding()
    }
    
    // MARK: - UI
    
    private func setupUI() {
        
        let menuView = ColorPageMenuView(frame: .init(x: 0, y: 0, width: UIDevice.screenWidth, height: 50.uiX), titles: items.map({$0.hex}))
        view.addSubview(menuView)
        
        let pageController = QXPageController()
        pageController.dataSource = self
        pageController.itemBar = menuView
        self.addChild(pageController)
        self.view.insertSubview(pageController.view, at: 0)
        pageController.view.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 60.uiX, left: 0, bottom: 0, right: 0))
        }

        menuView.pageController = pageController
    }
    
    // MARK: - Binding
    
    private func setupBinding() {
        
        let refresh = Observable.merge(Observable.just(()), errorBtnTap.asObservable())
        let input = ColorViewModel.Input(tap: refresh.asDriver(onErrorJustReturn: ()))
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

extension ColorViewController: QXPageControllerDataSource {

    func numberOfChildViewController(in pageController: QXPageController) -> Int {
        return items.count
    }

    func pageController(_ pageController: QXPageController, childViewControllerAt index: Int) -> UIViewController {
        let list = WallPaperListViewController()
        let colorId = items[index].id ?? 0
        let service = ColorWallPaperListService(id: colorId)
        let viewModel = WallPapreListViewModel(service: service)
        list.viewModel = viewModel
        list.itemAction = {[weak self] model, image in
            guard let self = self else { return }
            self.delegate?.showWallPaperController(controller: self, model: model, image: image, colorId: colorId)
        }
        return list
    }

}
