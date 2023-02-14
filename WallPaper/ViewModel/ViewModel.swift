//
//  ViewModel.swift
//  WallPaper
//
//  Created by LiQi on 2020/4/9.
//  Copyright © 2020 Qire. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol ViewModelType {
    
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
    
}

class ViewModel: NSObject {
    
    let loading = ActivityIndicator()
    
    let parsedError = PublishSubject<NetError>()
    let error = ErrorTracker()
    
    override init() {
        super.init()
        error.asObservable().map { (error) -> NetError? in
            if let e = error as? NetError {
                return e
            }
            print(error)
            return NetError.error(code: -1111, msg: error.localizedDescription)
        }.filterNil().bind(to: parsedError).disposed(by: rx.disposeBag)
    }
}
