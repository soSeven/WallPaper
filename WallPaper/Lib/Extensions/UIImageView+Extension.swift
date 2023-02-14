//
//  UIImageView+Extension.swift
//  WallPaper
//
//  Created by LiQi on 2020/4/13.
//  Copyright © 2020 Qire. All rights reserved.
//

import UIKit

extension UIImageView {
    
    var snpSize: CGSize {
        if let image = image {
            return .init(width: Float(image.size.width).uiX, height: Float(image.size.height).uiX)
        }
        return .zero
    }
    
    var snpScale: CGFloat {
        let size = snpSize
        if size == .zero {
            return 0
        }
        let scale = size.height/size.width
        return scale
    }
    
}
