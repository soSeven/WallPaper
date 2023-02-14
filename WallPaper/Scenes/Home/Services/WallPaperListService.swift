//
//  WallPaperListService.swift
//  WallPaper
//
//  Created by LiQi on 2020/4/17.
//  Copyright © 2020 Qire. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol WallPaperListService {
    
    func requestWallPaperList(page: Int, limit: Int) -> Observable<[WallPaperInfoModel]>
}

class RankWeekWallPaperListService: WallPaperListService {

    func requestWallPaperList(page: Int, limit: Int) -> Observable<[WallPaperInfoModel]> {
        
        return NetManager.requestObjArray(.rankWeek(page: page, limit: limit), type: WallPaperInfoModel.self).asObservable()
    }
}

class RankMonthWallPaperListService: WallPaperListService {

    func requestWallPaperList(page: Int, limit: Int) -> Observable<[WallPaperInfoModel]> {
        
        return NetManager.requestObjArray(.rankMonth(page: page, limit: limit), type: WallPaperInfoModel.self).asObservable()
    }
    
}

class RankAllWallPaperListService: WallPaperListService {

    func requestWallPaperList(page: Int, limit: Int) -> Observable<[WallPaperInfoModel]> {
        
        return NetManager.requestObjArray(.rankAll(page: page, limit: limit), type: WallPaperInfoModel.self).asObservable()
    }
    
}

class ColorWallPaperListService: WallPaperListService {
    
    let id: Int
    
    init(id: Int) {
        self.id = id
    }

    func requestWallPaperList(page: Int, limit: Int) -> Observable<[WallPaperInfoModel]> {
        
        return NetManager.requestObjArray(.colorList(id: id, page: page, limit: limit), type: WallPaperInfoModel.self).asObservable()
    }
    
}

class KindWallPaperListService: WallPaperListService {
    
    let id: Int
    
    init(id: Int) {
        self.id = id
    }

    func requestWallPaperList(page: Int, limit: Int) -> Observable<[WallPaperInfoModel]> {
        
        return NetManager.requestObjArray(.kindList(id: id, page: page, limit: limit), type: WallPaperInfoModel.self).asObservable()
    }
    
}

class ZanWallPaperListService: WallPaperListService {
    
    func requestWallPaperList(page: Int, limit: Int) -> Observable<[WallPaperInfoModel]> {
        
        return NetManager.requestObjArray(.zanList(page: page, limit: limit), type: WallPaperInfoModel.self).asObservable()
    }
    
}


