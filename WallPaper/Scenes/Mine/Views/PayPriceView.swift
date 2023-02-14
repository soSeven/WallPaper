//
//  PayPriceView.swift
//  WallPaper
//
//  Created by LiQi on 2020/5/25.
//  Copyright © 2020 Qire. All rights reserved.
//

import UIKit
import YYText
import RxSwift
import RxCocoa

class PayPriceView: UIView {
    
    lazy var titleLbl: UILabel = {
        let t = UILabel()
        t.text = "VIP套餐"
        t.textColor = .white
        t.font = .init(style: .medium, size: 16.uiX)
        return t
    }()
    
    lazy var btn: UIButton = {
        let t = UIButton()
        return t
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10.uiX
        layout.minimumInteritemSpacing = 10.uiX
        layout.itemSize = .init(width: 108.uiX, height: 125.uiX)
        let c = UICollectionView(frame: .zero, collectionViewLayout: layout)
        c.register(cellType: PayPriceCell.self)
        c.backgroundColor = .clear
        return c
    }()
    
    lazy var protocolLbl: UILabel = {
        let t = UILabel()
        t.text = "自动续期服务：1.免费试用：免费试用会员3天，试用结束按年订阅，用户可以在试用期间随时取消。2.订阅会员自动续期，在服务到期前24小时自动续订服务并通过iTunes账户扣除相应费用，同时延长会员服务相应的有效期。3.如需停止自动续期服务，请在下个账单日期之前在 App Store账户设置页，点击“订阅”取消对应服务。开通则表示您同意"
        t.textColor = .init(hex: "#999999")
        t.font = .init(style: .regular, size: 12.uiX)
        t.numberOfLines = 0
        t.preferredMaxLayoutWidth = UIDevice.screenWidth - 30.uiX
//        t.truncationToken = NSAttributedString(string: "开通")
        return t
    }()

    required init(items: [PayInfoModel]) {
        super.init(frame: .zero)
        
        addSubview(titleLbl)
        addSubview(collectionView)
        addSubview(btn)
        addSubview(protocolLbl)
        
        titleLbl.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLbl.snp.bottom).offset(15.uiX)
            make.left.right.equalToSuperview()
            make.height.equalTo(126.uiX)
        }
        
        let btnImg = UIImage(named: "vip_img_btn")!
        btn.setBackgroundImage(btnImg, for: .normal)
        btn.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(27.uiX)
            make.left.right.equalToSuperview()
            make.height.equalTo(btn.snp.width).multipliedBy(btnImg.snpScale)
        }
        
        protocolLbl.snp.makeConstraints { make in
            make.top.equalTo(btn.snp.bottom).offset(12.uiX)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-26.uiX)
        }
        
        Observable.of(items).bind(to: collectionView.rx.items(cellIdentifier: PayPriceCell.reuseIdentifier, cellType: PayPriceCell.self)){ (row, element, cell) in
            cell.bind(to: element)
        }.disposed(by: rx.disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
