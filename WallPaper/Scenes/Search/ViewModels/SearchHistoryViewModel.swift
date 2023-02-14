//
//  SearchHistoryViewModel.swift
//  WallPaper
//
//  Created by LiQi on 2020/4/30.
//  Copyright © 2020 Qire. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class SearchHistoryViewModel: ViewModel, ViewModelType {
    
    struct Input {
        let deleteHistoryRecord: PublishRelay<Void>
        let addHistoryRecord: PublishRelay<String>
        let requestHot: Observable<Void>
    }
    
    struct Output {
        let historyItems: BehaviorRelay<[String]>
        let hotItems: BehaviorRelay<[SearchHomeListModel]>
    }
    
    func transform(input: Input) -> Output {
        
        // history
        let historyItems = BehaviorRelay<[String]>(value: NetSearchCache.shared.getAll())
    
        input.addHistoryRecord.subscribe(onNext: { record in
            var arr = NetSearchCache.shared.getAll()
            arr.removeAll(record)
            arr.insert(record, at: 0)
            if arr.count > 10 {
               let _ = arr.popLast()
            }
            NetSearchCache.shared.save(item: arr)
            historyItems.accept(arr)
        }).disposed(by: rx.disposeBag)
        
        input.deleteHistoryRecord.subscribe(onNext: { _ in
            NetSearchCache.shared.deleteAll()
            historyItems.accept([])
        }).disposed(by: rx.disposeBag)
        
        // hot
        let hotItems = BehaviorRelay<[SearchHomeListModel]>(value:[])
        
        input.requestHot.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            self.requestSearchList().subscribe(onNext: { models in
                hotItems.accept(models)
            }).disposed(by: self.rx.disposeBag)
        }).disposed(by: rx.disposeBag)
        
        return Output(historyItems: historyItems,
                      hotItems: hotItems)
    }
    
    // MARK: - Request
    
    func requestSearchList() -> Observable<[SearchHomeListModel]> {
        return NetManager.requestObjArray(.homeSearchList, type: SearchHomeListModel.self).asObservable().catchErrorJustReturn([])
    }
}
