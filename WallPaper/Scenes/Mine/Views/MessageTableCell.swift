//
//  MessageTableCell.swift
//  WallPaper
//
//  Created by LiQi on 2020/4/28.
//  Copyright © 2020 Qire. All rights reserved.
//

import UIKit

class MessageTableCell: TableViewCell {
    
    lazy var timeLbl: UILabel = {
        let l = UILabel()
        l.text = "12:00"
        l.textColor = .init(hex: "#999999")
        l.textAlignment = .center
        l.font = .init(style: .regular, size: 12.uiX)
        return l
    }()
    lazy var titleLbl: UILabel = {
        let l = UILabel()
        l.text = "平台活动"
        l.textColor = .white
        l.font = .init(style: .regular, size: 15.uiX)
        return l
    }()
    lazy var descripLbl: UILabel = {
        let l = UILabel()
        l.text = "咔咔动态壁纸最新活动开始了，活动期间开通VIP可享5折优惠，活动时间截止至4月5日，赶快分享给好友一起参加活动吧，机会不容错过 拷贝"
        l.numberOfLines = 0
        l.textColor = .init(hex: "#999999")
        l.font = .init(style: .regular, size: 13.uiX)
        return l
    }()
    lazy var dotView: UIView = {
        let l = UIView()
        l.cornerRadius = 3.uiX
        l.backgroundColor = .init(hex: "#FF2071")
        return l
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        contentView.addSubview(timeLbl)
        
        let view = UIView()
        view.backgroundColor = .init(hex: "#383A43")
        view.cornerRadius = 3.uiX
        contentView.addSubview(view)
        
        view.addSubview(titleLbl)
        view.addSubview(descripLbl)
        view.addSubview(dotView)
        
        titleLbl.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15.uiX)
            make.right.equalToSuperview().offset(-15.uiX)
            make.top.equalToSuperview().offset(15.uiX)
        }
        
        dotView.snp.makeConstraints { make in
            make.centerY.equalTo(titleLbl)
            make.right.equalTo(titleLbl.snp.left).offset(-3.uiX)
            make.size.equalTo(CGSize(width: 6.uiX, height: 6.uiX))
        }
        
        descripLbl.setContentCompressionResistancePriority(.required, for: .vertical)
        descripLbl.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15.uiX)
            make.right.equalToSuperview().offset(-15.uiX)
            make.top.equalTo(titleLbl.snp.bottom).offset(5.uiX)
            make.bottom.equalToSuperview().offset(-18.uiX)
        }
        
        timeLbl.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(50.uiX)
        }
        
        view.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15.uiX)
            make.right.equalToSuperview().offset(-15.uiX)
            make.bottom.equalToSuperview()
            make.top.equalTo(timeLbl.snp.bottom)
        }
        
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(to model: MessageListModel) {
        titleLbl.text = model.title
        descripLbl.text = model.content
        timeLbl.text = model.createTime
        dotView.isHidden = (model.status != 1)
    }
    
}
