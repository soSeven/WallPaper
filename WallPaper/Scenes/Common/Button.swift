//
//  Button.swift
//  WallPaper
//
//  Created by LiQi on 2020/4/16.
//  Copyright © 2020 Qire. All rights reserved.
//

import UIKit

class Button: UIButton {

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        var bounds = self.bounds
        let deltaW = CGFloat.maximum(44 - bounds.width, 0)
        let deltaH = CGFloat.maximum(44 - bounds.height, 0)
        bounds = bounds.insetBy(dx: -deltaW * 0.5, dy: -deltaH * 0.5)
        return bounds.contains(point)
    }

}
