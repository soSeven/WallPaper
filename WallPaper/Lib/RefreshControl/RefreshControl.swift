//
//  RefreshControl.swift
//  WallPaper
//
//  Created by LiQi on 2020/4/13.
//  Copyright © 2020 Qire. All rights reserved.
//

import Foundation
import MJRefresh
import NVActivityIndicatorView

class RefreshHeader: MJRefreshHeader {
    
    var stateLabel: UILabel!
    var loadingView: NVActivityIndicatorView!
    var stateTitles = [MJRefreshState:String]()
    
    override func prepare() {
        super.prepare()
        
        stateLabel = UILabel()
        stateLabel.font = .init(style: .regular, size: 13.uiX)
        stateLabel.textColor = .init(hex: "#999999")
        stateLabel.textAlignment = .center
//        backgroundColor = .green
        
        let frame = CGRect(x: 0, y: 0, width: self.mj_h, height: self.mj_w)
        loadingView = NVActivityIndicatorView(frame: frame, type: .ballPulseSync, color: .init(hex: "#999999"), padding: 5)
//        loadingView.backgroundColor = .blue
        
        self.addSubview(stateLabel)
        self.addSubview(loadingView)
        
        stateTitles[.idle] = "下拉刷新"
        stateTitles[.pulling] = "释放开始刷新"
        stateTitles[.refreshing] = "正在加载中..."
    }
    
    override func placeSubviews() {
        super.placeSubviews()
        
//        loadingView.frame = .init(x: 0, y: 3, width: self.mj_w, height: self.mj_h*0.5)
        loadingView.frame = bounds
        stateLabel.frame = bounds
//        stateLabel.frame = .init(x: 0, y: self.mj_h*0.5 - 3, width: self.mj_w, height: self.mj_h*0.5)
    }
    
    override var state: MJRefreshState {
        
        didSet {
            if state == oldValue {
                return
            }
            super.state = state
            stateLabel.text = stateTitles[state]
            lastUpdatedTimeKey = self.lastUpdatedTimeKey
            if state == .idle {
                if oldValue == .refreshing {
                    UIView.animate(withDuration: TimeInterval(MJRefreshFastAnimationDuration), animations: {
                        
                    }, completion: { finished in
                        if self.state != .idle {
                            return
                        }
                        self.loadingView.stopAnimating()
                        self.stateLabel.isHidden = false
                    })
                } else {
                    self.loadingView.stopAnimating()
                    stateLabel.isHidden = false
                }
            } else if state == .pulling {
                loadingView.stopAnimating()
                stateLabel.isHidden = false
            }
            else if state == .refreshing {
                loadingView.startAnimating()
                stateLabel.isHidden = true
            }
        }
    }
}

class RefreshFooter: MJRefreshAutoFooter {
    
    var stateLabel: UILabel!
    var loadingView: NVActivityIndicatorView!
    var stateTitles = [MJRefreshState:String]()
    
    override func prepare() {
        super.prepare()
        
        stateLabel = UILabel()
        stateLabel.font = .init(style: .regular, size: 13.uiX)
        stateLabel.textColor = .init(hex: "#999999")
        stateLabel.textAlignment = .center
//        stateLabel.backgroundColor = .blue
        
        let frame = CGRect(x: 0, y: 0, width: self.mj_h, height: self.mj_h)
        loadingView = NVActivityIndicatorView(frame: frame, type: .ballPulseSync, color: .init(hex: "#999999"), padding: 5)
        
        self.addSubview(stateLabel)
        self.addSubview(loadingView)
        
        stateTitles[.idle] = "上拉加载更多"
        stateTitles[.noMoreData] = "- 我是有底线的 -"
        stateTitles[.refreshing] = "正在加载中..."
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(stateLabelClick))
        stateLabel.addGestureRecognizer(tap)
    }
    
    @objc
    func stateLabelClick() {
        if state == .idle {
            beginRefreshing()
        }
    }
    
    override func placeSubviews() {
        super.placeSubviews()
        
        stateLabel.frame = bounds
//        let x = self.mj_w * 0.5
//        let y = self.mj_h * 0.5
//        loadingView.center = .init(x: x, y: y)
        loadingView.frame = bounds
    }
    
    override var state: MJRefreshState {
        
        didSet {
            if state == oldValue {
                return
            }
            super.state = state
            stateLabel.text = stateTitles[state]
            stateLabel.isHidden = true
            if state == .noMoreData {
                loadingView.stopAnimating()
                stateLabel.isHidden = false
            } else if state == .idle {
                loadingView.stopAnimating()
                stateLabel.isHidden = false
            }
            else if state == .refreshing {
                loadingView.startAnimating()
            }
        }
    }
    
    
}
