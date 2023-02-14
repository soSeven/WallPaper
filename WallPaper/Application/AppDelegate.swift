//
//  AppDelegate.swift
//  WallPaper
//
//  Created by LiQi on 2020/4/9.
//  Copyright © 2020 Qire. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        Application.shared.configureDependencies()
        return true
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.backgroundColor = .white

        let libsManager = LibsManager.shared
        libsManager.setupLibs(with: window)
        
        Application.shared.configureMainInterface(in: window)
        self.window = window
        self.window?.makeKeyAndVisible()
        
        let userManager = UserManager.shared
        userManager.autoLogin()
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let umResult = LibsManager.shared.handleUM(open: url, options: options)
        return umResult
    }
    

}

