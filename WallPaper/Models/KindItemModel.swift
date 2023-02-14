//
//  KindItemModel.swift
//  WallPaper
//
//  Created by LiQi on 2020/4/17.
//  Copyright © 2020 Qire. All rights reserved.
//

import Foundation
import SwiftyJSON

class KindItemModel: Mapable {
    
    /*
     "id": 0,
     "name": "",
     "sort": 0
     */
    
    var id : Int!
    var name : String!
    var sort : Int!
    
    required init(json: JSON){
        if json.isEmpty{
            return
        }
        id = json["id"].intValue
        name = json["name"].stringValue
        sort = json["sort"].intValue
    }
    
    
}
