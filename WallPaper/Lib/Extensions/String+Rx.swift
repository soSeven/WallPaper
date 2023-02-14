//
//  String+Rx.swift
//  WallPaper
//
//  Created by LiQi on 2020/4/23.
//  Copyright © 2020 Qire. All rights reserved.
//

import Foundation

extension String {
    
    var isValidPhone: Bool {
        // http://emailregex.com/
        let regex = "^1[0-9]{10}$"
        return range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
    
}
