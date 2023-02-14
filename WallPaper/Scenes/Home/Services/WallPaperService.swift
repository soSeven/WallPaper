//
//  WallPaperService.swift
//  WallPaper
//
//  Created by LiQi on 2020/4/18.
//  Copyright © 2020 Qire. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import SwiftyJSON

protocol WallPaperService {
    
    func requestCurrentWallPaper(jsonDict: [[String:Any]]) -> Observable<[WallPaperModel]>
    
    func requestNextWallPaper(item: WallPaperModel) -> Observable<[WallPaperModel]>
    
    func requestPreviousWallPaper(item: WallPaperModel) -> Observable<[WallPaperModel]>
    
}

class RankWallPaperService: WallPaperService {
    
    let type: Int

    required init(type: Int) {
        self.type = type
    }
    
    func requestCurrentWallPaper(jsonDict: [[String:Any]]) -> Observable<[WallPaperModel]> {
        
        let jsonData = try? JSONSerialization.data(withJSONObject: jsonDict, options: [])
        var decoded = ""
        if let jsonData = jsonData {
            decoded = String(data: jsonData, encoding: .utf8) ?? ""
        }
        
        return NetManager.requestObjArray(.firstWallPaper(para: decoded), type: WallPaperModel.self).asObservable()
    }
    
    func requestNextWallPaper(item: WallPaperModel) -> Observable<[WallPaperModel]> {
        var request: NetAPI = .rankWeekWallPaperNext(page: item.page, wallPaperId: item.id)
        switch type {
        case 1:
            request = .rankMonthWallPaperNext(page: item.page, wallPaperId: item.id)
        case 2:
            request = .rankAllWallPaperNext(page: item.page, wallPaperId: item.id)
        default:
            break
        }
        return NetManager.requestObjArray(request, type: WallPaperModel.self).asObservable()
    }
    
    func requestPreviousWallPaper(item: WallPaperModel) -> Observable<[WallPaperModel]> {
        var request: NetAPI = .rankWeekWallPaperPrevious(page: item.page, wallPaperId: item.id)
        switch type {
        case 1:
            request = .rankMonthWallPaperPrevious(page: item.page, wallPaperId: item.id)
        case 2:
            request = .rankAllWallPaperPrevious(page: item.page, wallPaperId: item.id)
        default:
            break
        }
        return NetManager.requestObjArray(request, type: WallPaperModel.self).asObservable()
    }
}

class ColorWallPaperService: WallPaperService {
    
    let colorId: Int
    
    required init(colorId: Int) {
        self.colorId = colorId
    }
    
    func requestCurrentWallPaper(jsonDict: [[String:Any]]) -> Observable<[WallPaperModel]> {
        
        let jsonData = try? JSONSerialization.data(withJSONObject: jsonDict, options: [])
        var decoded = ""
        if let jsonData = jsonData {
            decoded = String(data: jsonData, encoding: .utf8) ?? ""
        }
        
        return NetManager.requestObjArray(.firstWallPaper(para: decoded), type: WallPaperModel.self).asObservable()
    }
    
    func requestNextWallPaper(item: WallPaperModel) -> Observable<[WallPaperModel]> {
        return NetManager.requestObjArray(.WallPaperNext(wallPaperId: item.id, page: item.page, categoryId: 0, colorId: colorId), type: WallPaperModel.self).asObservable()
    }
    
    func requestPreviousWallPaper(item: WallPaperModel) -> Observable<[WallPaperModel]> {
        return NetManager.requestObjArray(.WallPaperPrevious(wallPaperId: item.id, page: item.page, categoryId: 0, colorId: colorId), type: WallPaperModel.self).asObservable()
    }
    
    
}

class KindWallPaperService: WallPaperService {
    
    let categoryId: Int
    
    required init(categoryId: Int) {
        self.categoryId = categoryId
    }
    
    func requestCurrentWallPaper(jsonDict: [[String:Any]]) -> Observable<[WallPaperModel]> {
        
        let jsonData = try? JSONSerialization.data(withJSONObject: jsonDict, options: [])
        var decoded = ""
        if let jsonData = jsonData {
            decoded = String(data: jsonData, encoding: .utf8) ?? ""
        }
        
        return NetManager.requestObjArray(.firstWallPaper(para: decoded), type: WallPaperModel.self).asObservable()
    }
    
    func requestNextWallPaper(item: WallPaperModel) -> Observable<[WallPaperModel]> {
        return NetManager.requestObjArray(.WallPaperNext(wallPaperId: item.id, page: item.page, categoryId: categoryId, colorId: 0), type: WallPaperModel.self).asObservable()
    }
    
    func requestPreviousWallPaper(item: WallPaperModel) -> Observable<[WallPaperModel]> {
        return NetManager.requestObjArray(.WallPaperPrevious(wallPaperId: item.id, page: item.page, categoryId: categoryId, colorId: 0), type: WallPaperModel.self).asObservable()
    }
    
    
}

class HomeUserWallPaperService: WallPaperService {
    
    let userId: Int
    
    required init(userId: Int) {
        self.userId = userId
    }
    
    func requestCurrentWallPaper(jsonDict: [[String:Any]]) -> Observable<[WallPaperModel]> {
//        let dict = [[
//            "page": Int(item.page) ?? 0,
//            "id": item.id
//        ]]
        let jsonData = try? JSONSerialization.data(withJSONObject: jsonDict, options: [])
        var decoded = ""
        if let jsonData = jsonData {
            decoded = String(data: jsonData, encoding: .utf8) ?? ""
        }
        
        return NetManager.requestObjArray(.firstWallPaper(para: decoded), type: WallPaperModel.self).asObservable()
    }
    
    func requestNextWallPaper(item: WallPaperModel) -> Observable<[WallPaperModel]> {
        return NetManager.requestObjArray(.userWallPaperNext(wallPaperId: item.id, userId: userId), type: WallPaperModel.self).asObservable()
    }
    
    func requestPreviousWallPaper(item: WallPaperModel) -> Observable<[WallPaperModel]> {
        return NetManager.requestObjArray(.userWallPaperPrevious(wallPaperId: item.id, userId: userId), type: WallPaperModel.self).asObservable()
    }
    
    
}

class SearchWallPaperService: WallPaperService {
    
    let kindId: Int
    let sortId: Int
    let colorId: Int
    let search: String
    
    required init(sortId: Int, kindId: Int, colorId: Int, search: String) {
        self.sortId = sortId
        self.kindId = kindId
        self.colorId = colorId
        self.search = search
    }
    
    func requestCurrentWallPaper(jsonDict: [[String:Any]]) -> Observable<[WallPaperModel]> {
        
        let jsonData = try? JSONSerialization.data(withJSONObject: jsonDict, options: [])
        var decoded = ""
        if let jsonData = jsonData {
            decoded = String(data: jsonData, encoding: .utf8) ?? ""
        }
        return NetManager.requestObjArray(.firstWallPaper(para: decoded), type: WallPaperModel.self).asObservable()
    }
    
    func requestNextWallPaper(item: WallPaperModel) -> Observable<[WallPaperModel]> {
        return NetManager.requestObjArray(.searchWallPaperNext(wallPaperId: item.id, page: item.page, key: search, sortId: sortId, kindId: kindId, colorId: colorId), type: WallPaperModel.self).asObservable()
    }
    
    func requestPreviousWallPaper(item: WallPaperModel) -> Observable<[WallPaperModel]> {
        return NetManager.requestObjArray(.searchWallPaperPrevious(wallPaperId: item.id, page: item.page, key: search, sortId: sortId, kindId: kindId, colorId: colorId), type: WallPaperModel.self).asObservable()
    }
    
    
}

class ZanWallPaperService: WallPaperService {
     
    func requestCurrentWallPaper(jsonDict: [[String:Any]]) -> Observable<[WallPaperModel]> {
        
        let jsonData = try? JSONSerialization.data(withJSONObject: jsonDict, options: [])
        var decoded = ""
        if let jsonData = jsonData {
            decoded = String(data: jsonData, encoding: .utf8) ?? ""
        }
        
        return NetManager.requestObjArray(.firstWallPaper(para: decoded), type: WallPaperModel.self).asObservable()
    }
    
    func requestNextWallPaper(item: WallPaperModel) -> Observable<[WallPaperModel]> {
        return NetManager.requestObjArray(.zanWallPaperNext(wallPaperId: item.id, page: item.page), type: WallPaperModel.self).asObservable()
    }
    
    func requestPreviousWallPaper(item: WallPaperModel) -> Observable<[WallPaperModel]> {
        return NetManager.requestObjArray(.zanWallPaperPrevious(wallPaperId: item.id, page: item.page), type: WallPaperModel.self).asObservable()
    }
    
    
}
