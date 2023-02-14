//
//  SearchHotCell.swift
//  WallPaper
//
//  Created by LiQi on 2020/4/30.
//  Copyright © 2020 Qire. All rights reserved.
//

import UIKit

class SearchHotCell: CollectionViewCell {
    
    lazy var numberLbl: UILabel = {
        let l = UILabel()
        l.textColor = .white
        l.font = .init(style: .regular, size: 11.uiX)
        l.textAlignment = .center
        l.cornerRadius = 8.uiX
        return l
    }()
    lazy var titleLbl: UILabel = {
        let l = UILabel()
        l.textColor = .init(hex: "#CCCCCC")
        l.font = .init(style: .medium, size: 14.uiX)
        return l
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(numberLbl)
        numberLbl.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(30.uiX)
            make.size.equalTo(CGSize(width: 16.uiX, height: 16.uiX))
        }
        
        contentView.addSubview(titleLbl)
        titleLbl.snp.makeConstraints { make in
            make.centerY.right.equalToSuperview()
            make.left.equalTo(numberLbl.snp.right).offset(6.uiX)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(to model: SearchHomeListModel, index: Int) {
        switch index {
        case 0:
            numberLbl.backgroundColor = .init(hex: "#FF2071")
        case 1:
            numberLbl.backgroundColor = .init(hex: "#FF7916")
        case 2:
            numberLbl.backgroundColor = .init(hex: "#FFC104")
        default:
            numberLbl.backgroundColor = .clear
        }
        
        titleLbl.text = model.name
        numberLbl.text = "\(index + 1)"
    }
}
