//
//  HomeViewModel.swift
//  WallPaper
//
//  Created by LiQi on 2020/4/11.
//  Copyright © 2020 Qire. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class HomeViewModel: ViewModel, ViewModelType {
    
    private let limit = 10
    private var page = 1
    private let elements = BehaviorRelay<[WallPaperInfoModel]>(value: [])
    private let footerStatus = BehaviorRelay<RefreshFooterStatus>(value: .hidden)
    
    struct Input {
        let requestSearchList: Observable<Void>
        let headerRefresh: Observable<Void>
        let footerRefresh: Observable<Void>
    }
    
    struct Output {
        let items: BehaviorRelay<[WallPaperInfoModel]>
        let banners: BehaviorRelay<[BannerModel]>
        let footerLoading: BehaviorRelay<RefreshFooterStatus>
        let headerLoading: ActivityIndicator
        let search: PublishRelay<SearchHomeListModel>
    }
    
    func transform(input: Input) -> Output {
        
        let headerLoading = ActivityIndicator()
        
        let headerObserver = input.headerRefresh.flatMapLatest { [weak self] () -> Observable<[WallPaperInfoModel]> in
            guard let self = self else { return Observable.just([]) }
            self.page = 1
            return self.requestRecommendList().trackActivity(headerLoading)
        }.share(replay: 1)
        
        let footerObserver = input.footerRefresh.flatMapLatest { [weak self] () -> Observable<[WallPaperInfoModel]> in
            guard let self = self else { return Observable.just([]) }
            self.page += 1
            return self.requestRecommendList()
        }.share(replay: 1)
        
        headerObserver.subscribe(onNext: { [weak self] items in
            guard let self = self else { return }
            self.elements.accept(items)
        }).disposed(by: rx.disposeBag)
        
        footerObserver.subscribe(onNext: { [weak self] items in
            guard let self = self else { return }
            self.elements.accept(self.elements.value + items)
        }).disposed(by: rx.disposeBag)
        
        let footerStatus1 = headerObserver.map { [weak self] items -> RefreshFooterStatus in
            guard let self = self else { return .hidden }
            if items.count >= self.limit {
                return .normal
            }
            return .noData
        }.asDriver(onErrorJustReturn: .hidden)
        
        let footerStatus2 = footerObserver.map { [weak self] items -> RefreshFooterStatus in
            guard let self = self else { return .normal }
            if items.count >= self.limit {
                return .normal
            }
            return .noData
        }.asDriver(onErrorJustReturn: .normal)

        Observable.merge(footerStatus1.asObservable(), footerStatus2.asObservable()).bind(to: footerStatus).disposed(by: rx.disposeBag)
        
        parsedError.subscribe(onNext: {[weak self] error in
            guard let self = self else { return }
            if self.page == 1 {
                self.footerStatus.accept(.hidden)
            } else {
                self.page -= 1
                self.footerStatus.accept(.normal)
            }
        }).disposed(by: rx.disposeBag)
        
        // banner
        
        let bannersRelay = BehaviorRelay<[BannerModel]>(value: [])
        
        input.headerRefresh.flatMapLatest { [weak self] () -> Observable<[BannerModel]> in
            guard let self = self else { return Observable.just([])}
            return self.requestBannerList()
        }.subscribe(onNext: { banners in
            bannersRelay.accept(banners)
        }).disposed(by: rx.disposeBag)
        
        // Search
        var index = 0
        let searchRelay = PublishRelay<SearchHomeListModel>()
        input.requestSearchList.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            self.requestSearchList().subscribe(onNext: {[weak self] searchModels in
                guard let self = self else { return }
                if searchModels.isEmpty {
                    return
                }
                Observable<Int>.timer(RxTimeInterval.seconds(0), period: RxTimeInterval.seconds(4), scheduler: MainScheduler.instance).subscribe(onNext: { _ in
                    if index >= searchModels.count {
                        index = 0
                    }
                    let current = searchModels[index]
                    searchRelay.accept(current)
                    index += 1
                }).disposed(by: self.rx.disposeBag)
            }).disposed(by: self.rx.disposeBag)
        }).disposed(by: rx.disposeBag)
        
        return Output(items: elements,
                      banners: bannersRelay,
                      footerLoading: footerStatus,
                      headerLoading: headerLoading,
                      search: searchRelay)
    }
    
    /// MARK: - Request
    
    func requestRecommendList() -> Observable<[WallPaperInfoModel]> {
        
        return NetManager.requestObjArray(.homeRecommendList(page: page, limit: limit), type: WallPaperInfoModel.self).asObservable().trackError(error).catchErrorJustComplete()
    }
    
    func requestBannerList() -> Observable<[BannerModel]> {
        return NetManager.requestObjArray(.homdBanner, type: BannerModel.self).asObservable().catchErrorJustReturn([])
    }
    
    func requestSearchList() -> Observable<[SearchHomeListModel]> {
        return NetManager.requestObjArray(.homeSearchList, type: SearchHomeListModel.self).asObservable().catchErrorJustReturn([])
    }
    
}
