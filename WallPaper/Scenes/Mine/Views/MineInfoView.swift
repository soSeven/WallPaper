//
//  MineInfoView.swift
//  WallPaper
//
//  Created by LiQi on 2020/4/14.
//  Copyright © 2020 Qire. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class MineInfoView: UIView {
    
    fileprivate let imgView = UIImageView(image: UIImage(named: "mine_img_user_default"))
    fileprivate let namelbl: UILabel = {
        let l = UILabel()
        l.textColor = .init(hex: "#ffffff")
        l.font = .init(style: .medium, size: 17.uiX)
        l.text = "续费"
        return l
    }()
    fileprivate let viplbl: UILabel = {
        let l = UILabel()
        l.textColor = .init(hex: "#2D271E")
        l.font = .init(style: .regular, size: 15.uiX)
        l.text = "加入VIP会员"
        return l
    }()
    fileprivate let vipBtnlbl: UILabel = {
        let l = UILabel()
        l.textColor = .init(hex: "#E6C187")
        l.font = .init(style: .medium, size: 12)
        l.text = "开通VIP"
        return l
    }()
    fileprivate let sexImgView = UIImageView(image: UIImage(named: "mine_icon_female"))
    fileprivate let vipImgView = UIImageView(image: UIImage(named: "mine_img_label_nor"))
    
    fileprivate let loginStackView = UIStackView()
    fileprivate let notLoginStackView = UIStackView()
    
    let infoBtn = UIButton()
    let vipBtn = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let bottomIgmView = UIImageView(image: UIImage(named: "mine_img_bgd_vip"))
        self.addSubview(bottomIgmView)
        bottomIgmView.isUserInteractionEnabled = true
        bottomIgmView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15.uiX)
            make.right.equalToSuperview().offset(-15.uiX)
            make.bottom.equalToSuperview().offset(-12.uiX)
            make.height.equalTo(bottomIgmView.snp.width).multipliedBy(bottomIgmView.snpScale)
        }
        
        let vipBtnImgView = UIImageView(image: UIImage(named: "mine_img_card_vip"))
        self.addSubview(vipBtnImgView)
        vipBtnImgView.snp.makeConstraints { make in
            make.centerY.equalTo(bottomIgmView)
            make.left.equalTo(bottomIgmView.snp.left).offset(15.uiX)
            make.size.equalTo(vipBtnImgView.snpSize)
        }
        
        let vipDesLbl = UILabel()
        vipDesLbl.text = "享受精彩特权  无限下载  高清定制"
        vipDesLbl.textColor = .init(hex: "#2D271E")
        vipDesLbl.font = .init(style: .regular, size: 11.uiX)
        
        let vipStack = UIStackView(arrangedSubviews: [viplbl, vipDesLbl])
        vipStack.axis = .vertical
        vipStack.spacing = 2.uiX
        self.addSubview(vipStack)
        vipStack.snp.makeConstraints { make in
            make.centerY.equalTo(bottomIgmView)
            make.left.equalTo(vipBtnImgView.snp.right).offset(11.uiX)
        }
        
        let frame = CGRect(x: 0.0, y: 0.0, width: 68, height: 27)
        let gradientView = getGradientView(frame: frame)
        gradientView.clipsToBounds = true
        gradientView.layer.cornerRadius = 27/2.0
        self.addSubview(gradientView)
        gradientView.snp.makeConstraints { make in
            make.centerY.equalTo(bottomIgmView)
            make.right.equalTo(bottomIgmView.snp.right).offset(-11.uiX)
            make.size.equalTo(CGSize(width: 68, height: 27))
        }
        
        self.addSubview(vipBtnlbl)
        vipBtnlbl.snp.makeConstraints { make in
            make.center.equalTo(gradientView)
        }
        
        self.addSubview(imgView)
        imgView.cornerRadius = 30.uiX
        imgView.contentMode = .scaleAspectFill
        imgView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 60.uiX, height: 60.uiX))
            make.left.equalToSuperview().offset(15.uiX)
            make.bottom.equalTo(bottomIgmView.snp.top).offset(-25.uiX)
        }
        
        setupLoginStackView()
        setupNotLoginStackView()
        
        self.addSubview(infoBtn)
        infoBtn.snp.makeConstraints { make in
            make.left.top.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
            make.bottom.equalTo(bottomIgmView.snp.top)
        }
        
        self.addSubview(vipBtn)
        vipBtn.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(bottomIgmView)
            make.bottom.equalTo(bottomIgmView)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Tool
    
    private func setupLoginStackView() {
        let s = UIStackView(arrangedSubviews: [namelbl, sexImgView])
        s.alignment = .center
        s.spacing = 7.uiX
        loginStackView.axis = .vertical
        loginStackView.spacing = 4.uiX
        loginStackView.alignment = .leading
        loginStackView.addArrangedSubview(s)
        loginStackView.addArrangedSubview(vipImgView)
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
        l.font = .init(style: .medium, size: 17.uiX)
        l.text = "点击登录"
        
        let l1 = UILabel()
        l1.textColor = .init(hex: "#999999")
        l1.font = .init(style: .regular, size: 13.uiX)
        l1.text = "登录之后更精彩"
        
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
    
    private func getGradientView(frame: CGRect) -> UIView {
        let l = UIView()
        // layerFillCode
        let layer = CALayer()
        layer.frame = frame
        layer.backgroundColor = UIColor(red: 1, green: 0.13, blue: 0.44, alpha: 1).cgColor
        l.layer.addSublayer(layer)
        // gradientCode
        let gradient1 = CAGradientLayer()
        gradient1.colors = [UIColor(red: 0.43, green: 0.42, blue: 0.4, alpha: 1).cgColor, UIColor(red: 0.1, green: 0.09, blue: 0.1, alpha: 1).cgColor]
        gradient1.locations = [0, 1]
        gradient1.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient1.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient1.frame = frame
        l.layer.addSublayer(gradient1)
        return l
    }
    
}

extension Reactive where Base: MineInfoView {
    
    var model: Binder<UserModel?> {
        return Binder(self.base) { view, model in
            if let model = model {
                view.imgView.kf.setImage(with: URL(string: model.avatar), placeholder: UIImage(named: "mine_img_user_default"))
                view.namelbl.text = model.nickname
                if model.sex == 1 {
                    view.sexImgView.image = UIImage(named: "mine_icon_male")
                } else if model.sex == 2 {
                    view.sexImgView.image = UIImage(named: "mine_icon_female")
                } else {
                    view.sexImgView.image = nil
                }
                if model.isVip {
                    view.vipImgView.image = UIImage(named: "mine_img_label_vip")
                    view.viplbl.text = "我的VIP"
                    view.vipBtnlbl.text = "续费VIP"
                } else {
                    view.viplbl.text = "加入VIP会员"
                    view.vipBtnlbl.text = "开通VIP"
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
