//
//  RankViewController.swift
//  WallPaper
//
//  Created by LiQi on 2020/4/17.
//  Copyright © 2020 Qire. All rights reserved.
//

import UIKit

protocol RankViewControllerDelegate: AnyObject {
    
    func rankShowWallPaper(controller: RankViewController, model: WallPaperInfoModel, image: UIImage?, type: Int)
}

class RankViewController: ViewController {
    
    weak var delegeate: RankViewControllerDelegate?
    
    let items: [WallPaperListService] = [
        RankWeekWallPaperListService(),
        RankMonthWallPaperListService(),
        RankAllWallPaperListService()
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hbd_barTintColor = AppDefine.mainColor
        hbd_barShadowHidden = true
        navigationItem.title = "排行榜"
        
        let menuView = RankPageMenuView(frame: .init(x: 0, y: 0, width: UIDevice.screenWidth, height: 50.uiX), titles: ["周榜", "月榜", "总榜"])
        view.addSubview(menuView)
        
        let pageController = QXPageController()
        pageController.dataSource = self
        pageController.itemBar = menuView
        self.addChild(pageController)
        self.view.insertSubview(pageController.view, at: 0)
        pageController.view.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 45.uiX, left: 0, bottom: 0, right: 0))
        }
        
        menuView.pageController = pageController
    }
}

extension RankViewController: QXPageControllerDataSource {
    
    func numberOfChildViewController(in pageController: QXPageController) -> Int {
        return items.count
    }
    
    func pageController(_ pageController: QXPageController, childViewControllerAt index: Int) -> UIViewController {
        let list = WallPaperListViewController()
        let viewModel = WallPapreListViewModel(service: items[index])
        list.viewModel = viewModel
        list.itemAction = {[weak self] model, image in
            guard let self = self else { return }
            self.delegeate?.rankShowWallPaper(controller: self, model: model, image: image, type: index)
        }
        return list
    }
    
}

