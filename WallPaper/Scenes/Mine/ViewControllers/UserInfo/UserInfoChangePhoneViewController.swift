//
//  UserInfoChangePhoneViewController.swift
//  WallPaper
//
//  Created by LiQi on 2020/5/13.
//  Copyright © 2020 Qire. All rights reserved.
//

import UIKit

protocol UserInfoChangePhoneViewControllerDelegate: AnyObject {
    func userInfoChangePhoneShowPhone(controller: UserInfoChangePhoneViewController)
}

class UserInfoChangePhoneViewController: ViewController {
    
    weak var delegate: UserInfoChangePhoneViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        navigationItem.title = "绑定手机"
    }
    
    // MARK: - UI
    
    private func setupUI() {
        
        let imgView = UIImageView(image: UIImage(named: "mine_img_phone"))
        
        let a = UILabel()
        a.text = "已绑定手机号"
        a.font = .init(style: .regular, size: 14.uiX)
        a.textColor = .init(hex: "#999999")
        
        let b = UILabel()
        if var mobile = UserManager.shared.login.value?.mobile,
        mobile.count == 11 {
            mobile.insert(Character(" "), at: mobile.index(mobile.startIndex, offsetBy: 3))
            mobile.insert(Character(" "), at: mobile.index(mobile.startIndex, offsetBy: 8))
            b.text = mobile
        }

        b.font = .init(style: .regular, size: 18.uiX)
        b.textColor = .init(hex: "#FFFFFF")
        
        let btn = UIButton()
        btn.titleLabel?.font = .init(style: .regular, size: 16.uiX)
        btn.cornerRadius = 20.uiX
        btn.borderColor = .init(hex: "#999999")
        btn.borderWidth = 0.5
        btn.setTitle("更换手机号", for: .normal)
        btn.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            self.delegate?.userInfoChangePhoneShowPhone(controller: self)
        }).disposed(by: rx.disposeBag)
        
        view.addSubview(imgView)
        view.addSubview(a)
        view.addSubview(b)
        view.addSubview(btn)
        
        imgView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.snp.topMargin).offset(46.uiX)
            make.size.equalTo(imgView.snpSize)
        }
        
        a.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(imgView.snp.bottom).offset(27.uiX)
        }
        
        b.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(a.snp.bottom).offset(7.uiX)
        }
        
        btn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.snp.bottomMargin).offset(-104.uiX)
            make.width.equalTo(130.uiX)
            make.height.equalTo(40.uiX)
        }
        
    }

}
