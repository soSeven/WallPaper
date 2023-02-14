//
//  LoginCoordinator.swift
//  WallPaper
//
//  Created by LiQi on 2020/4/15.
//  Copyright © 2020 Qire. All rights reserved.
//

import Foundation
import Swinject

protocol LoginCoordinatorDelegate: AnyObject {
    
    func loginCoordinatorDidClose(coordinator: LoginCoordinator)
    
}

final class LoginCoordinator: NavigationCoordinator {
    
    weak var delegate: LoginCoordinatorDelegate?
    
    let container: Container
    var navigationController: UINavigationController
    
    init(container: Container, navigationController: UINavigationController) {
        self.container = container
        self.navigationController = navigationController
    }
    
    func start() {
        let alilogin = AliPhoneLogin(controller: navigationController)
        alilogin.delegate = self
        alilogin.show()
    }
    
    private func showLogin() {
        let service = LoginPhoneService() as PhoneService
        let viewModel = container.resolve(PhoneViewModel.self, argument: service)!
        let login = container.resolve(LoginController.self, argument: viewModel)!
        login.delegate = self
        let nav = NavigationController(rootViewController: login)
        nav.modalPresentationStyle = .overCurrentContext
        navigationController.tabBarController?.present(nav, animated: true, completion: nil)
        navigationController = nav
    }
    
}

extension LoginCoordinator: AliPhoneLoginDelegate {
    
    func aliloginShowOtherLogin() {
        showLogin()
    }
    
}

extension LoginCoordinator: LoginControllerDelegate {
    
    func shouldBindPhone(loginController: LoginController) {
        let service = BindPhoneService() as PhoneService
        let viewModel = container.resolve(PhoneViewModel.self, argument: service)!
        let phone = container.resolve(UserInfoPhoneViewController.self, argument: viewModel)!
        phone.hbd_backInteractive = false
        phone.type = .loginBind
        phone.delegate = self
        navigationController.pushViewController(phone)
    }
    
    func shouldDidClose(loginController: LoginController) {
        
        navigationController.dismiss(animated: true, completion: {
            self.delegate?.loginCoordinatorDidClose(coordinator: self)
        })
    }
    
}

extension LoginCoordinator: UserInfoPhoneViewControllerDelegate {
    
    func userInfoPhoneClickDecide(controller: UserInfoPhoneViewController, oldCode: String?) {
        
        switch controller.type {
        case .loginBind:
            navigationController.dismiss(animated: true, completion: {
                self.delegate?.loginCoordinatorDidClose(coordinator: self)
            })
        default:
            break
        }
        
    }
    
    
}
