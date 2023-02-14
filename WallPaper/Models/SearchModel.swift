//
//  SearchModel.swift
//  WallPaper
//
//  Created by LiQi on 2020/4/29.
//  Copyright © 2020 Qire. All rights reserved.
//

import Foundation
import SwiftyJSON

class SearchHomeListModel: Mapable {
    
    var createTime : String!
    var deleteTime : String!
    var id : Int!
    var name : String!
    var num : Int!
    var sort : Int!
    var updateTime : String!

    required init(json: JSON) {
        createTime = json["create_time"].stringValue
        deleteTime = json["delete_time"].stringValue
        id = json["id"].intValue
        name = json["name"].stringValue
        num = json["num"].intValue
        sort = json["sort"].intValue
        updateTime = json["update_time"].stringValue
    }
}
