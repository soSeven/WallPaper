//
//  WallPapreListViewModel.swift
//  WallPaper
//
//  Created by LiQi on 2020/4/17.
//  Copyright © 2020 Qire. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class WallPapreListViewModel: ViewModel, ViewModelType {
    
    private let limit = 10
    private var page = 1
    
    private let service: WallPaperListService
    
    struct Input {
        let headerRefresh: Observable<Void>
        let footerRefresh: Observable<Void>
    }
    
    struct Output {
        let items: BehaviorRelay<[WallPaperInfoModel]>
        let footerLoading: BehaviorRelay<RefreshFooterStatus>
        let headerLoading: ActivityIndicator
        let firstLoading: BehaviorRelay<Bool>
        let showErrorView: BehaviorRelay<Bool>
        let showEmptyView: BehaviorRelay<Bool>
    }
    
    init(service: WallPaperListService) {
        self.service = service
        super.init()
    }
    
    func transform(input: WallPapreListViewModel.Input) -> WallPapreListViewModel.Output {
        
        let elements = BehaviorRelay<[WallPaperInfoModel]>(value: [])
        let footerStatus = BehaviorRelay<RefreshFooterStatus>(value: .hidden)
        let headerLoading = ActivityIndicator()
        let firstLoading = BehaviorRelay<Bool>(value: false)
        let showErrorView = BehaviorRelay<Bool>(value: false)
        let showEmptyView = BehaviorRelay<Bool>(value: false)
        
        input.headerRefresh.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.page = 1
            firstLoading.accept(elements.value.count == 0)
            showErrorView.accept(false)
            showEmptyView.accept(false)
            self.requestList().trackActivity(headerLoading).subscribe(onNext: { [weak self] items in
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
            self.requestList().subscribe(onNext: { [weak self] items in
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
                footerStatus.accept(.normal)
            }).disposed(by: self.rx.disposeBag)
        }).disposed(by: rx.disposeBag)
        
        return Output(items: elements,
                      footerLoading: footerStatus,
                      headerLoading: headerLoading,
                      firstLoading: firstLoading,
                      showErrorView: showErrorView,
                      showEmptyView: showEmptyView)
    }
    
    /// MARK: - Request
    
    func requestList() -> Observable<[WallPaperInfoModel]> {
        
        return self.service.requestWallPaperList(page: page, limit: limit).trackActivity(loading).trackError(error)
        
    }
    
}
