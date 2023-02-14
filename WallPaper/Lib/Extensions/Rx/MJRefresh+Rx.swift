//
//  MJRefresh+Rx.swift
//  WallPaper
//
//  Created by LiQi on 2020/4/11.
//  Copyright © 2020 Qire. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import MJRefresh

//对MJRefreshComponent增加rx扩展
extension Reactive where Base: MJRefreshComponent {
     
    //正在刷新事件
    var refreshing: ControlEvent<Void> {
        let source: Observable<Void> = Observable.create {
            [weak control = self.base] observer  in
            if let control = control {
                control.refreshingBlock = {
                    observer.on(.next(()))
                }
            }
            return Disposables.create()
        }
        return ControlEvent(events: source)
    }
     
    //停止刷新
    var endRefreshing: Binder<Bool> {
        return Binder(base) { refresh, isEnd in
            if isEnd {
                refresh.endRefreshing()
            }
        }
    }
    
    public var isAnimating: Binder<Bool> {
        return Binder(self.base) { refreshControl, active in
            if active {
                //refreshControl.beginRefreshing()
            } else {
                refreshControl.endRefreshing()
            }
        }
    }
}

enum RefreshFooterStatus {
    case normal
    case hidden
    case noData
}

extension Reactive where Base: MJRefreshFooter {
    
    var refreshStatus: Binder<RefreshFooterStatus> {
        return Binder(self.base) { footer, status in
            switch status {
            case .normal:
                footer.isHidden = false
                footer.resetNoMoreData()
            case .hidden:
                footer.isHidden = true
            case .noData:
                footer.isHidden = false
                footer.endRefreshingWithNoMoreData()
            }
        }
    }
    
}
