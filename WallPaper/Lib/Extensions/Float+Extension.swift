//
//  Float+Extension.swift
//  CrazyMusic
//
//  Created by LiQi on 2020/2/6.
//  Copyright © 2020 长沙奇热. All rights reserved.
//

import UIKit

extension Float {
    
    var uiX: CGFloat {
        return CGFloat(self) * UIDevice.uiXScale
    }
}
