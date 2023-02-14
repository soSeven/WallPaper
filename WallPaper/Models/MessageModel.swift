//
//  MessageModel.swift
//  WallPaper
//
//  Created by LiQi on 2020/4/29.
//  Copyright © 2020 Qire. All rights reserved.
//

import Foundation
import SwiftyJSON

class MessageListModel: Mapable {
    
    var content : String!
    var createTime : String!
    var deleteTime : String!
    var id : Int!
    var messageId : Int!
    var status : Int!
    var title : String!
    var updateTime : String!
    var userId : Int!

    required init(json: JSON) {
        content = json["content"].stringValue
        createTime = json["create_time"].stringValue
        deleteTime = json["delete_time"].stringValue
        id = json["id"].intValue
        messageId = json["message_id"].intValue
        status = json["status"].intValue
        title = json["title"].stringValue
        updateTime = json["update_time"].stringValue
        userId = json["user_id"].intValue
    }
    
}
