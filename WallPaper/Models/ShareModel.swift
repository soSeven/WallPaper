//
//  ShareModel.swift
//  WallPaper
//
//  Created by LiQi on 2020/5/9.
//  Copyright © 2020 Qire. All rights reserved.
//

import Foundation
import SwiftyJSON

class ShareModel: Mapable {
    
    var title : String!
    var description : String!
    var img : String!
    var url : String!
    var requestImg: UIImage?

    required init(json: JSON) {
        title = json["title"].stringValue
        description = json["description"].stringValue
        img = json["img"].stringValue
        url = json["url"].stringValue
    }
}

