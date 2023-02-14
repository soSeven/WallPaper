//
//  HelpInputHeaderView.swift
//  WallPaper
//
//  Created by LiQi on 2020/4/28.
//  Copyright © 2020 Qire. All rights reserved.
//

import Foundation

class HelpInputHeaderView: UIView {
    
    lazy var titleLbl: UILabel = {
        let l = UILabel()
        l.textColor = .init(hex: "#999999")
        l.font = .init(style: .regular, size: 14.uiX)
        return l
    }()
    lazy var starImgView: UIImageView = {
        let i = UIImageView(image: UIImage(named: "question_img_symbol"))
        return i
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .init(hex: "#242630")
        addSubview(titleLbl)
        addSubview(starImgView)
        
        titleLbl.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15.uiX)
            make.centerY.equalToSuperview()
        }
        starImgView.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-5.uiX)
            make.left.equalTo(titleLbl.snp.right).offset(2.uiX)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
