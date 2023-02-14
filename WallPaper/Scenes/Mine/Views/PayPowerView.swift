//
//  PayPowerView.swift
//  WallPaper
//
//  Created by LiQi on 2020/5/25.
//  Copyright © 2020 Qire. All rights reserved.
//

import UIKit

struct PayPowerViewItem {
    let imgName: String
    let title: String
    let descp: String
}

class PayPowerViewItemView: UIView {
    
    init(item: PayPowerViewItem) {
        super.init(frame: .zero)
        
        let imgView = UIImageView(image: UIImage(named: item.imgName))
        
        let titleLbl = UILabel()
        titleLbl.textColor = .white
        titleLbl.font = .init(style: .medium, size: 13.uiX)
        titleLbl.text = item.title
        
        let descpLbl = UILabel()
        descpLbl.textColor = .init(hex: "#999999")
        descpLbl.font = .init(style: .regular, size: 11.uiX)
        descpLbl.text = item.descp
        
        addSubview(imgView)
        addSubview(titleLbl)
        addSubview(descpLbl)
        
        imgView.snp.makeConstraints { make in
            make.size.equalTo(imgView.snpSize)
            make.top.left.bottom.equalToSuperview()
        }
        
        titleLbl.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalTo(imgView.snp.right).offset(9.uiX)
            make.right.equalToSuperview()
        }
        
        descpLbl.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-3.uiX)
            make.left.equalTo(imgView.snp.right).offset(9.uiX)
            make.right.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class PayPowerView: UIView {

    lazy var titleLbl: UILabel = {
        let t = UILabel()
        t.text = "开通VIP立享特权"
        t.textColor = .white
        t.font = .init(style: .medium, size: 16.uiX)
        return t
    }()
    
    lazy var contentView: UIView = {
        let t = UIView()
        t.backgroundColor = .init(hex: "#23252D")
        t.cornerRadius = 10.uiX
        return t
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleLbl)
        addSubview(contentView)
        
        titleLbl.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.top.equalTo(titleLbl.snp.bottom).offset(17.uiX)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-20.uiX)
        }
        
        let item1 = PayPowerViewItemView(item: .init(imgName: "vip_img_pic", title: "VIP专属壁纸", descp: "海量模板任你选"))
        let item2 = PayPowerViewItemView(item: .init(imgName: "vip_img_hd", title: "4K定制高清", descp: "你想要的我都有"))
        let stack1 = UIStackView(arrangedSubviews: [item1, item2])
        stack1.distribution = .fillEqually
        stack1.alignment = .center
        
        let item3 = PayPowerViewItemView(item: .init(imgName: "vip_img_ads", title: "免广告", descp: "免去等待无烦恼"))
        let item4 = PayPowerViewItemView(item: .init(imgName: "vip_img_service", title: "专属客服", descp: "VIP专属客服"))
        let stack2 = UIStackView(arrangedSubviews: [item3, item4])
        stack2.distribution = .fillEqually
        stack2.alignment = .center
        
        contentView.addSubview(stack1)
        contentView.addSubview(stack2)
        
        stack1.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(25.uiX)
            make.left.equalToSuperview().offset(15.uiX)
            make.right.equalToSuperview().offset(-15.uiX)
            make.height.equalTo(40.uiX)
        }
        
        stack2.snp.makeConstraints { make in
            make.top.equalTo(stack1.snp.bottom).offset(33.uiX)
            make.bottom.equalToSuperview().offset(-25.uiX)
            make.left.equalToSuperview().offset(15.uiX)
            make.right.equalToSuperview().offset(-15.uiX)
            make.height.equalTo(40.uiX)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
