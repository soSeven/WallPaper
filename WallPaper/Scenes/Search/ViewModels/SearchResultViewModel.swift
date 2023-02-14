//
//  SearchResultViewModel.swift
//  WallPaper
//
//  Created by LiQi on 2020/5/6.
//  Copyright © 2020 Qire. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class SearchResultViewModel: ViewModel, ViewModelType {
    
    private let limit = 10
    private var page = 1
    private var sortId = 0
    private var kindId = 0
    private var colorId = 0
    private var searchStr = ""
    
    struct Input {
        let search: Observable<(Int, Int, Int, String)>
        let footerRefresh: Observable<Void>
        let requestList: Observable<Void>
    }
    
    struct Output {
        let list: PublishRelay<([String], [KindItemModel], [ColorItemModel])>
        let items: BehaviorRelay<[WallPaperInfoModel]>
        let footerLoading: BehaviorRelay<RefreshFooterStatus>
        let firstLoading: BehaviorRelay<Bool>
        let showErrorView: BehaviorRelay<Bool>
        let showEmptyView: BehaviorRelay<Bool>
    }
    
    func transform(input: Input) -> Output {
        
        let elements = BehaviorRelay<[WallPaperInfoModel]>(value: [])
        let footerStatus = BehaviorRelay<RefreshFooterStatus>(value: .hidden)
        let firstLoading = BehaviorRelay<Bool>(value: false)
        let showErrorView = BehaviorRelay<Bool>(value: false)
        let showEmptyView = BehaviorRelay<Bool>(value: false)
        
        input.search.subscribe(onNext: {[weak self] s in
            guard let self = self else { return }
            let (sortId, kindId, colorId, searchStr) = s
            self.page = 1
            self.sortId = sortId
            self.kindId = kindId
            self.colorId = colorId
            self.searchStr = searchStr
            elements.accept([])
            firstLoading.accept(true)
            footerStatus.accept(.hidden)
            showEmptyView.accept(false)
            showErrorView.accept(false)
            self.requesSearch().subscribe(onNext: {[weak self] items in
                guard let self = self else { return }
                elements.accept(items)
                showEmptyView.accept(items.count == 0)
                if items.count >= self.limit {
                    footerStatus.accept(.normal)
                } else {
                    footerStatus.accept(.noData)
                }
                firstLoading.accept(false)
            }, onError: { error in
                firstLoading.accept(false)
                footerStatus.accept(.hidden)
                showErrorView.accept(elements.value.count == 0)
            }).disposed(by: self.rx.disposeBag)
        }).disposed(by: rx.disposeBag)
        
        input.footerRefresh.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.page += 1
            self.requesSearch().subscribe(onNext: { [weak self] items in
                guard let self = self else { return }
                elements.accept(elements.value + items)
                if items.count >= self.limit {
                    footerStatus.accept(.normal)
                } else {
                    footerStatus.accept(.noData)
                }
            }, onError: {[weak self] error in
                guard let self = self else { return }
                self.page -= 1
            }).disposed(by: self.rx.disposeBag)
        }).disposed(by: rx.disposeBag)
      
        let dropList = PublishRelay<([String], [KindItemModel], [ColorItemModel])>()
        input.requestList.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            self.requestList().subscribe(onNext: { (kindList, colorList) in
                dropList.accept((["按热度", "按更新"], kindList, colorList))
            }).disposed(by: self.rx.disposeBag)
        }).disposed(by: rx.disposeBag)
        
        return Output(list: dropList,
                      items: elements,
                      footerLoading: footerStatus,
                      firstLoading: firstLoading,
                      showErrorView: showErrorView,
                      showEmptyView: showEmptyView)
    }
    
    // MARK: - Request
    
    func requesSearch() -> Observable<[WallPaperInfoModel]> {
        return NetManager.requestObjArray(.search(page: page, limit: limit, sortId: sortId, kindId: kindId, colorId: colorId, search: searchStr), type: WallPaperInfoModel.self).trackActivity(loading).trackError(error).asObservable()
    }
    
    
    func requestList() -> Observable<([KindItemModel], [ColorItemModel])> {
        return Observable.zip(requestKindList(), requestColorList()).trackActivity(loading).trackError(error)
    }
    
    func requestColorList() -> Observable<[ColorItemModel]> {
        return NetManager.requestObjArray(.colorItems, type: ColorItemModel.self).asObservable()
    }
    
    func requestKindList() -> Observable<[KindItemModel]> {
        return NetManager.requestObjArray(.kindItems, type: KindItemModel.self).asObservable()
    }
}

