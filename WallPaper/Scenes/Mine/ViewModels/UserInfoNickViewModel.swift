//
//  UserInfoNickViewModel.swift
//  WallPaper
//
//  Created by LiQi on 2020/5/12.
//  Copyright © 2020 Qire. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class UserInfoNickViewModel: ViewModel, ViewModelType {
    
    struct Input {
        let save: Observable<String>
    }
    
    struct Output {
        let showSuccess: PublishRelay<String>
    }
    
    func transform(input: Input) -> Output {
        
        let showSuccess = PublishRelay<String>()
        
        input.save.subscribe(onNext: { [weak self] value in
            guard let self = self else { return }
            self.requestSave(value: value).subscribe(onNext: { _ in
                showSuccess.accept("修改成功")
            }).disposed(by: self.rx.disposeBag)
        }).disposed(by: rx.disposeBag)
        
        return Output(showSuccess: showSuccess)
    }
    
    /// MARK: - Request
    
    func requestSave(value: String) -> Observable<Void> {
        
        return NetManager.requestResponse(.changeUserInfo(type: .nickname, value: value)).asObservable().trackError(error).trackActivity(loading)
    }
    
}
