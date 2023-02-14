//
//  UIFont+Extensions.swift
//  WallPaper
//
//  Created by LiQi on 2020/4/10.
//  Copyright © 2020 Qire. All rights reserved.
//

import UIKit

extension UIFont {

    enum PingFang: String {
        case regular    = "PingFangSC-Regular"
        case medium     = "PingFangSC-Medium"
        case thin       = "PingFangSC-Light"
        case light      = "PingFangSC-Thin"
        case ultralight = "PingFangSC-Ultralight"
        case bold       = "PingFangSC-Semibold"
    }

    convenience init(style: PingFang, size: CGFloat) {
        self.init(name: style.rawValue, size: size)!
    }
    

}
