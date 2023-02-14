//
//  AppCoordinator.swift
//  WallPaper
//
//  Created by LiQi on 2020/4/9.
//  Copyright © 2020 Qire. All rights reserved.
//

import Foundation
import Swinject

enum TabBarChildCoordinator {
    case home
    case mine
}

final class TabBarCoordinator: Coordinator {
    
    // MARK: - Properties
    let container: Container
    private let window: UIWindow
    private var tabBarController: TabBarController?
    private var childCoordinators = [TabBarChildCoordinator:Coordinator]()
    
    
    init(window: UIWindow, container: Container) {
        self.container = container
        self.window = window
    }
    
    func start() {
        tabBarController = container.resolve(TabBarController.self, argument: self)
        window.rootViewController = tabBarController
    }
    
}

extension TabBarCoordinator: TabBarControllerDelegate {
    
    func showChildControllers(tabController: TabBarController, items: [TabBarItem]) {
        for item in items {
            switch item {
            case .home:
                showHome(tabController: tabController)
            case .mine:
                showMine(tabController: tabController)
            }
        }
    }
    
    func showHome(tabController: TabBarController) {
        let nav = NavigationController()
        let tabItem = UITabBarItem(title: "首页", image: UIImage(named: "home_icon_nor01")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "home_icon_sel01")?.withRenderingMode(.alwaysOriginal))
        let attribute: [NSAttributedString.Key:Any] = [.font:UIFont(style: .regular, size: 10), .foregroundColor:UIColor(hex: "#47495F")]
        let selectedAttribute: [NSAttributedString.Key:Any] = [.font:UIFont(style: .regular, size: 10), .foregroundColor:UIColor(hex: "#FF2071")]
        tabItem.setTitleTextAttributes(attribute, for: .normal)
        tabItem.setTitleTextAttributes(selectedAttribute, for: .selected)
        nav.tabBarItem = tabItem
        let homeCoordinator = HomeCoordinator(container: container, navigationController: nav)
        homeCoordinator.start()
        childCoordinators[.home] = homeCoordinator
        tabController.addChild(nav)
        
    }
    
    func showMine(tabController: TabBarController) {
        let nav = NavigationController()
        let tabItem = UITabBarItem(title: "我的", image: UIImage(named: "home_icon_nor02")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "home_icon_sel02")?.withRenderingMode(.alwaysOriginal))
        let attribute: [NSAttributedString.Key:Any] = [.font:UIFont(style: .regular, size: 10), .foregroundColor:UIColor(hex: "#47495F")]
        let selectedAttribute: [NSAttributedString.Key:Any] = [.font:UIFont(style: .regular, size: 10), .foregroundColor:UIColor(hex: "#FF2071")]
        tabItem.setTitleTextAttributes(attribute, for: .normal)
        tabItem.setTitleTextAttributes(selectedAttribute, for: .selected)
        nav.tabBarItem = tabItem
        let mineCoordinator = MineCoordinator(container: container, navigationController: nav)
        mineCoordinator.start()
        childCoordinators[.mine] = mineCoordinator
        tabController.addChild(nav)
        
    }
    
    
}
