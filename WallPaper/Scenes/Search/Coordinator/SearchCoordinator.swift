//
//  SearchCoordinator.swift
//  WallPaper
//
//  Created by LiQi on 2020/4/29.
//  Copyright © 2020 Qire. All rights reserved.
//

import Foundation
import Swinject

protocol SearchCoordinatorDelegate: AnyObject {
    func searchDidClose(coordinator: SearchCoordinator)
}

final class SearchCoordinator: NavigationCoordinator {
    
    let container: Container
    let navigationController: UINavigationController
    let parentController: UIViewController
    var searchPlaceHolder: String?
    
    weak var delegate: SearchCoordinatorDelegate?
    
    init(container: Container, parentController: UIViewController) {
        self.container = container
        self.parentController = parentController
        self.navigationController = NavigationController()
    }
    
    func start() {
        let login = container.resolve(SearchViewController.self)!
        login.placeHolder = searchPlaceHolder
        login.delegate = self
//        let nav = NavigationController(rootViewController: login)
        navigationController.modalTransitionStyle = .crossDissolve;
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.pushViewController(login, animated: false)
        parentController.tabBarController?.present(navigationController, animated: false, completion: nil)
    }
    
    /// 详情
    private func showWallPaper(service: WallPaperService, jsonDict:[[String: Any]],  defaultImg: UIImage?) {
        let wallPaper = container.resolve(WallPaperViewController.self, arguments: service, jsonDict)!
        wallPaper.defaultImg = defaultImg
        navigationController.pushViewController(wallPaper)
    }
    
}

extension SearchCoordinator: SearchViewControllerDelegate {
    
    func searchShowWallPaper(controller: SearchViewController, model: WallPaperInfoModel, image: UIImage?, sortId: Int, kindId: Int, colorId: Int, search: String) {
        let dict:[[String: Any]] = [[
            "page": Int(model.page) ?? 0,
            "id": model.id ?? 0
            ]]
        let service = SearchWallPaperService(sortId: sortId, kindId: kindId, colorId: colorId, search: search)
        showWallPaper(service: service, jsonDict: dict, defaultImg: image)
    }
    
    func searchDidClose(controller: SearchViewController) {
        parentController.tabBarController?.dismiss(animated: false, completion: nil)
        delegate?.searchDidClose(coordinator: self)
    }
    
    
}

