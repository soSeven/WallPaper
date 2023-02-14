//
//  LibsManager.swift
//  WallPaper
//
//  Created by LiQi on 2020/4/11.
//  Copyright © 2020 Qire. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Reusable
import IQKeyboardManagerSwift
import FLEX


class LibsManager: NSObject {
    
    static let shared = LibsManager()
    
    func setupLibs(with window: UIWindow? = nil) {
//        let libsManager = LibsManager.shared
//        libsManager.setupCocoaLumberjack()
//        libsManager.setupAnalytics()
//        libsManager.setupAds()
//        libsManager.setupTheme()
//        libsManager.setupFLEX()
        setupKeyboardManager(enable: true)
        setupUM()
        setupFLEX()
//        libsManager.setupActivityView()
//        libsManager.setupDropDown()
//        libsManager.setupToast()
        
    }
    
    func setupKeyboardManager(enable: Bool) {
        IQKeyboardManager.shared.enable = enable
    }
    
    func setupKeyboardManagerShow(show: Bool) {
        IQKeyboardManager.shared.enableAutoToolbar = show
    }
    
    func setupFLEX() {
        FLEXManager.shared.isNetworkDebuggingEnabled = true
        FLEXManager.shared.showExplorer()
    }
    
    // MARK: - UM
    
    func setupUM() {
        UMConfigure.setLogEnabled(true)
        UMConfigure.initWithAppkey("5eb64fc9978eea078b7e9a98", channel: "App Store")
        
        UMSocialManager.default()?.setPlaform(.wechatSession, appKey: "wx8a43136c3fa529da", appSecret: "d2488ca50196b39219c3d5f54d7ad9db", redirectURL: "http://mobile.umeng.com/social")
    }
    
    func handleUM(open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        if let manager = UMSocialManager.default() {
            return manager.handleOpen(url, options: options)
        }
        return false
    }
    
}


