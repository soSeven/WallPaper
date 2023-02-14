//
//  UIDevice+Extension.swift
//  CrazyMusic
//
//  Created by liQi on 2020/1/3.
//  Copyright © 2020 长沙奇热. All rights reserved.
//

import UIKit

/*

 手机机型(iPhone)    屏幕尺寸(inch)    逻辑分辨率(pt)    设备分辨率(px)    缩放因子(Scale Factor)
 3G(s)              3.5             320x480         320x480         @1x
 4(s)               3.5             320x480         640x960         @2x
 5(s/se)            4               320x568         640x1136        @2x
 6(s)/7/8           4.7             375x667         750x1334        @2x
 6(s)/7/8 Plus      5.5             414x736         1242x2208       @3x
 X                  5.8             375x812         1125x2436       @3x
 Xr/11              6.1             414x896         828×1792        @2x
 Xs/11 Pro          5.8             375x812         1125×2436       @3x
 Xs Max/11 Pro Max  6.5             414x896         1242×2688       @3x

 */

extension UIDevice {

    enum DeviceType {
        case device320x480
        case device320x568
        case device375x667
        case device414x736
        case device357x812
        case device414x896
        case deviceNotAdd
    }

    static let deviceType: DeviceType = { () -> DeviceType in
        let wS = UIScreen.main.bounds.size.width
        let hS = UIScreen.main.bounds.size.height
        let w = CGFloat.minimum(wS, hS)
        let h = CGFloat.maximum(wS, hS)
        switch (w, h) {
        case (320, 480):
            return .device320x480
        case (320, 568):
            return .device320x568
        case (375, 667):
            return .device375x667
        case (414, 736):
            return .device414x736
        case (357, 812):
            return .device357x812
        case (414, 896):
            return .device414x896
        default:
            return .deviceNotAdd
        }
    }()
    
    static let uiXScale = { () -> CGFloat in
        return screenWidth/375.0
    }()
    
    static let uiYScale = { () -> CGFloat in
        return screenHeight/667.0
    }()
    
    static let screenWidth = { () -> CGFloat in
        let wS = UIScreen.main.bounds.size.width
        let hS = UIScreen.main.bounds.size.height
        let h = CGFloat.maximum(wS, hS)
        return CGFloat.minimum(wS, hS)
    }()
    
    static let screenHeight = { () -> CGFloat in
        let wS = UIScreen.main.bounds.size.width
        let hS = UIScreen.main.bounds.size.height
        return CGFloat.maximum(wS, hS)
    }()
    
    static let safeAreaBottom = { () -> CGFloat in
        var b: CGFloat = 0
        if #available(iOS 11, *) {
            if let delegate = UIApplication.shared.delegate,
                let window = delegate.window {
                b = window?.safeAreaInsets.bottom ?? 0
            }
        }
        return b
    }()
    
    static let isPhoneX = { () -> Bool in
        if safeAreaBottom > 0 {
            return true
        }
        return false
    }()
    
    static let statusBarHeight = { () -> CGFloat in
        if isPhoneX {
            return 44
        }
        return 20
    }()

    static let navigationBarHeight = { () -> CGFloat in
        return 44 + statusBarHeight
    }()

    static let tabarBarHeight = { () -> CGFloat in
        return 49 + safeAreaBottom
    }()

}
