//
//  UserModel.swift
//  WallPaper
//
//  Created by LiQi on 2020/4/15.
//  Copyright © 2020 Qire. All rights reserved.
//

import Foundation
import SwiftyJSON

class UserModel: NSObject, Mapable, NSCoding {
    
    var area : String!
    var avatar : String!
    var constellation : String!
    var id : Int!
    var isVip : Bool!
    var messageNum : Int!
    var mobile : String!
    var nickname : String!
    var qqOpenid : Bool!
    var sex : Int!
    var vipTime : String!
    var wxOpenid : Bool!
    var wxUnionid : Bool!
    
    var token : String!
    
    required init(json: JSON) {
        
        area = json["area"].stringValue
        avatar = json["avatar"].stringValue
        constellation = json["constellation"].stringValue
        id = json["id"].intValue
        isVip = json["is_vip"].boolValue
        messageNum = json["message_num"].intValue
        mobile = json["mobile"].stringValue
        nickname = json["nickname"].stringValue
        qqOpenid = json["qq_openid"].boolValue
        sex = json["sex"].intValue
        vipTime = json["vip_time"].stringValue
        wxOpenid = json["wx_openid"].boolValue
        wxUnionid = json["wx_unionid"].boolValue
        
        token = json["token"].stringValue
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(area, forKey: "area")
        coder.encode(avatar, forKey: "avatar")
        coder.encode(constellation, forKey: "constellation")
        coder.encode(id, forKey: "id")
        coder.encode(isVip, forKey: "is_vip")
        coder.encode(messageNum, forKey: "message_num")
        coder.encode(mobile, forKey: "mobile")
        coder.encode(nickname, forKey: "nickname")
        coder.encode(qqOpenid, forKey: "qq_openid")
        coder.encode(sex, forKey: "sex")
        coder.encode(vipTime, forKey: "vip_time")
        coder.encode(wxOpenid, forKey: "wx_openid")
        coder.encode(wxUnionid, forKey: "wx_unionid")
        coder.encode(token, forKey: "token")
    }
    
    required init?(coder: NSCoder) {
        area = coder.decodeObject(forKey: "area") as? String ?? ""
        avatar = coder.decodeObject(forKey: "avatar") as? String ?? ""
        constellation = coder.decodeObject(forKey: "constellation") as? String ?? ""
        id = coder.decodeObject(forKey: "id") as? Int ?? 0
        isVip = coder.decodeObject(forKey: "is_vip") as? Bool ?? false
        messageNum = coder.decodeObject(forKey: "message_num") as? Int ?? 0
        mobile = coder.decodeObject(forKey: "mobile") as? String ?? ""
        nickname = coder.decodeObject(forKey: "nickname") as? String ?? ""
        qqOpenid = coder.decodeObject(forKey: "qq_openid") as? Bool ?? false
        sex = coder.decodeObject(forKey: "sex") as? Int ?? 0
        vipTime = coder.decodeObject(forKey: "vip_time") as? String ?? ""
        wxOpenid = coder.decodeObject(forKey: "wx_openid") as? Bool ?? false
        wxUnionid = coder.decodeObject(forKey: "wx_unionid") as? Bool ?? false
        token = coder.decodeObject(forKey: "token") as? String ?? ""
    }
    
    
}

