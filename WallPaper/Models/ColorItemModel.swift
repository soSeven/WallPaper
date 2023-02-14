//
//  ColorItemModel.swift
//  WallPaper
//
//  Created by LiQi on 2020/4/17.
//  Copyright © 2020 Qire. All rights reserved.
//

import Foundation
import SwiftyJSON

class ColorItemModel: Mapable {
    
    /*
     "id": 0,
     "name": "全部色系",
     "hex": "#00000000",
     "sort": 0
     */
    
    var id : Int!
    var name : String!
    var hex : String!
    var sort : Int!
    
    required init(json: JSON){
        if json.isEmpty{
            return
        }
        id = json["id"].intValue
        name = json["name"].stringValue
        hex = json["hex"].stringValue
        sort = json["sort"].intValue
    }
    
    
}
