//
//  SearchBarView.swift
//  WallPaper
//
//  Created by LiQi on 2020/4/29.
//  Copyright © 2020 Qire. All rights reserved.
//

import UIKit

class SearchBarView: UIView {
    
    let vipBtn = UIButton()
    lazy var textField: UITextField = {
        let t = TextField()
        t.clearButtonMode = .whileEditing
        t.tintColor = .white
        t.font = .init(style: .regular, size: 13.uiX)
        t.textColor = .white
        t.placeholder = "搜索"
        t.returnKeyType = .search
        t.setPlaceHolderTextColor(.init(hex: "#999999"))
        return t
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let searchBar = UIView()
        backgroundColor = AppDefine.mainColor
        
        addSubview(searchBar)
        searchBar.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(UIDevice.statusBarHeight + 64.uiX)
        }
        
        let searchImgView = UIImageView(image: UIImage(named: "home_icon_search"))
        searchImgView.snp.makeConstraints { make in
            make.size.equalTo(searchImgView.snpSize)
        }
        
        vipBtn.setTitle("取消", for: .normal)
        vipBtn.setTitleColor(.init(hex: "#FF2071"), for: .normal)
        vipBtn.titleLabel?.font = .init(style: .regular, size: 14.uiX)
        addSubview(vipBtn)
        
        let searchView = UIView()
        searchView.backgroundColor = .init(hex: "#383A43")
        searchView.layer.cornerRadius = 35.uiX/2.0
        addSubview(searchView)
        
        searchView.addSubview(searchImgView)
        searchImgView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(14.uiX)
        }
        
        searchView.addSubview(textField)
        textField.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(searchImgView.snp.right).offset(5.uiX)
            make.right.equalToSuperview().offset(-5.uiX)
        }
        
        vipBtn.snp.makeConstraints { make in
            make.width.equalTo(36.uiX)
            make.height.equalTo(36.uiX)
            make.right.equalToSuperview().offset(-15.uiX)
            make.centerY.equalTo(searchView)
        }
        
        searchView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15.uiX)
            make.right.equalTo(vipBtn.snp.left).offset(-16.uiX)
            make.bottom.equalToSuperview().offset(-19.uiX)
            make.height.equalTo(35.uiX)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
