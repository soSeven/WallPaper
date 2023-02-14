//
//  MineCellViewModel.swift
//  WallPaper
//
//  Created by LiQi on 2020/4/14.
//  Copyright © 2020 Qire. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum MineCellType: String {
    case zan = "赞过"
    case attention = "关注"
    case message = "消息"
    case help = "帮助与反馈"
    case setting = "设置"
    
    var imgName: String {
        switch self {
        case .zan:
            return "mine_icon_like"
        case .attention:
            return "mine_icon_follow"
        case .message:
            return "mine_icon_news"
        case .help:
            return "mine_icon_help"
        case .setting:
            return "mine_icon_setting"
        }
    }
}

class MineCellViewModel {
    
    var title = ""
    var imgName = ""
    var number = BehaviorRelay<Int>(value: 0)
    var dot = BehaviorRelay<Bool>(value: false)
    var type: MineCellType = .zan
    
    init(type: MineCellType) {
        title = type.rawValue
        self.type = type
        imgName = type.imgName
    }

}
