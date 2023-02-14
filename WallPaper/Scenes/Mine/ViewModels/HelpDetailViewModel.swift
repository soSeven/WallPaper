//
//  HelpDetailViewModel.swift
//  WallPaper
//
//  Created by LiQi on 2020/4/27.
//  Copyright © 2020 Qire. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class HelpDetailViewModel: ViewModel, ViewModelType {
    
    var id: Int
    
    struct Input {
        let request: Observable<Void>
    }
    
    struct Output {
        let item: PublishRelay<HelpDetailModel>
        let showErrorView: BehaviorRelay<Bool>
        let showEmptyView: BehaviorRelay<Bool>
    }
    
    required init(id: Int) {
        self.id = id
        super.init()
    }
    
    func transform(input: Input) -> Output {
        
        let item = PublishRelay<HelpDetailModel>()
        let showErrorView = BehaviorRelay<Bool>(value: false)
        let showEmptyView = BehaviorRelay<Bool>(value: false)
        
        input.request.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            showErrorView.accept(false)
            self.requestDetail().subscribe(onNext: { detail in
                if let d = detail {
                    item.accept(d)
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
    
    func requestDetail() -> Observable<HelpDetailModel?> {
        return NetManager.requestObj(.helpDetail(id: id), type: HelpDetailModel.self).trackActivity(loading).trackError(error)
    }
    
}
