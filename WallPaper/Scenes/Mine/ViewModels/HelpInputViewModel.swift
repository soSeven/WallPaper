//
//  HelpInputViewModel.swift
//  WallPaper
//
//  Created by LiQi on 2020/4/28.
//  Copyright © 2020 Qire. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class HelpInputViewModel: ViewModel, ViewModelType {
    
    struct Input {
        let request: Observable<Void>
    }
    
    struct Output {
        let item: PublishRelay<[HelpTypeModel]>
        let showErrorView: BehaviorRelay<Bool>
        let showEmptyView: BehaviorRelay<Bool>
    }
    
    func transform(input: Input) -> Output {
        
        let item = PublishRelay<[HelpTypeModel]>()
        let showErrorView = BehaviorRelay<Bool>(value: false)
        let showEmptyView = BehaviorRelay<Bool>(value: false)
        
        input.request.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            showErrorView.accept(false)
            self.requestDetail().subscribe(onNext: { items in
                if !items.isEmpty {
                    item.accept(items)
                } else {
                    showEmptyView.accept(true)
                }
            }, onError: { error in
                showErrorView.accept(true)
            }).disposed(by: self.rx.disposeBag)
        }).disposed(by: rx.disposeBag)
        
        return Output(item: item,
                      showErrorView: showErrorView,
                      showEmptyView: showEmptyView)
    }
    
    /// MARK: - Request
    
    func requestDetail() -> Observable<[HelpTypeModel]> {
        return NetManager.requestObjArray(.helpTypes, type: HelpTypeModel.self).trackActivity(loading).trackError(error)
    }
    
}
