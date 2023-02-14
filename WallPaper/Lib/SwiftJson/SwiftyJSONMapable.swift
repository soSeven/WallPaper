//
//  SwiftyJSONMapable.swift
//  WallPaper
//
//  Created by LiQi on 2020/4/10.
//  Copyright © 2020 Qire. All rights reserved.
//

import Foundation
import SwiftyJSON

public protocol Mapable {
    
    init(json:JSON)
    
}
