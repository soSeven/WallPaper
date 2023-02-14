//
//  SearchHistoryCell.swift
//  WallPaper
//
//  Created by LiQi on 2020/4/30.
//  Copyright © 2020 Qire. All rights reserved.
//

import UIKit

class SearchHistoryTitleCell: CollectionViewCell {
    lazy var titleLbl: UILabel = {
        let l = UILabel()
        l.textColor = .init(hex: "#CCCCCC")
        l.font = .init(style: .regular, size: 14.uiX)
        l.textAlignment = .center
        return l
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let v = UIView()
        v.backgroundColor = .init(hex: "#383A43")
        v.cornerRadius = 16.uiX
        contentView.addSubview(v)
        v.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        v.addSubview(titleLbl)
        titleLbl.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(to model: String) {
        titleLbl.text = model
    }
}

class SearchHistoryBtnCell: CollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let imgView = UIImageView(image: UIImage(named: "search_img_arrow"))
        contentView.addSubview(imgView)
        imgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
