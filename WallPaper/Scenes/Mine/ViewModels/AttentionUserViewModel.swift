//
//  AttentionUserViewModel.swift
//  WallPaper
//
//  Created by LiQi on 2020/4/29.
//  Copyright © 2020 Qire. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class AttentionUserViewModel: ViewModel, ViewModelType {
    
    private let limit = 10
    private var page = 1
    
    struct Input {
        let headerRefresh: Observable<Void>
        let footerRefresh: Observable<Void>
    }
    
    struct Output {
        let items: BehaviorRelay<[AttentionUserCellViewModel]>
        let footerLoading: BehaviorRelay<RefreshFooterStatus>
        let headerLoading: ActivityIndicator
        let firstLoading: BehaviorRelay<Bool>
        let showErrorView: BehaviorRelay<Bool>
        let showEmptyView: BehaviorRelay<Bool>
    }
    
    func transform(input: Input) -> Output {
        
        let elements = BehaviorRelay<[AttentionUserCellViewModel]>(value: [])
        let footerStatus = BehaviorRelay<RefreshFooterStatus>(value: .hidden)
        let headerLoading = ActivityIndicator()
        let firstLoading = BehaviorRelay<Bool>(value: true)
        let showErrorView = BehaviorRelay<Bool>(value: false)
        let showEmptyView = BehaviorRelay<Bool>(value: false)
        
        input.headerRefresh.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.page = 1
            showErrorView.accept(false)
            firstLoading.accept(elements.value.count == 0)
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
    
    func requestList() -> Observable<[AttentionUserCellViewModel]> {
        return NetManager.requestObjArray(.attentionUserList(page: page, limit: limit), type: AttentionUserListModel.self).asObservable().mapMany {
            self.getCellViewModel(model: $0)
        }.trackActivity(loading).trackError(error)
    }
    
    private func getCellViewModel(model: AttentionUserListModel) -> AttentionUserCellViewModel{
        let cellViewModel = AttentionUserCellViewModel(model: model)
        cellViewModel.parsedError.bind(to: parsedError).disposed(by: rx.disposeBag)
        return cellViewModel
    }
    
}
