//
//  ListService.swift
//  WallPaper
//
//  Created by LiQi on 2020/4/29.
//  Copyright © 2020 Qire. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

protocol ListService {
    
    func requestList<T: Mapable>(page: Int, limit: Int, type: T.Type) -> Observable<[T]>
    
}

class MessageListService: ListService {
    
    func requestList<T: Mapable>(page: Int, limit: Int, type: T.Type) -> Observable<[T]> {
        return NetManager.requestObjArray(.messageList(page: page, limit: limit), type: T.self).asObservable()
    }
    
}
