//
//  PayPriceCell.swift
//  WallPaper
//
//  Created by LiQi on 2020/5/25.
//  Copyright © 2020 Qire. All rights reserved.
//

import UIKit

class PayPriceCell: CollectionViewCell {
    
    lazy var cornerView: UIView = {
        let t = UIView()
        t.cornerRadius = 5.uiX
        t.borderWidth = 0.5
        t.borderColor = .init(hex: "#303134")
        return t
    }()
    
    let recommendImgView = UIImageView(image: UIImage(named: "vip_img_recommand"))
    
    lazy var titleLbl: UILabel = {
        let t = UILabel()
        t.text = "连续包月"
        t.textColor = .white
        t.font = .init(style: .medium, size: 16.uiX)
        return t
    }()
    
    lazy var priceLbl: UILabel = {
        let t = UILabel()
        t.text = "28"
        t.textColor = .init(hex: "#E4C188")
        t.textAlignment = .center
        t.font = .init(style: .regular, size: 23.uiX)
        return t
    }()
    
    lazy var descpLbl: UILabel = {
        let t = UILabel()
        t.text = "28元/月"
        t.textColor = .init(hex: "#999999")
        t.textAlignment = .center
        t.font = .init(style: .regular, size: 13.uiX)
        return t
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(cornerView)
        
        let stack = UIStackView(arrangedSubviews: [titleLbl, priceLbl, descpLbl], axis: .vertical)
        stack.spacing = 5.uiX
        contentView.addSubview(stack)
        
        cornerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        stack.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        contentView.addSubview(recommendImgView)
        recommendImgView.snp.makeConstraints { make in
            make.size.equalTo(recommendImgView.snpSize)
            make.top.right.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(to model: PayInfoModel) {
        titleLbl.text = model.name
        priceLbl.text = model.price
        descpLbl.text = model.description
    }
    
}
