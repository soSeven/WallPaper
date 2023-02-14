//
//  ProgressView.swift
//  WallPaper
//
//  Created by LiQi on 2020/4/20.
//  Copyright © 2020 Qire. All rights reserved.
//

import UIKit

class ProgressView: UIProgressView {

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let newSize = CGSize(width: size.width, height: 1/UIScreen.main.scale)
        return newSize
    }
}
