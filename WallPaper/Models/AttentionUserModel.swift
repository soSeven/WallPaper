//
//  AttentionUserModel.swift
//  WallPaper
//
//  Created by LiQi on 2020/4/29.
//  Copyright © 2020 Qire. All rights reserved.
//

import Foundation
import SwiftyJSON

class AttentionUserListModel: Mapable {
    
    var nickname : String!
    var avatar : String!
    var id : Int!
    var sex : Int!

    required init(json: JSON) {
        nickname = json["nickname"].stringValue
        avatar = json["avatar"].stringValue
        id = json["id"].intValue
        sex = json["sex"].intValue
    }
    
}

class AttentionUserModel: Mapable {
    
    var toUserId : Int!
    var followStatus : Bool!

    required init(json: JSON) {
        toUserId = json["to_user_id"].intValue
        followStatus = json["follow_status"].boolValue
    }
    
}
