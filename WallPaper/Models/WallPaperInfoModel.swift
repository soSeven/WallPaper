//
//  WallPaperInfoModel.swift
//  WallPaper
//
//  Created by LiQi on 2020/4/10.
//  Copyright © 2020 Qire. All rights reserved.
//

import Foundation
import SwiftyJSON

class WallPaperHomeModel: Mapable {
    
    var datePage : [WallPaperSectionListModel]!
    var user : WallPaperUserModel!


    required init(json: JSON) {
       
        datePage = [WallPaperSectionListModel]()
        let datePageArray = json["date_page"].arrayValue
        for datePageJson in datePageArray{
            let value = WallPaperSectionListModel(json: datePageJson)
            datePage.append(value)
        }
        let userJson = json["user"]
        user = WallPaperUserModel(json: userJson)
    }
}

class WallPaperUserModel: Mapable {
    
    var area : String!
    var avatar : String!
    var constellation : String!
    var email : String!
    var id : Int!
    var isFollow : Bool!
    var isVip : Int!
    var mobile : String!
    var nickname : String!
    var sex : Int!
    var sign : String!
    var username : String!

    required init(json: JSON) {
        area = json["area"].stringValue
        avatar = json["avatar"].stringValue
        constellation = json["constellation"].stringValue
        email = json["email"].stringValue
        id = json["id"].intValue
        isFollow = json["is_follow"].boolValue
        isVip = json["is_vip"].intValue
        mobile = json["mobile"].stringValue
        nickname = json["nickname"].stringValue
        sex = json["sex"].intValue
        sign = json["sign"].stringValue
        username = json["username"].stringValue
    }
}

class WallPaperSectionListModel: Mapable {
    
    var date : String!
    var wallpaperList : [WallPaperModel]!

    required init(json: JSON){
        date = json["date"].stringValue
        wallpaperList = [WallPaperModel]()
        let wallpaperListArray = json["wallpaper_list"].arrayValue
        for wallpaperListJson in wallpaperListArray{
            let value = WallPaperModel(json: wallpaperListJson)
            wallpaperList.append(value)
        }
    }

}


class WallPaperInfoModel: Mapable {
    
    /**
    "id": 25,
    "name": "祝你越来越好！",
    "description": "你要储蓄你的可爱，眷顾你的善良，变得勇敢，当这个世界越来越坏时，只希望你越来越好。可替换3张图片。",
    "video": "https://v.dohonge.cn/material/video/20200306/16/58/59a673e90990b02ec72e9c66586c2d26.mp4",
    "cover": "https://v.dohonge.cn/material/image/20200306/004fef331d5433662652b737d584ba1d.jpg",
    "is_vip": 1,
    "set_num": 26,
    "visit_num": 11,
    "duration": 10120,
    "page": "1"
    */
    
    var cover : String!
    var descriptionField : String!
    var duration : Int!
    var id : Int!
    var isVip : Int!
    var name : String!
    var page : String!
    var setNum : Int!
    var video : String!
    var visitNum : Int!
    var coverWidth : Int!
    var coverHeight : Int!
    
    required init(json: JSON){
        if json.isEmpty{
            return
        }
        cover = json["cover"].stringValue
        descriptionField = json["description"].stringValue
        duration = json["duration"].intValue
        id = json["id"].intValue
        isVip = json["is_vip"].intValue
        name = json["name"].stringValue
        page = json["page"].stringValue
        setNum = json["set_num"].intValue
        video = json["video"].stringValue
        visitNum = json["visit_num"].intValue
        coverWidth = json["cover_width"].intValue
        coverHeight = json["cover_height"].intValue
    }
}

class WallPaperModel: Mapable {

    var adminId : Int!
    var authorId : Int!
    var categories : [WallPaperCategoryModel]!
    var categoryIds : String!
    var colorIds : String!
    var cover : String!
    var createTime : String!
    var deleteTime : String!
    var descriptionField : String!
    var duration : Int!
    var fontList : String!
    var gif : String!
    var id : Int!
    var imageCount : Int!
    var isFollow : Bool!
    var isVip : Int!
    var isZan : Bool!
    var name : String!
    var number : String!
    var page : Int!
    var resource : String!
    var setNum : Int!
    var sort : Int!
    var status : Int!
    var transNum : Int!
    var updateTime : String!
    var userAvatar : String!
    var userId : Int!
    var userNickname : String!
    var video : String!
    var visitNum : Int!
    var zanNum : Int!

    required init(json: JSON){
        
        adminId = json["admin_id"].intValue
        authorId = json["author_id"].intValue
        categories = [WallPaperCategoryModel]()
        let categoriesArray = json["categories"].arrayValue
        for categoriesJson in categoriesArray{
            let value = WallPaperCategoryModel(json: categoriesJson)
            categories.append(value)
        }
        categoryIds = json["category_ids"].stringValue
        colorIds = json["color_ids"].stringValue
        cover = json["cover"].stringValue
        createTime = json["create_time"].stringValue
        deleteTime = json["delete_time"].stringValue
        descriptionField = json["description"].stringValue
        duration = json["duration"].intValue
        fontList = json["font_list"].stringValue
        gif = json["gif"].stringValue
        id = json["id"].intValue
        imageCount = json["image_count"].intValue
        isFollow = json["is_follow"].boolValue
        isVip = json["is_vip"].intValue
        isZan = json["is_zan"].boolValue
        name = json["name"].stringValue
        number = json["number"].stringValue
        page = json["page"].intValue
        resource = json["resource"].stringValue
        setNum = json["set_num"].intValue
        sort = json["sort"].intValue
        status = json["status"].intValue
        transNum = json["trans_num"].intValue
        updateTime = json["update_time"].stringValue
        userAvatar = json["user_avatar"].stringValue
        userId = json["user_id"].intValue
        userNickname = json["user_nickname"].stringValue
        video = json["video"].stringValue
        visitNum = json["visit_num"].intValue
        zanNum = json["zan_num"].intValue
    }

}

class WallPaperCategoryModel: Mapable {

    var cover : String!
    var createTime : String!
    var deleteTime : String!
    var id : Int!
    var name : String!
    var pid : Int!
    var sort : Int!
    var updateTime : String!

    required init(json: JSON){
        cover = json["cover"].stringValue
        createTime = json["create_time"].stringValue
        deleteTime = json["delete_time"].stringValue
        id = json["id"].intValue
        name = json["name"].stringValue
        pid = json["pid"].intValue
        sort = json["sort"].intValue
        updateTime = json["update_time"].stringValue
    }

}
