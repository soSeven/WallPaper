//
//  SearchTitleHeaderView.swift
//  WallPaper
//
//  Created by LiQi on 2020/4/29.
//  Copyright © 2020 Qire. All rights reserved.
//

import UIKit
import Reusable

class SearchTitleHeaderView: UICollectionReusableView, Reusable {
        
    lazy var titleLbl: UILabel = {
        let l = UILabel()
        l.textColor = .white
        l.font = .init(style: .medium, size: 14.uiX)
        return l
    }()
    lazy var btn: UIButton = {
        let b = Button()
        b.setImage(UIImage(named: "search_img_delete"), for: .normal)
        return b
    }()
    
    var action: (() ->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLbl)
        addSubview(btn)
        
        titleLbl.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(15.uiX)
        }
        
        btn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-15.uiX)
        }
        
        btn.rx.tap.subscribe(onNext: {[weak self] (_) in
            guard let self = self else { return }
            self.action?()
        }).disposed(by: rx.disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
