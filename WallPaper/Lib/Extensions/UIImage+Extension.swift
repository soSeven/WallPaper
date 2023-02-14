//
//  UIImage+Extension.swift
//  WallPaper
//
//  Created by LiQi on 2020/4/15.
//  Copyright © 2020 Qire. All rights reserved.
//

import UIKit

extension UIImage {
    
    var snpSize: CGSize {
        return .init(width: Float(self.size.width).uiX, height: Float(self.size.height).uiX)
    }
    
    var snpScale: CGFloat {
        let size = snpSize
        if size.width == 0 {
            return 0
        }
        let scale = size.height/size.width
        return scale
    }
    
}
