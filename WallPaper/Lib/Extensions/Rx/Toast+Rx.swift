//
//  Toast+Rx.swift
//  WallPaper
//
//  Created by LiQi on 2020/4/11.
//  Copyright © 2020 Qire. All rights reserved.
//

import UIKit
import Toast_Swift
import RxSwift
import RxCocoa

extension Reactive where Base: UIView {
    
    var toastError: Binder<NetError> {
        return Binder(self.base) { view, error in
//            var code = 0
            var msg = "未知错误"
            switch error {
            case let .error(code: _, msg: m):
//                code = c
                msg = m
            }
            view.makeToast(msg)
        }
    }
    
    var toastErrorCenter: Binder<NetError> {
        return Binder(self.base) { view, error in
//            var code = 0
            var msg = "未知错误"
            switch error {
            case let .error(code: _, msg: m):
//                code = c
                msg = m
            }
            view.makeToast(msg, position: .center)
        }
    }
    
    var toastActivity: Binder<Bool> {
        return Binder(self.base) { view, loading in
            if loading {
                view.makeToastActivity(.center)
            } else {
                view.hideToastActivity()
            }
        }
    }
    
    func toastText(position: ToastPosition = .center) -> Binder<String> {
        return Binder(self.base) { view, msg in
            view.makeToast(msg, position: .center)
        }
    }

}
