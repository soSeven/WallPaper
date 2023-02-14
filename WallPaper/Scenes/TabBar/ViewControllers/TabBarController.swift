//
//  TabBarController.swift
//  WallPaper
//
//  Created by LiQi on 2020/4/9.
//  Copyright © 2020 Qire. All rights reserved.
//

import UIKit
import NSObject_Rx
import Hue
import RxSwift
import RxCocoa

enum TabBarItem: Int {
    case home
    case mine
}

protocol TabBarControllerDelegate: AnyObject {
    
    func showChildControllers(tabController: TabBarController, items: [TabBarItem])
    
}

class TabBarController: UITabBarController {
    
    let scrollToTopStatus = BehaviorRelay<Bool>(value: true)
    let scrollToTop = PublishRelay<Void>()
    
    var viewModel: TabBarViewModel!
    weak var itemDelegate: TabBarControllerDelegate?
    
    init(viewModel: TabBarViewModel, itemDelegate: TabBarControllerDelegate) {
        self.viewModel = viewModel
        self.itemDelegate = itemDelegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBinding()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        let bar = WPTabBar(frame: .zero)
        bar.scrollToTop.bind(to: scrollToTop).disposed(by: rx.disposeBag)
        scrollToTopStatus.bind(to: bar.scrollToTopStatus).disposed(by: rx.disposeBag)
        bar.scrollTopView.backgroundColor = UIColor(hex: "#1A1B20")
        bar.barTintColor = UIColor(hex: "#1A1B20")
        bar.isTranslucent = false
        setValue(bar, forKey: "tabBar")
    }
    
    private func setupBinding() {
        
        let input = TabBarViewModel.Input()
        print(input)
        let output = viewModel.transform(input: input)
        
        output.tabBarItems.drive(onNext: {[weak self] items in
            guard let self = self else { return }
            self.itemDelegate?.showChildControllers(tabController: self, items: items)
        }).disposed(by: rx.disposeBag)
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let bar = tabBar as? WPTabBar, let t = item.title else {
            return
        }
        if t == "我的" {
            bar.scrollTopView.isHidden = true
        } else {
            bar.scrollToTopStatus.accept(bar.scrollToTopStatus.value)
        }
    }
    
}
