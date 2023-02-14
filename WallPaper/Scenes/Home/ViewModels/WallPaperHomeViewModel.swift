//
//  WallPaperHomeViewModel.swift
//  WallPaper
//
//  Created by LiQi on 2020/4/21.
//  Copyright © 2020 Qire. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class WallPaperHomeViewModel: ViewModel, ViewModelType {
    
    private let limit = 10
    private var page = 1
    let userId: Int
    
    struct Input {
        let request: Driver<Void>
        let footerRefresh: Driver<Void>
        let attention: ControlEvent<Void>
    }
    
    struct Output {
        let user: BehaviorRelay<WallPaperUserModel?>
        let items: BehaviorRelay<[WallPaperSectionListModel]>
        let firstLoading: BehaviorRelay<Bool>
        let showErrorView: BehaviorRelay<Bool>
        let footerLoading: BehaviorRelay<RefreshFooterStatus>
        let isAttention: PublishRelay<Bool>
    }
    
    required init(userId: Int) {
        self.userId = userId
    }
    
    func transform(input: WallPaperHomeViewModel.Input) -> WallPaperHomeViewModel.Output {
        
        let items = BehaviorRelay<[WallPaperSectionListModel]>(value: [])
        let user = BehaviorRelay<WallPaperUserModel?>(value: nil)
        let showErrorView = BehaviorRelay<Bool>(value: false)
        let footerLoading = BehaviorRelay<RefreshFooterStatus>(value: .hidden)
        let firstLoading = BehaviorRelay<Bool>(value: false)
        let isAttention = PublishRelay<Bool>()
        
        input.request.drive(onNext: { [weak self] _ in
            guard let self = self else { return }
            showErrorView.accept(false)
            footerLoading.accept(.hidden)
            firstLoading.accept(true)
            self.page = 1
            self.requestList().subscribe(onNext: { homeModel in
                guard let model = homeModel else { return }
                items.accept(model.datePage)
                user.accept(model.user)
                footerLoading.accept(.normal)
                firstLoading.accept(false)
            }, onError: { error in
                showErrorView.accept(true)
                firstLoading.accept(false)
            }).disposed(by: self.rx.disposeBag)
        }).disposed(by: rx.disposeBag)
        
        input.footerRefresh.drive(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.page += 1
            self.requestList().subscribe(onNext: { homeModel in
                guard let model = homeModel else { return }
                if model.datePage.count == 0 {
                    footerLoading.accept(.noData)
                    self.page -= 1
                } else {
                    items.accept(items.value + model.datePage)
                    footerLoading.accept(.normal)
                }
            }, onError: { error in
                showErrorView.accept(true)
                self.page -= 1
                footerLoading.accept(.normal)
            }).disposed(by: self.rx.disposeBag)
        }).disposed(by: rx.disposeBag)
        
        input.attention.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            guard let v = user.value else { return }
            let lastStatus = v.isFollow
            v.isFollow = !v.isFollow
            user.accept(v)
            self.requestAttention().subscribe(onNext: { m in
                v.isFollow = m?.followStatus ?? lastStatus
                user.accept(v)
                isAttention.accept(v.isFollow)
            }, onError: { error in
                v.isFollow = lastStatus
                user.accept(v)
            }).disposed(by: self.rx.disposeBag)
        }).disposed(by: rx.disposeBag)
        
        return Output(user: user,
                      items: items,
                      firstLoading: firstLoading,
                      showErrorView: showErrorView,
                      footerLoading: footerLoading,
                      isAttention: isAttention)
    }
    
    /// MARK: - Request
    
    func requestList() -> Observable<WallPaperHomeModel?> {
        
        return NetManager.requestObj(.wallPaperUserHome(userId: userId, page: page, limit: limit), type: WallPaperHomeModel.self).trackError(error).asObservable()
        
    }
    
    private func requestAttention() -> Observable<AttentionUserModel?> {
        return NetManager.requestObj(.attentionUser(id: userId), type: AttentionUserModel.self).asObservable().trackError(error)
    }
}
