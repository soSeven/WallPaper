//
//  PayInfoView.swift
//  WallPaper
//
//  Created by LiQi on 2020/5/25.
//  Copyright © 2020 Qire. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class PayInfoView: UIView {
    
    fileprivate let imgView = UIImageView(image: UIImage(named: "mine_img_user_default"))
    fileprivate let loginStackView = UIStackView()
    fileprivate let notLoginStackView = UIStackView()
    
    fileprivate let vipImgView = UIImageView(image: UIImage(named: "mine_img_label_nor"))
    
    fileprivate let namelbl: UILabel = {
        let l = UILabel()
        l.textColor = .init(hex: "#ffffff")
        l.font = .init(style: .medium, size: 18.uiX)
        l.text = ""
        return l
    }()
    fileprivate let viplbl: UILabel = {
        let l = UILabel()
        l.textColor = .init(hex: "#B3A4A1")
        l.font = .init(style: .regular, size: 14.uiX)
        l.text = ""
        return l
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let bgImgView = UIImageView(image: UIImage(named: "vip_img_card"))
        addSubview(bgImgView)
        bgImgView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 17.uiX, left: 15.uiX, bottom: 30.uiX, right: 15.uiX))
        }
        
        addSubview(imgView)
        imgView.contentMode = .scaleAspectFill
        imgView.cornerRadius = 55.uiX / 2.0
        imgView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 55.uiX, height: 55.uiX))
            make.left.equalToSuperview().offset(30.uiX)
            make.centerY.equalTo(bgImgView)
        }
        
        setupLoginStackView()
        setupNotLoginStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Tool
    
    private func setupLoginStackView() {
        let s = UIStackView(arrangedSubviews: [namelbl, vipImgView])
        s.alignment = .center
        s.spacing = 7.uiX
        loginStackView.axis = .vertical
        loginStackView.spacing = 4.uiX
        loginStackView.alignment = .leading
        loginStackView.addArrangedSubview(s)
        loginStackView.addArrangedSubview(viplbl)
        self.addSubview(loginStackView)
        loginStackView.isHidden = true
        loginStackView.snp.makeConstraints { make in
            make.centerY.equalTo(imgView.snp.centerY)
            make.left.equalTo(imgView.snp.right).offset(13.uiX)
        }
    }
    
    private func setupNotLoginStackView() {
        
        let l = UILabel()
        l.textColor = .init(hex: "#ffffff")
        l.font = .init(style: .medium, size: 18.uiX)
        l.text = "点击登录"
        
        let l1 = UILabel()
        l1.textColor = .init(hex: "#B3A4A1")
        l1.font = .init(style: .regular, size: 14.uiX)
        l1.text = "登录后可同步VIP特权"
        
        notLoginStackView.axis = .vertical
        notLoginStackView.spacing = 6.uiX
        notLoginStackView.addArrangedSubview(l)
        notLoginStackView.addArrangedSubview(l1)
        notLoginStackView.isHidden = true
        self.addSubview(notLoginStackView)
        notLoginStackView.snp.makeConstraints { make in
            make.centerY.equalTo(imgView.snp.centerY)
            make.left.equalTo(imgView.snp.right).offset(13.uiX)
        }
    }
    
}


extension Reactive where Base: PayInfoView {
    
    var model: Binder<UserModel?> {
        return Binder(self.base) { view, model in
            if let model = model {
                view.imgView.kf.setImage(with: URL(string: model.avatar), placeholder: UIImage(named: "mine_img_user_default"))
                view.namelbl.text = model.nickname
                
                if model.isVip {
                    view.vipImgView.image = UIImage(named: "mine_img_label_vip")
                    view.viplbl.text = "有效期至" + model.vipTime
                } else {
                    view.viplbl.text = "开通VIP立享特权"
                    if !model.vipTime.isEmpty {
                        view.vipImgView.image = UIImage(named: "mine_img_label_overdue")
                    } else {
                        view.vipImgView.image = UIImage(named: "mine_img_label_nor")
                    }
                }
                view.notLoginStackView.isHidden = true
                view.loginStackView.isHidden = false
            } else {
                view.imgView.image = UIImage(named: "mine_img_user_default")
                view.namelbl.text = nil
                view.notLoginStackView.isHidden = false
                view.loginStackView.isHidden = true
                
            }
        }
    }
}
