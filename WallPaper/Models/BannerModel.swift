//
//  BannerModel.swift
//  WallPaper
//
//  Created by LiQi on 2020/4/13.
//  Copyright © 2020 Qire. All rights reserved.
//

import Foundation
import SwiftyJSON

class BannerModel: Mapable {
    /*
     "id": 2,
     "type": 1,
     "url": "https://v.dohonge.cn/material/image/20200309/5b566229aabacb4eb92e9918bbe026dc.jpg",
     "sort": 1,
     "create_time": "2020-03-12 13:56:03",
     "update_time": "2020-03-18 15:49:31",
     "delete_time": null
     */
    
    var createTime : String!
    var deleteTime : String!
    var id : Int!
    var sort : Int!
    var type : Int!
    var updateTime : String!
    var url : String!
    var link : String!

    required init(json: JSON){
        if json.isEmpty{
            return
        }
        createTime = json["create_time"].stringValue
        deleteTime = json["delete_time"].stringValue
        id = json["id"].intValue
        sort = json["sort"].intValue
        type = json["type"].intValue
        updateTime = json["update_time"].stringValue
        url = json["url"].stringValue
        link = json["link"].stringValue
    }
    
}
