//
//  ColorViewModel.swift
//  WallPaper
//
//  Created by LiQi on 2020/4/17.
//  Copyright © 2020 Qire. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ColorViewModel: ViewModel, ViewModelType {
    
    struct Input {
        let tap: Driver<Void>
    }
    
    struct Output {
        let items: PublishRelay<[ColorItemModel]>
        let showErrorView: BehaviorRelay<Bool>
        let showloading: BehaviorRelay<Bool>
    }
    
    func transform(input: ColorViewModel.Input) -> ColorViewModel.Output {
        let items = PublishRelay<[ColorItemModel]>()
        let showErrorView = BehaviorRelay<Bool>(value: false)
        let showloading = BehaviorRelay<Bool>(value: true)
        input.tap.drive(onNext: { [weak self] _ in
            guard let self = self else { return }
            showErrorView.accept(false)
            showloading.accept(true)
            self.requestList().subscribe(onNext: { values in
                items.accept(values)
                showloading.accept(false)
            }, onError: { error in
                showErrorView.accept(true)
                showloading.accept(false)
            }).disposed(by: self.rx.disposeBag)
        }).disposed(by: rx.disposeBag)
        
        return Output(items: items, showErrorView: showErrorView, showloading: showloading)
    }
    
    /// MARK: - Request
    
    func requestList() -> Observable<[ColorItemModel]> {
        
        return NetManager.requestObjArray(.colorItems, type: ColorItemModel.self).trackError(error).asObservable()
        
    }
}
