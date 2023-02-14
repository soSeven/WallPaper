//
//  PayModel.swift
//  WallPaper
//
//  Created by LiQi on 2020/5/25.
//  Copyright © 2020 Qire. All rights reserved.
//

import Foundation
import SwiftyJSON

class PayInfoModel: Mapable {
    
    var id : Int!
    var name : String!
    var price : String!
    var description : String!

    required init(json: JSON) {
        id = json["id"].intValue
        name = json["name"].stringValue
        price = json["price"].stringValue
        description = json["description"].stringValue
    }
    
}
