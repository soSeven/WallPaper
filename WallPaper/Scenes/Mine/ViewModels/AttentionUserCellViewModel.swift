//
//  AttentionUserCellViewModel.swift
//  WallPaper
//
//  Created by LiQi on 2020/4/29.
//  Copyright © 2020 Qire. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class AttentionUserCellViewModel: ViewModel {
    
    var model: AttentionUserListModel
    
    let isAttention = BehaviorRelay<Bool>(value: true)
    let attention =  PublishRelay<Void>()
    
    required init(model: AttentionUserListModel) {
        self.model = model
        super.init()
        setupBinding()
    }
    
    func setupBinding() {
        attention.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            self.requestAttention().subscribe(onNext: { m in
                self.isAttention.accept(m?.followStatus ?? self.isAttention.value)
            }, onError: { error in
                
            }).disposed(by: self.rx.disposeBag)
        }).disposed(by: rx.disposeBag)
    }
    
    private func requestAttention() -> Observable<AttentionUserModel?> {
        return NetManager.requestObj(.attentionUser(id: model.id), type: AttentionUserModel.self).asObservable().trackError(error)
    }

}
