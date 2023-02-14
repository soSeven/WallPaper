//
//  AppCoordinator.swift
//  WallPaper
//
//  Created by LiQi on 2020/4/9.
//  Copyright © 2020 Qire. All rights reserved.
//

import Swinject

protocol Coordinator: AnyObject {
    
    var container: Container { get }
    
    func start()
}

protocol NavigationCoordinator: Coordinator {
    
    var navigationController: UINavigationController { get }
    
}
