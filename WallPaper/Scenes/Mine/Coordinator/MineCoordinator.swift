//
//  MineCoordinator.swift
//  WallPaper
//
//  Created by LiQi on 2020/4/9.
//  Copyright © 2020 Qire. All rights reserved.
//

import Foundation
import Swinject

enum MineChildCoordinator {
    case login
}

final class MineCoordinator: NavigationCoordinator {
    
    let container: Container
    let navigationController: UINavigationController
    
    private var childCoordinators = [MineChildCoordinator:Coordinator]()
    
    init(container: Container, navigationController: UINavigationController) {
        self.container = container
        self.navigationController = navigationController
    }
    
    func start() {
        let mine = container.resolve(MineViewController.self)!
        mine.delegate = self
        navigationController.pushViewController(mine, animated: true)
    }
    
    private func showLogin() {
        let loginCoordinator = LoginCoordinator(container: container, navigationController: navigationController)
        loginCoordinator.delegate = self
        loginCoordinator.start()
        childCoordinators[.login] = loginCoordinator
    }
    
    /// 详情
    private func showWallPaper(service: WallPaperService, jsonDict:[[String: Any]],  defaultImg: UIImage?) {
        let wallPaper = container.resolve(WallPaperViewController.self, arguments: service, jsonDict)!
        wallPaper.defaultImg = defaultImg
        wallPaper.delegate = self
        navigationController.pushViewController(wallPaper)
    }
    
}
extension MineCoordinator: LoginCoordinatorDelegate {
    
    func loginCoordinatorDidClose(coordinator: LoginCoordinator) {
        childCoordinators[.login] = nil
    }
    
}

extension MineCoordinator: MineViewControllerDelegate {
    
    func mineDidSelectInfo() {
        if !UserManager.shared.isLogin {
            showLogin()
            return
        }
        let infoController = container.resolve(UserInfoViewController.self)!
        infoController.delegate = self
        navigationController.pushViewController(infoController)
    }
    
    func mineDidSelectItem(with item: MineCellViewModel) {
        
        if !UserManager.shared.isLogin {
            showLogin()
            return
        }
        
        switch item.type {
        case .setting:
            let settingController = container.resolve(SettingViewController.self)!
            settingController.delegate = self
            navigationController.pushViewController(settingController)
        case .help:
            let helpController = container.resolve(HelpViewController.self)!
            helpController.delegate = self
            navigationController.pushViewController(helpController)
        case .message:
            let messageController = container.resolve(MessageViewController.self)!
            navigationController.pushViewController(messageController)
        case .attention:
            let attentionController = container.resolve(AttentionUserViewController.self)!
            attentionController.delegate = self
            navigationController.pushViewController(attentionController)
        case .zan:
            let zan = container.resolve(ZanViewController.self)!
            zan.delegate = self
            navigationController.pushViewController(zan)
        }
    }
    
    func mineDidSelectVip() {
        let pay = container.resolve(PayViewController.self)!
        pay.delegate = self
        navigationController.pushViewController(pay)
    }
    
}

extension MineCoordinator: SettingViewControllerDelegate {
    
    func settingDidClickItem(type: SettingEventType) {
        switch type {
        case .goodJob:
            break
        case .serviceProtocol:
            let webView = container.resolve(WebViewController.self)!
            webView.url = .init(stringLiteral: "\(NetAPI.getBaseURL)api/agreement/detail?id=1")
            navigationController.pushViewController(webView)
        case .userProtocol:
            let webView = container.resolve(WebViewController.self)!
            webView.url = .init(stringLiteral: "\(NetAPI.getBaseURL)api/agreement/detail?id=2")
            navigationController.pushViewController(webView)
        case .about:
            let about = container.resolve(AboutViewController.self)!
            navigationController.pushViewController(about)
        case .login:
            showLogin()
        }
    }
}

extension MineCoordinator: HelpViewControllerDelegate {
    
    func helpDidSelected(item: HelpListModel) {
        let helpDetail = container.resolve(HelpDetailViewController.self, argument: item)!
        navigationController.pushViewController(helpDetail)
    }
    
    func helpDidInput() {
        let help = container.resolve(HelpInputViewController.self)!
        navigationController.pushViewController(help)
    }
    
}

extension MineCoordinator: AttentionUserViewControllerDelegate {
    
    func attentionUserShowWallPaperHome(controller: AttentionUserViewController, viewModel: AttentionUserCellViewModel) {
        let wallPaperHome = container.resolve(WallPaperHomeControler.self, argument: viewModel.model.id!)!
        wallPaperHome.isAttention.bind(to: viewModel.isAttention).disposed(by: wallPaperHome.rx.disposeBag)
        navigationController.pushViewController(wallPaperHome)
    }
    
}

extension MineCoordinator: ZanViewControllerDelegate {
    
    func showWallPaperController(controller: ZanViewController, model: WallPaperInfoModel, image: UIImage?) {
        let dict:[[String: Any]] = [[
            "page": Int(model.page) ?? 0,
            "id": model.id ?? 0
            ]]
        let service = ZanWallPaperService()
        showWallPaper(service: service, jsonDict: dict, defaultImg: image)
    }
    
}

extension MineCoordinator: WallPaperViewControllerDelegate {
    
    func wallPaperShowUserHome(controller: WallPaperViewController, viewModel: WallPaperCellNodeViewModel) -> WallPaperHomeControler {
        let wallPaperHome = container.resolve(WallPaperHomeControler.self, argument: viewModel.model.userId!)!
        wallPaperHome.isAttention.bind(to: viewModel.isAttention).disposed(by: wallPaperHome.rx.disposeBag)
        return wallPaperHome
    }
}

extension MineCoordinator: UserInfoViewControllerDelegate {
    func userInfoShowPhone(controller: UserInfoViewController, isChange: Bool) {
        
        if isChange {
            let changePhone = container.resolve(UserInfoChangePhoneViewController.self)!
            changePhone.delegate = self
            navigationController.pushViewController(changePhone)
        } else {
            let service = BindPhoneService() as PhoneService
            let viewModel = container.resolve(PhoneViewModel.self, argument: service)!
            let phone = container.resolve(UserInfoPhoneViewController.self, argument: viewModel)!
            phone.type = .bind
            phone.delegate = self
            navigationController.pushViewController(phone)
        }
    }
    
    func userInfoShowChangePhone(controller: UserInfoViewController) {
        
    }
    
    func userInfoShowBirthday(controller: UserInfoViewController) {
        let birthday = container.resolve(UserInfoBirthdayViewController.self)!
        navigationController.pushViewController(birthday)
    }
    
    func userInfoShowNickName(controller: UserInfoViewController) {
        let nickName = container.resolve(UserInfoNickViewController.self)!
        navigationController.pushViewController(nickName)
    }
    
    
}

extension MineCoordinator: UserInfoChangePhoneViewControllerDelegate {
    
    func userInfoChangePhoneShowPhone(controller: UserInfoChangePhoneViewController) {
        let service = CheckPhoneService() as PhoneService
        let viewModel = container.resolve(PhoneViewModel.self, argument: service)!
        let phone = container.resolve(UserInfoPhoneViewController.self, argument: viewModel)!
        phone.delegate = self
        navigationController.pushViewController(phone)
    }
    
}

extension MineCoordinator: UserInfoPhoneViewControllerDelegate {
    
    func userInfoPhoneClickDecide(controller: UserInfoPhoneViewController, oldCode: String?) {
        switch controller.type {
        case .check:
            let service = ChangePhoneService() as PhoneService
            let viewModel = container.resolve(PhoneViewModel.self, argument: service)!
            viewModel.oldCode = oldCode
            let phone = container.resolve(UserInfoPhoneViewController.self, argument: viewModel)!
            phone.type = .change
            phone.delegate = self
            navigationController.pushViewController(phone)
        case .bind, .change:
            for vc in navigationController.viewControllers where vc.isKind(of: UserInfoViewController.self) {
                navigationController.popToViewController(vc, animated: true)
                break
            }
        case .loginBind:
            break
        }
    }
    
    
}

extension MineCoordinator: PayViewControllerDelegate {
    
    func payShowLogin(controller: PayViewController) {
        if !UserManager.shared.isLogin {
            showLogin()
            return
        }
    }
    
}
