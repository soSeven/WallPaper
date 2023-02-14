//
//  ZanModel.swift
//  WallPaper
//
//  Created by LiQi on 2020/5/11.
//  Copyright © 2020 Qire. All rights reserved.
//

import Foundation
import SwiftyJSON

class ZanModel: Mapable {
    
    var id : Int!
    var zanStatus : Bool!

    required init(json: JSON) {
        id = json["id"].intValue
        zanStatus = json["zan_status"].boolValue
    }
    
}
