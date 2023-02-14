//
//  HelpModel.swift
//  WallPaper
//
//  Created by LiQi on 2020/4/27.
//  Copyright © 2020 Qire. All rights reserved.
//

import Foundation
import SwiftyJSON

class HelpListModel: Mapable {
    
    /*
     {
         "id": 1,
         "title": "服务协议"
     }
     */
    
    var id : Int!
    var title : String!
    
    required init(json: JSON) {
        id = json["id"].intValue
        title = json["title"].stringValue
    }
    
}

class HelpDetailModel: Mapable {
    
    /*
     {
         "id": 1,
         "title": "服务协议"
     }
     */
    
    var id : Int!
    var title : String!
    var content : String!
    
    required init(json: JSON) {
        id = json["id"].intValue
        title = json["title"].stringValue
        content = json["content"].stringValue
    }
    
}

class HelpTypeModel: Mapable {
    
    /*
     {
         "id": 1,
         "title": "服务协议"
     }
     */
    
    var id : Int!
    var name : String!
    
    required init(json: JSON) {
        id = json["id"].intValue
        name = json["name"].stringValue
    }
    
}
