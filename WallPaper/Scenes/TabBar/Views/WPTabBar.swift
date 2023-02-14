//
//  WPTabBar.swift
//  WallPaper
//
//  Created by LiQi on 2020/5/7.
//  Copyright © 2020 Qire. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class WPTabBar: UITabBar {
    
    let scrollToTopStatus = BehaviorRelay<Bool>(value: true)
    let scrollToTop = PublishRelay<Void>()
    
    lazy var scrollTopView: UIView = {
        let v = UIView()
//        v.backgroundColor = .red
        let contentView = UIView()
        let imgView = UIImageView(image: UIImage(named: "home_img_top"))
        let lbl = UILabel()
        lbl.text = "回顶部"
        lbl.textColor = .init(hex: "#FFFFFF")
        lbl.font = .init(style: .regular, size: 10)
        contentView.backgroundColor = .init(hex: "#9C60E6")
        contentView.cornerRadius = 5
        contentView.addSubview(imgView)
        contentView.addSubview(lbl)
        imgView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(5)
        }
        lbl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(imgView.snp.bottom)
        }
        v.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 80, height: 38))
        }
        return v
    }()
    
    var scrollTopViewShouldHide = true
    
    var tabButton: UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(scrollTopView)
        scrollToTopStatus.bind(to: scrollTopView.rx.isHidden).disposed(by: rx.disposeBag)
        scrollTopView.rx.tap().bind(to: scrollToTop).disposed(by: rx.disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let tabBarButtonClass = NSClassFromString("UITabBarButton") {
            let items = subviews.filter { sub -> Bool in
                return sub.isKind(of: tabBarButtonClass)
            }
            if let f = items.first {
                tabButton = f
                scrollTopView.frame = f.frame
            }
        }
    }
    
    override func setItems(_ items: [UITabBarItem]?, animated: Bool) {
        super.setItems(items, animated: animated)
        bringSubviewToFront(scrollTopView)
    }
    
}
