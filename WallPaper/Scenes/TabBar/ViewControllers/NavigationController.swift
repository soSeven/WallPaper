//
//  NavigationController.swift
//  WallPaper
//
//  Created by LiQi on 2020/4/9.
//  Copyright © 2020 Qire. All rights reserved.
//

import UIKit
import HBDNavigationBar

class NavigationController: HBDNavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
//        let currentVc = self.topViewController
//        self.navigationBar.backIndicatorImage = UIImage(named: "login_icon_return")
//        self.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "login_icon_return")
        
//        let imgView = UIImageView(image: UIImage(named: "login_icon_return"))
        let backBtn = Button()
        backBtn.addTarget(self, action: #selector(onClickBack), for: .touchUpInside)
        backBtn.setImage(UIImage(named: "login_icon_return"), for: .normal)
        backBtn.frame = .init(x: 0, y: 0, width: 40, height: 40)
        backBtn.contentHorizontalAlignment = .left
//        backBtn.alig
        viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backBtn)
//        currentVc?.navigationItem.backBarButtonItem = UIBarButtonItem(customView: backBtn)
        if viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }

    @objc
    func onClickBack() {
        popViewController(animated: true)
    }
}


