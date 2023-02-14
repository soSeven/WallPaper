//
//  WallPaperCellNodeViewModel.swift
//  WallPaper
//
//  Created by LiQi on 2020/4/24.
//  Copyright © 2020 Qire. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class WallPaperCellNodeViewModel: ViewModel, ViewModelType {
    
    let model: WallPaperModel
//    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
    let download = PublishSubject<WallPaperModel>()
    let userHome = PublishSubject<WallPaperModel>()
    let create = PublishSubject<WallPaperModel>()
    let share = PublishSubject<WallPaperModel>()
    let login = PublishSubject<Void>()
    
    let isAttention = BehaviorRelay<Bool>(value: false)
    
    struct Input {
        let zan: PublishRelay<Void>
        let attention: PublishRelay<Void>
    }
    
    struct Output {
        let isZan: BehaviorRelay<Bool>
    }
    
    init(model: WallPaperModel) {
        self.model = model
        isAttention.accept(model.isFollow)
    }
    
    func transform(input: WallPaperCellNodeViewModel.Input) -> WallPaperCellNodeViewModel.Output {
        
        let isZan = BehaviorRelay<Bool>(value: model.isZan)
  
        input.zan.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            if !UserManager.shared.isLogin {
                self.login.onNext(())
                return
            }
            let lastStatus = isZan.value
            isZan.accept(!lastStatus)
            self.requestZan().subscribe(onNext: { zan in
                isZan.accept(zan?.zanStatus ?? lastStatus)
            }, onError: { error in
                isZan.accept(lastStatus)
            }).disposed(by: self.rx.disposeBag)
        }).disposed(by: rx.disposeBag)
        
        input.attention.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            if !UserManager.shared.isLogin {
                self.login.onNext(())
                return
            }
            self.requestAttention().subscribe(onNext: { m in
                self.isAttention.accept(m?.followStatus ?? self.isAttention.value)
            }, onError: { error in
                
            }).disposed(by: self.rx.disposeBag)
        }).disposed(by: rx.disposeBag)
        
        isZan.distinctUntilChanged().bind {[weak self] b in
            guard let self = self else { return }
            self.model.isZan = b
        }.disposed(by: rx.disposeBag)
        isAttention.distinctUntilChanged().bind {[weak self] b in
            guard let self = self else { return }
            self.model.isFollow = b
        }.disposed(by: rx.disposeBag)
        
        return Output(isZan: isZan)
    }
    
    private func requestZan() -> Observable<ZanModel?> {
        return NetManager.requestObj(.zan(id: model.id), type: ZanModel.self).asObservable().trackError(error)
    }
    
    private func requestAttention() -> Observable<AttentionUserModel?> {
        return NetManager.requestObj(.attentionUser(id: model.userId), type: AttentionUserModel.self).asObservable().trackError(error)
    }
}
