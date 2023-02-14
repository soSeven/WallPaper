//
//  MBProgressHUD+Extensions.swift
//  WallPaper
//
//  Created by LiQi on 2020/4/26.
//  Copyright © 2020 Qire. All rights reserved.
//

import Foundation
import MBProgressHUD

extension MBProgressHUD {
    
    class func showWindowLoading() {
        if let v = UIApplication.shared.keyWindow {
            let mb = MBProgressHUD.showAdded(to: v, animated: true)
            mb.bezelView.style = .solidColor
            mb.bezelView.color = .clear
            mb.contentColor = .white
        }
    }
    
    class func hideWindowLoading() {
        if let v = UIApplication.shared.keyWindow {
            MBProgressHUD.hide(for: v, animated: true)
        }
    }
}
