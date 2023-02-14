//
//  Application.swift
//  WallPaper
//
//  Created by LiQi on 2020/4/9.
//  Copyright © 2020 Qire. All rights reserved.
//

import UIKit
import Swinject

final class Application {
    
    static let shared = Application()
    internal let container = Container()
    private var appCoordinator: TabBarCoordinator!
    
    func configureDependencies() {
        
        /// 注册tab
        container.register(TabBarViewModel.self) { _ in
            return TabBarViewModel()
        }
        container.register(TabBarController.self) { (r: Resolver, delegate: TabBarCoordinator) in
            let tab = TabBarController(viewModel: r.resolve(TabBarViewModel.self)!, itemDelegate: delegate)
            return tab
        }
        
        /// 注册首页
        container.register(HomeViewModel.self) { _ in
            return HomeViewModel()
        }
        container.register(HomeViewController.self) { r in
            let home = HomeViewController()
            home.viewModel = r.resolve(HomeViewModel.self)!
            return home
        }
        
        container.register(RankViewController.self) { r in
            let rank = RankViewController()
            return rank
        }
        
        container.register(ColorViewModel.self) { _ in
            return ColorViewModel()
        }
        container.register(ColorViewController.self) { r in
            let color = ColorViewController()
            color.viewModel = r.resolve(ColorViewModel.self)!
            return color
        }
        
        container.register(KindViewModel.self) { _ in
            return KindViewModel()
        }
        container.register(KindViewController.self) { r in
            let kind = KindViewController()
            kind.viewModel = r.resolve(KindViewModel.self)!
            return kind
        }
        
        container.register(WallPaperViewModel.self) { (r: Resolver, service: WallPaperService, jsonDict: [[String: Any]] ) in
            let v = WallPaperViewModel(service: service, jsonDict: jsonDict)
            return v
        }
        container.register(WallPaperViewController.self) { (r: Resolver, service: WallPaperService, jsonDict: [[String: Any]] ) in
            let wallPaper = WallPaperViewController()
            wallPaper.viewModel = r.resolve(WallPaperViewModel.self, arguments: service, jsonDict)!
            return wallPaper
        }
        
        container.register(WallPaperHomeControler.self) { (r: Resolver, userId: Int ) in
            let wallPaper = WallPaperHomeControler()
            wallPaper.viewModel = WallPaperHomeViewModel(userId: userId)
            return wallPaper
        }
        
        /// 注册我的
        
        container.register(UserInfoViewModel.self) { r in
            let v = UserInfoViewModel()
            return v
        }
        
        container.register(UserInfoViewController.self) { r in
            let info = UserInfoViewController()
            info.viewModel = r.resolve(UserInfoViewModel.self)!
            return info
        }
        
        container.register(MineViewModel.self) { _ in
            return MineViewModel()
        }
        container.register(MineViewController.self) { r in
            let mine = MineViewController()
            mine.viewModel = r.resolve(MineViewModel.self)!
            return mine
        }
        
        container.register(SettingViewController.self) { r in
            return SettingViewController()
        }
        container.register(AboutViewController.self) { r in
            return AboutViewController()
        }
        
        container.register(HelpViewModel.self) { _ in
            return HelpViewModel()
        }
        container.register(HelpViewController.self) { r in
            let help = HelpViewController()
            help.viewModel = r.resolve(HelpViewModel.self)!
            return help
        }
        
        container.register(HelpDetailViewModel.self) { (r: Resolver, item: HelpListModel) in
            return HelpDetailViewModel(id: item.id)
        }
        container.register(HelpDetailViewController.self) { (r: Resolver, item: HelpListModel) in
            let help = HelpDetailViewController()
            help.viewModel = r.resolve(HelpDetailViewModel.self, argument: item)
            return help
        }
        
        container.register(HelpInputViewModel.self) { r in
            return HelpInputViewModel()
        }
        container.register(HelpInputViewController.self) { r in
            let help = HelpInputViewController()
            help.viewModel = r.resolve(HelpInputViewModel.self)!
            return help
        }
        
        container.register(ListViewModel<MessageListModel>.self) { r in
            let v = ListViewModel<MessageListModel>(service: MessageListService())
            return v
        }
        container.register(MessageViewController.self) { r in
            let message = MessageViewController()
            message.viewModel = r.resolve(ListViewModel<MessageListModel>.self)!
            return message
        }
        
        container.register(AttentionUserViewModel.self) { r in
            let v = AttentionUserViewModel()
            return v
        }
        container.register(AttentionUserViewController.self) { r in
            let attentionUser = AttentionUserViewController()
            attentionUser.viewModel = r.resolve(AttentionUserViewModel.self)!
            return attentionUser
        }
        
        container.register(ZanViewController.self) { r in
            let v = ZanViewController()
            return v
        }
        
        container.register(UserInfoNickViewModel.self) { r in
            let v = UserInfoNickViewModel()
            return v
        }
        container.register(UserInfoNickViewController.self) { r in
            let v = UserInfoNickViewController()
            v.viewModel = r.resolve(UserInfoNickViewModel.self)!
            return v
        }
        
        container.register(UserInfoBirthdayViewModel.self) { r in
            let v = UserInfoBirthdayViewModel()
            return v
        }
        container.register(UserInfoBirthdayViewController.self) { r in
            let v = UserInfoBirthdayViewController()
            v.viewModel = r.resolve(UserInfoBirthdayViewModel.self)!
            return v
        }
        
        container.register(UserInfoChangePhoneViewController.self) { r in
            let v = UserInfoChangePhoneViewController()
            return v
        }
        
        container.register(UserInfoPhoneViewController.self) { (r: Resolver, viewModel: PhoneViewModel) in
            let v = UserInfoPhoneViewController()
            v.viewModel = viewModel
            return v
        }
        
          
        /// 网页
        container.register(WebViewController.self) { r in
            return WebViewController()
        }
        
        /// 注册登录
        container.register(PhoneViewModel.self) { (r: Resolver, service: PhoneService) in
            return PhoneViewModel(service: service)
        }
        container.register(LoginController.self) { (r: Resolver, viewModel: PhoneViewModel) in
            let login = LoginController()
            login.viewModel = viewModel
            return login
        }
        
        /// 搜索
        container.register(SearchViewController.self) { r in
            let login = SearchViewController()
//            login.viewModel = r.resolve(LoginViewModel.self)!
            return login
        }
        
        /// 购买
        
        container.register(PayViewModel.self) { r in
            let v = PayViewModel()
            return v
        }
        container.register(PayViewController.self) { r in
            let pay = PayViewController()
            pay.viewModel = r.resolve(PayViewModel.self)!
            return pay
        }
        
    }
    
    func configureMainInterface(in window: UIWindow) {
        
        appCoordinator = TabBarCoordinator(window: window, container: container)
        appCoordinator.start()
        
    }
}
