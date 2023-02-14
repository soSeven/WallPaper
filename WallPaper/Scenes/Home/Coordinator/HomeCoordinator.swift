//
//  HomeCoordinator.swift
//  WallPaper
//
//  Created by LiQi on 2020/4/9.
//  Copyright © 2020 Qire. All rights reserved.
//

import Foundation
import Swinject

enum HomeChildCoordinator {
    case search
}

final class HomeCoordinator: NavigationCoordinator {
    
    let container: Container
    let navigationController: UINavigationController
    
    private var childCoordinators = [HomeChildCoordinator:Coordinator]()
    
    init(container: Container, navigationController: UINavigationController) {
        self.container = container
        self.navigationController = navigationController
    }
    
    func start() {
        let home = container.resolve(HomeViewController.self)!
        home.delegate = self
        navigationController.pushViewController(home, animated: true)
    }
    
    private func showSearch(model: SearchHomeListModel?) {
        let search = SearchCoordinator(container: container, parentController: navigationController)
        search.searchPlaceHolder = model?.name
        search.delegate = self
        search.start()
        childCoordinators[.search] = search
    }
    
    /// 详情
    private func showWallPaper(service: WallPaperService, jsonDict:[[String: Any]],  defaultImg: UIImage?) {
        let wallPaper = container.resolve(WallPaperViewController.self, arguments: service, jsonDict)!
        wallPaper.defaultImg = defaultImg
        wallPaper.delegate = self
        navigationController.pushViewController(wallPaper)
    }
    
}

extension HomeCoordinator: HomeViewControllerDelegate {
    
    func showItemController(controller: HomeViewController, with type: HomeItemType) {
        switch type {
        case .rank:
            let rank = container.resolve(RankViewController.self)!
            rank.delegeate = self
            navigationController.pushViewController(rank)
        case .color:
            let color = container.resolve(ColorViewController.self)!
            color.delegate = self
            navigationController.pushViewController(color)
        case .kinds:
            let kinds = container.resolve(KindViewController.self)!
            kinds.delegate = self
            navigationController.pushViewController(kinds)
        default:
            break
        }
        
    }
    
    func homeDidSelectedItem(controller: HomeViewController, model: WallPaperInfoModel, image: UIImage?, categoryId: Int) {
        let dict:[[String: Any]] = [[
            "page": Int(model.page) ?? 0,
            "id": model.id ?? 0
            ]]
        let service = KindWallPaperService(categoryId: categoryId)
        showWallPaper(service: service, jsonDict: dict, defaultImg: image)
    }
    
    func homeDidSelectedBanner(controller: HomeViewController, model: BannerModel) {
        let web = container.resolve(WebViewController.self)!
        web.url = URL(string: model.link)
        navigationController.pushViewController(web)
    }
    
    func homeDidSearch(controller: HomeViewController, model: SearchHomeListModel?) {
        showSearch(model: model)
    }
    
}

extension HomeCoordinator: RankViewControllerDelegate {
    
    func rankShowWallPaper(controller: RankViewController, model: WallPaperInfoModel, image: UIImage?, type: Int) {
        let dict:[[String: Any]] = [[
            "page": Int(model.page) ?? 0,
            "id": model.id ?? 0
            ]]
        let service = RankWallPaperService(type: type)
        showWallPaper(service: service, jsonDict: dict, defaultImg: image)
    }
    
}

extension HomeCoordinator: ColorViewControllerDelegate {
    
    func showWallPaperController(controller: ColorViewController, model: WallPaperInfoModel, image: UIImage?, colorId: Int) {
        let dict:[[String: Any]] = [[
            "page": Int(model.page) ?? 0,
            "id": model.id ?? 0
            ]]
        let service = ColorWallPaperService(colorId: colorId)
        showWallPaper(service: service, jsonDict: dict, defaultImg: image)
    }
    
}

extension HomeCoordinator: KindViewControllerDelegate {
    
    func showWallPaperController(controller: KindViewController, model: WallPaperInfoModel, image: UIImage?, categoryId: Int) {
        let dict:[[String: Any]] = [[
            "page": Int(model.page) ?? 0,
            "id": model.id ?? 0
            ]]
        let service = KindWallPaperService(categoryId: categoryId)
        showWallPaper(service: service, jsonDict: dict, defaultImg: image)
    }
    
}

extension HomeCoordinator: SearchCoordinatorDelegate {
    
    func searchDidClose(coordinator: SearchCoordinator) {
        childCoordinators[.search] = nil
    }
    
}

extension HomeCoordinator: WallPaperViewControllerDelegate {
    
    func wallPaperShowUserHome(controller: WallPaperViewController, viewModel: WallPaperCellNodeViewModel) -> WallPaperHomeControler {
        let wallPaperHome = container.resolve(WallPaperHomeControler.self, argument: viewModel.model.userId!)!
        wallPaperHome.isAttention.bind(to: viewModel.isAttention).disposed(by: wallPaperHome.rx.disposeBag)
        return wallPaperHome
    }
    
}
