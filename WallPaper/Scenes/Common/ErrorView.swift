//
//  ErrorView.swift
//  WallPaper
//
//  Created by LiQi on 2020/4/28.
//  Copyright © 2020 Qire. All rights reserved.
//

import Foundation
import SnapKit

class ErrorView: UIView {
    
    let imgView = UIImageView(image: UIImage(named: "wrong_img_default"))
    let btn: UIButton = {
        let b = UIButton()
        b.contentEdgeInsets = .init(top: 0, left: 30.uiX, bottom: 0, right: 30.uiX)
        b.titleLabel?.font = .init(style: .regular, size: 15.uiX)
        b.setTitleColor(.init(hex: "#999999"), for: .normal)
        b.setTitle("网络异常，请点击重试", for: .normal)
        return b
    }()
    
    var imgTop: ConstraintMakerEditable!
    var labelTop: ConstraintMakerEditable!
    var btnTop: ConstraintMakerEditable!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = AppDefine.mainColor
        addSubview(imgView)
        addSubview(btn)
        
        imgView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            imgTop = make.top.equalToSuperview().offset(150.uiX)
        }
        
        btn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(30.uiX)
            btnTop = make.top.equalTo(imgView.snp.bottom).offset(5.uiX)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
