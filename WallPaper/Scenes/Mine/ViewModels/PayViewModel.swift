//
//  PayViewModel.swift
//  WallPaper
//
//  Created by LiQi on 2020/5/25.
//  Copyright © 2020 Qire. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class PayViewModel: ViewModel, ViewModelType {
    
    struct Input {
        let request: Observable<Void>
    }
    
    struct Output {
        let items: PublishRelay<[PayInfoModel]>
        let showErrorView: BehaviorRelay<Bool>
        let showEmptyView: BehaviorRelay<Bool>
    }
    
    func transform(input: Input) -> Output {
        
        let items = PublishRelay<[PayInfoModel]>()
        let showErrorView = BehaviorRelay<Bool>(value: false)
        let showEmptyView = BehaviorRelay<Bool>(value: false)
        
        input.request.subscribe(onNext: { [weak self] type in
            guard let self = self else { return }
            showEmptyView.accept(false)
            showErrorView.accept(false)
            self.requestList().subscribe(onNext: { models in
                if models.isEmpty {
                    showEmptyView.accept(true)
                } else {
                    items.accept(models)
                }
            }, onError: { error in
                showErrorView.accept(true)
            }).disposed(by: self.rx.disposeBag)
        }).disposed(by: rx.disposeBag)
        
        return Output(items: items,
                      showErrorView: showErrorView,
                      showEmptyView: showEmptyView)
    }
    
    /// MARK: - Request
    
    func requestList() -> Observable<[PayInfoModel]> {
        return NetManager.requestObjArray(.payInfoList, type: PayInfoModel.self).asObservable().trackError(error).trackActivity(loading)
    }
    
}
