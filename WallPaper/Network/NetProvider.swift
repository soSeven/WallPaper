//
//  NetProvider.swift
//  WallPaper
//
//  Created by LiQi on 2020/4/10.
//  Copyright © 2020 Qire. All rights reserved.
//

import Foundation
import Moya
import FCUUID
import Alamofire
import FileKit
import Kingfisher

let NetProvider = MoyaProvider<NetAPI>(requestClosure: { (endpoint, done) in
    do {
        var request = try endpoint.urlRequest()
        request.timeoutInterval = 20//设置请求超时时间
        done(.success(request))
    } catch {

    }
})

public enum CheckCodeEvent: String {
    case check = "check" //验证手机号
    case bind = "bind" //绑定手机号
    case regLogin = "reg_login" //使用手机号+验证码的方式进行注册或登录
}

//nickname=昵称,area=地区,sex=性别,constellation=星座,avatar=头像
public enum UserInfoChangeType: String {
    
    case nickname = "nickname"
    case area = "area"
    case sex = "sex"
    case constellation = "constellation"
    case avatar = "avatar"
    
}


public enum NetAPI {
    
    /// 首页最新推荐列表
    case homeRecommendList(page: Int, limit: Int)
    case homdBanner
    /// 排行榜
    case rankWeek(page: Int, limit: Int)
    case rankWeekWallPaperNext(page: Int, wallPaperId: Int)
    case rankWeekWallPaperPrevious(page: Int, wallPaperId: Int)
    
    case rankMonth(page: Int, limit: Int)
    case rankMonthWallPaperNext(page: Int, wallPaperId: Int)
    case rankMonthWallPaperPrevious(page: Int, wallPaperId: Int)
    
    case rankAll(page: Int, limit: Int)
    case rankAllWallPaperNext(page: Int, wallPaperId: Int)
    case rankAllWallPaperPrevious(page: Int, wallPaperId: Int)
    
    /// 色系
    case colorItems
    case colorList(id: Int, page: Int, limit: Int)
    /// 分类
    case kindItems
    case kindList(id: Int, page: Int, limit: Int)
    /// 登录
    case aliAuth(token: String)
    case updateUser(token: String? = nil)
    case getCheckCode(mobile: String, event: CheckCodeEvent)
    case phoneLogin(mobile: String, checkCode: String)
    /// 壁纸详情
    case downloadVideo(url: String)
    case firstWallPaper(para: String) //所有壁纸列表初次进入壁纸详情获取滑动列表
    case WallPaperNext(wallPaperId: Int, page: Int, categoryId: Int, colorId: Int) //向下滑动
    case WallPaperPrevious(wallPaperId: Int, page: Int, categoryId: Int, colorId: Int) //向上滑动
    /// 用户详情
    case userWallPaperNext(wallPaperId: Int, userId: Int) //向下滑动
    case userWallPaperPrevious(wallPaperId: Int, userId: Int) //向上滑动
    /// 壁纸用户首页
    case wallPaperUserHome(userId: Int, page: Int, limit: Int)
    /// 帮助列表
    case helpList(page: Int, limit: Int)
    case helpDetail(id: Int)
    case helpTypes
    /// 消息
    case messageList(page: Int, limit: Int)
    /// 关注
    case attentionUserList(page: Int, limit: Int)
    /// 搜索
    case homeSearchList
    case search(page: Int, limit: Int, sortId: Int, kindId: Int, colorId: Int, search: String)
    case searchWallPaperNext(wallPaperId: Int, page: Int, key: String, sortId: Int, kindId: Int, colorId: Int)
    case searchWallPaperPrevious(wallPaperId: Int, page: Int, key: String, sortId: Int, kindId: Int, colorId: Int)
    ///分享
    case share(id: Int)
    ///赞
    case zan(id: Int)
    case zanList(page: Int, limit: Int)
    case zanWallPaperNext(wallPaperId: Int, page: Int)
    case zanWallPaperPrevious(wallPaperId: Int, page: Int)
    ///关注
    case attentionUser(id: Int)
    ///修改个人资料
    case changeUserInfo(type: UserInfoChangeType, value: String)
    ///手机绑定
    case changePhone(mobile: String, code: String, oldCode: String)
    case bindPhone(mobile: String, code: String)
    /// 上传文件
    case upFile(file: URL, dirName: String)
    case upImage(image: UIImage, dirName: String)
    /// 支付
    case payInfoList
}

extension NetAPI: TargetType {
    
    static var getBaseURL: String {
        return "http://testapi.cengew.cn/"
    }
    
    public var baseURL: URL {
        switch self {
        case let .downloadVideo(url: url):
            return URL(string: url)!
        default:
            let baseUrl = URL(string: NetAPI.getBaseURL)!
            return baseUrl
        }
        
    }
    
    public var path: String {
        switch self {
        case .homeRecommendList:
            return "api/wallpaper/index"
        case .homdBanner:
            return "api/Picture/index"
        case .aliAuth:
            return "api/user/mobile_one_click_login"
        case .updateUser:
            return "api/user/info"
        case .getCheckCode:
            return "api/common/send_mobile_code"
        case .rankWeek:
            return "api/Rank/week"
        case .rankMonth:
            return "api/Rank/month"
        case .rankAll:
            return "api/Rank/all"
        case .colorItems:
            return "api/color/data"
        case .colorList:
            return "api/color/wallpaper"
        case .kindItems:
            return "api/category/data"
        case .kindList:
            return "api/Category/wallpaper"
        case .firstWallPaper:
            return "api/wallpaper/index_slide"
        case .WallPaperNext:
            return "api/wallpaper/detail_up_slide"
        case .WallPaperPrevious:
            return "api/wallpaper/detail_down_slide"
        case .wallPaperUserHome:
            return "api/user/home"
        case .userWallPaperNext:
            return "api/user/home_up_slide"
        case .userWallPaperPrevious:
            return "api/user/home_down_slide"
        case .downloadVideo:
            return ""
        case .phoneLogin:
            return "api/user/mobile_code_reg_login"
        case .helpList:
            return "api/help/data"
        case .helpDetail:
            return "api/help/detail"
        case .helpTypes:
            return "api/feedback/types"
        case .messageList:
            return "api/message/data"
        case .attentionUserList:
            return "api/user/follow_list"
        case .homeSearchList:
            return "api/search/search_keys"
        case .search:
            return "api/search/data"
        case .searchWallPaperNext:
            return "api/search/up_slide"
        case .searchWallPaperPrevious:
            return "api/search/down_slide"
        case .rankWeekWallPaperNext:
            return "api/rank/week_up_slide"
        case .rankWeekWallPaperPrevious:
            return "api/rank/week_down_slide"
        case .rankMonthWallPaperNext:
            return "api/rank/month_up_slide"
        case .rankMonthWallPaperPrevious:
            return "api/rank/month_down_slide"
        case .rankAllWallPaperNext:
            return "api/rank/all_up_slide"
        case .rankAllWallPaperPrevious:
            return "api/rank/all_down_slide"
        case .share:
            return "api/common/share"
        case .zan:
            return "api/wallpaper/zan"
        case .attentionUser:
            return "api/wallpaper/follow"
        case .zanList:
            return "api/user/zan_list"
        case .zanWallPaperNext:
            return "api/user/zan_up_slide"
        case .zanWallPaperPrevious:
            return "api/user/zan_down_slide"
        case .changeUserInfo:
            return "api/user/edit_profile"
        case .changePhone:
            return "api/user/change_mobile"
        case .bindPhone:
            return "api/user/bind_mobile"
        case .upFile:
            return "api/common/upload"
        case .upImage:
            return "api/common/upload"
        case .payInfoList:
            return "api/vip/goods_list"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .downloadVideo:
            return .get
        default:
            return .post
        }
//        return .post
    }
    
    public var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8)!
    }
    
    public var task: Task {
        var params:[String:Any] = [:]
        
//        params["version"] = Bundle.main.infoDictionary?["CFBundleShortVersionString"]
//        params["platform"] = "1"
//        params["token"] = UserManager.shared.login.value?.token ?? ""
        
        switch self {
        case .homeRecommendList(let page, let limit):
            params["page"] = page
            params["limit"] = limit
        case .aliAuth(let token):
            params["access_token"] = token
        case .updateUser(let token):
            if let t = token {
                params["token"] = t
            }
        case let .getCheckCode(mobile: mobile, event: event):
            params["mobile"] = mobile
            params["event"] = event.rawValue
        case let .rankWeek(page, limit):
            params["page"] = page
            params["limit"] = limit
        case let .rankMonth(page, limit):
            params["page"] = page
            params["limit"] = limit
        case let .rankAll(page, limit):
            params["page"] = page
            params["limit"] = limit
        case let .colorList(id: id, page: page, limit: limit):
            params["page"] = page
            params["limit"] = limit
            params["color_id"] = id
        case let .kindList(id: id, page: page, limit: limit):
            params["page"] = page
            params["limit"] = limit
            params["category_id"] = id
        case let .firstWallPaper(p):
            params["items"] = p
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        case let .WallPaperNext(wallPaperId, page, categoryId, colorId):
            params["wallpaper_id"] = wallPaperId
            params["current_page"] = page
            params["category_id"] = categoryId
            params["color_id"] = colorId
        case let .WallPaperPrevious(wallPaperId, page, categoryId, colorId):
            params["wallpaper_id"] = wallPaperId
            params["current_page"] = page
            params["category_id"] = categoryId
            params["color_id"] = colorId
        case let .wallPaperUserHome(userId, page, limit):
            params["user_id"] = userId
            params["page"] = page
            params["limit"] = limit
        case let .userWallPaperNext(wallPaperId, userId):
            params["wallpaper_id"] = wallPaperId
            params["user_id"] = userId
        case let .userWallPaperPrevious(wallPaperId, userId):
            params["wallpaper_id"] = wallPaperId
            params["user_id"] = userId
        case let .downloadVideo(sourceUrl):
            return .downloadDestination { (url, httpResponse) -> (destinationURL: URL, options: DownloadRequest.Options) in
                return (NetVideoCache.shared.createPath(item: sourceUrl).url, .removePreviousFile)
            }
        case let .phoneLogin(mobile, checkCode):
            params["mobile"] = mobile
            params["code"] = checkCode
        case let .helpList(page, limit):
            params["page"] = page
            params["limit"] = limit
        case let .helpDetail(id):
            params["id"] = id
        case let .messageList(page, limit):
            params["page"] = page
            params["limit"] = limit
        case let .attentionUserList(page, limit):
            params["page"] = page
            params["limit"] = limit
        case let .search(page, limit, sortId, kindId, colorId, search):
            params["page"] = page
            params["limit"] = limit
            params["key"] = search
            params["category_id"] = kindId
            params["color_id"] = colorId
            params["order_field"] = sortId
        case let .searchWallPaperNext(wallPaperId, page, key, sortId, kindId, colorId):
            params["wallpaper_id"] = wallPaperId
            params["current_page"] = page
            params["key"] = key
            params["order_field"] = sortId
            params["category_id"] = kindId
            params["color_id"] = colorId
        case let .searchWallPaperPrevious(wallPaperId, page, key, sortId, kindId, colorId):
            params["wallpaper_id"] = wallPaperId
            params["current_page"] = page
            params["key"] = key
            params["order_field"] = sortId
            params["category_id"] = kindId
            params["color_id"] = colorId
        case let .rankWeekWallPaperNext(page, wallPaperId):
            params["wallpaper_id"] = wallPaperId
            params["current_page"] = page
        case let .rankWeekWallPaperPrevious(page, wallPaperId):
            params["wallpaper_id"] = wallPaperId
            params["current_page"] = page
        case let .rankMonthWallPaperNext(page, wallPaperId):
            params["wallpaper_id"] = wallPaperId
            params["current_page"] = page
        case let .rankMonthWallPaperPrevious(page, wallPaperId):
            params["wallpaper_id"] = wallPaperId
            params["current_page"] = page
        case let .rankAllWallPaperNext(page, wallPaperId):
            params["wallpaper_id"] = wallPaperId
            params["current_page"] = page
        case let .rankAllWallPaperPrevious(page, wallPaperId):
            params["wallpaper_id"] = wallPaperId
            params["current_page"] = page
        case let .share(id):
            params["wallpaper_id"] = id
        case let .zan(id):
            params["wallpaper_id"] = id
        case let .attentionUser(id):
            params["to_user_id"] = id
        case let .zanList(page, limit):
            params["page"] = page
            params["limit"] = limit
        case let .zanWallPaperNext(wallPaperId, page):
            params["page"] = page
            params["wallpaper_id"] = wallPaperId
        case let .zanWallPaperPrevious(wallPaperId, page):
            params["page"] = page
            params["wallpaper_id"] = wallPaperId
        case let .changeUserInfo(type, value):
            params["field"] = type.rawValue
            params["field_val"] = value
        case let .changePhone(mobile, code, oldCode):
            params["old_code"] = oldCode
            params["code"] = code
            params["mobile"] = mobile
        case let .bindPhone(mobile, code):
            params["mobile"] = mobile
            params["code"] = code
        case let .upFile(file, dirName):
            params["upload_dir"] = dirName
            let data = Moya.MultipartFormData(provider: .file(file), name: "file")
            return .uploadCompositeMultipart([data], urlParameters: params)
        case let .upImage(image, dirName):
            params["upload_dir"] = dirName
            let imgData = image.jpegData(compressionQuality: 0.8) ?? Data()
            let data = Moya.MultipartFormData(provider: .data(imgData), name: "file", fileName: "file.png", mimeType: "image/jpg")
            return .uploadCompositeMultipart([data], urlParameters: params)
        default:
            break
        }
//
        return .requestParameters(parameters: params, encoding: URLEncoding.default)
    }
    
    public var headers: [String : String]? {
        var headers:[String : String] = [:]
        headers["device_id"] = UIDevice.current.uuid()
        headers["client_type"] = "1"
        headers["channel"] = "App Store"
        headers["version"] = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        headers["token"] = UserManager.shared.login.value?.token ?? ""
        switch self {
        case .updateUser(let token):
            if let t = token {
                headers["token"] = t
            }
        default:
            break
        }
        return headers
    }
    
    
    
    
}

