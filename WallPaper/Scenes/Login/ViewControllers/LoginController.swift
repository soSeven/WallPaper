//
//  LoginController.swift
//  WallPaper
//
//  Created by LiQi on 2020/4/16.
//  Copyright © 2020 Qire. All rights reserved.
//

import UIKit
import YYText
import SwiftPhoneNumberFormatter

protocol LoginControllerDelegate: AnyObject {
    
    func shouldDidClose(loginController: LoginController)
    func shouldBindPhone(loginController: LoginController)
}

class LoginController: ViewController {
    
    var viewModel: PhoneViewModel!
    weak var delegate: LoginControllerDelegate?
    
    private var phoneTextField: PhoneFormattedTextField!
    private var codeTextField: PhoneFormattedTextField!
    private var loginBtn: UIButton!
    private var codeBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hidesBottomBarWhenPushed = true
        hbd_barHidden = true
        setupUI()
        setupBinding() 
    }
    
    // MARK: - Binding
    
    private func setupBinding() {
        
        let input = PhoneViewModel.Input(phone: phoneTextField.rx.text.orEmpty.asDriver(),
                                         code: codeTextField.rx.text.orEmpty.asDriver(),
                                         codeTap: codeBtn.rx.tap,
                                         loginTap: loginBtn.rx.tap)
        
        let output = viewModel.transform(input: input)
        
        output.phone.drive(phoneTextField.rx.text).disposed(by: rx.disposeBag)
        output.code.drive(codeTextField.rx.text).disposed(by: rx.disposeBag)
        
        output.codeEnabled.drive(onNext: { [weak self] codeEnable in
            guard let self = self else { return }
            if codeEnable.enable {
                self.codeBtn.setTitleColor(.init(hex: "#FF2071"), for: .normal)
                self.codeBtn.isUserInteractionEnabled = true
            } else {
                self.codeBtn.setTitleColor(.init(hex: "#999999"), for: .normal)
                self.codeBtn.isUserInteractionEnabled = false
            }
            if codeEnable.time == 0 {
                self.codeBtn.setTitle("获取验证码", for: .normal)
            } else {
                self.codeBtn.setTitle("\(codeEnable.time)s", for: .normal)
            }
        }, onCompleted: {
            print("completed code")
        }).disposed(by: rx.disposeBag)
        
        output.signupEnabled.drive(loginBtn.rx.isEnabled).disposed(by: rx.disposeBag)
        
        loginBtn.rx.tap.bind {[weak self]  _ in
            guard let self = self else { return }
            self.phoneTextField.resignFirstResponder()
            self.codeTextField.resignFirstResponder()
        }.disposed(by: rx.disposeBag)
        output.login.bind(onNext: {[weak self] _ in
            guard let self = self else { return }
            if let user = UserManager.shared.login.value {
                if user.mobile.isEmpty {
                    self.delegate?.shouldBindPhone(loginController: self)
                } else {
                    self.delegate?.shouldDidClose(loginController: self)
                }
            }
        }).disposed(by: rx.disposeBag)
        
        viewModel.parsedError.bind(to: view.rx.toastErrorCenter).disposed(by: rx.disposeBag)
        viewModel.loading.asObservable().bind(to: view.rx.mbHudLoaing).disposed(by: rx.disposeBag)
        
    }
    
    // MARK: - UI
    
    private func setupUI() {
        
        let closeBtn = Button()
        let closeImg = UIImage(named: "login_icon_return")!
        closeBtn.setImage(closeImg, for: .normal)
        view.addSubview(closeBtn)
        closeBtn.snp.makeConstraints { make in
            make.top.equalTo(self.view.snp_topMargin).offset(23.uiX);
            make.left.equalTo(self.view.snp.left).offset(15.uiX);
            make.width.equalTo(11.uiX);
            make.height.equalTo(closeBtn.snp.width).multipliedBy(closeImg.snpScale);
        }
        closeBtn.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.delegate?.shouldDidClose(loginController: self)
        }).disposed(by: rx.disposeBag)
        
        let titleLbl = UILabel()
        titleLbl.font = .init(style: .regular, size: 20.uiX)
        titleLbl.textColor = .init(hex: "#ffffff")
        titleLbl.text = "欢迎使用"
        view.addSubview(titleLbl)
        titleLbl.snp.makeConstraints { make in
            make.left.equalTo(self.view.snp.left).offset(15.uiX);
            make.top.equalTo(closeBtn.snp.bottom).offset(45.uiX);
        }
        
        let (phoneView, field) = getPhoneView()
        phoneTextField = field
        phoneTextField.config.defaultConfiguration = PhoneFormat(defaultPhoneFormat: "### #### ####")
        view.addSubview(phoneView)
        phoneView.snp.makeConstraints { make in
            make.top.equalTo(titleLbl.snp.bottom).offset(20.uiX)
            make.left.equalTo(self.view).offset(15.uiX);
            make.right.equalTo(self.view).offset(-15.uiX);
            make.height.equalTo(60.uiX);
        }
        
        let (codeView, codeField, btn) = getCodeView()
        codeBtn = btn
        codeTextField = codeField
        view.addSubview(codeView)
        codeView.snp.makeConstraints { make in
            make.top.equalTo(phoneView.snp.bottom);
            make.left.equalTo(self.view).offset(15.uiX);
            make.right.equalTo(self.view).offset(-15.uiX);
            make.height.equalTo(60.uiX);
        }
        
        loginBtn = UIButton()
        loginBtn.titleLabel?.font = .init(style: .medium, size: 16.uiX)
        loginBtn.titleLabel?.textColor = .init(hex: "#ffffff")
//        loginBtn.backgroundColor =
        loginBtn.layer.cornerRadius = 25.uiX
        loginBtn.clipsToBounds = true
        loginBtn.setTitle("登录", for: .normal)
        view.addSubview(loginBtn)
        loginBtn.snp.makeConstraints { make in
            make.centerX.equalTo(self.view);
            make.top.equalTo(codeView.snp.bottom).offset(57.uiX);
            make.width.equalTo(345.uiX)
            make.height.equalTo(50.uiX);
        }
        let backgroundImg = UIImage(color: .init(hex: "#383A43"), size: .init(width: 345.uiX, height: 50.uiX))
        loginBtn.setBackgroundImage(backgroundImg, for: .disabled)
        loginBtn.setBackgroundImage(UIImage(named: "login_img_btn"), for: .normal)
        
        let protocolLbl = getProtocolView()
        view.addSubview(protocolLbl)
        protocolLbl.snp.makeConstraints { make in
            make.bottom.equalTo(view.snp_bottomMargin).offset(-33.uiX);
            make.left.right.equalTo(self.view);
        }
        
        let otherLogin = getOtherLoginView()
        view.addSubview(otherLogin)
        otherLogin.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(protocolLbl.snp.top).offset(-45.uiX)
        }
       
    }
    
    private func getProtocolView() -> UIView {
        
        let text = NSMutableAttributedString(string: "登录注册代表同意")
        text.yy_font = .init(style: .regular, size: 10.uiX)
        text.yy_color = .init(hex: "#999999")
        
        let a = NSMutableAttributedString(string: "《用户服务协议》")
        a.yy_font = .init(style: .regular, size: 10.uiX)
        a.yy_color = .init(hex: "#ffffff")
        
        let hi = YYTextHighlight()
        hi.tapAction =  { containerView, text, range, rect in
            
        };
        a.yy_setTextHighlight(hi, range: a.yy_rangeOfAll())
        
        let b = NSMutableAttributedString(string: "与")
        b.yy_font = .init(style: .regular, size: 10.uiX)
        b.yy_color = .init(hex: "#999999")
        
        let c = NSMutableAttributedString(string: "《隐私协议》")
        c.yy_font = .init(style: .regular, size: 10.uiX)
        c.yy_color = .init(hex: "#ffffff")
        
        let chi = YYTextHighlight()
        chi.tapAction = { containerView, text, range, rect in
            
        };
        c.yy_setTextHighlight(hi, range: c.yy_rangeOfAll())
        
        text.append(a)
        text.append(b)
        text.append(c)
        
        text.yy_alignment = .center;
        let protocolLbl = YYLabel()
        protocolLbl.attributedText = text;
        
        return protocolLbl
    }
    
    private func getPhoneView() -> (UIView, PhoneFormattedTextField) {
        let phoneView = UIView()
        
        let lbl = UILabel()
        lbl.text = "+86"
        lbl.textColor = .init(hex: "#ffffff")
        lbl.font = .init(style: .regular, size: 17.uiX)
        
        let field = getTextField(with: "手机号")
        
        let lineView = UIView()
        lineView.backgroundColor = .init(hex: "#2B2E3E")
        
        phoneView.addSubview(lbl)
        phoneView.addSubview(field)
        phoneView.addSubview(lineView)
        
        lbl.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        lbl.snp.makeConstraints { make in
            make.left.centerY.equalTo(phoneView);
        }
        
        field.snp.makeConstraints { make in
            make.left.equalTo(lbl.snp.right).offset(10.uiX);
            make.right.centerY.equalTo(phoneView);
            make.top.equalTo(phoneView.snp.top).offset(2.uiX);
        }
        
        lineView.snp.makeConstraints { make in
            make.right.left.bottom.equalTo(phoneView);
            make.height.equalTo(1/UIScreen.main.scale);
        }
        
        return (phoneView, field)
    }
    
    private func getCodeView() -> (UIView, PhoneFormattedTextField, UIButton) {
        let codeView = UIView()
        
        let btn = UIButton()
        btn.titleLabel?.font = .init(style: .regular, size: 14.uiX)
        btn.setTitle("获取验证码", for: .normal)
        btn.titleLabel?.textColor = .init(hex: "#999999")
        btn.isUserInteractionEnabled = false
        
        let field = getTextField(with: "获取验证码")
        
        let lineView = UIView()
        lineView.backgroundColor = .init(hex: "#2B2E3E")
        
        let marginLineView = UIView()
        marginLineView.backgroundColor = .init(hex: "#2B2E3E")
        
        codeView.addSubview(btn)
        codeView.addSubview(field)
        codeView.addSubview(lineView)
        codeView.addSubview(marginLineView)
        
        btn.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        btn.snp.makeConstraints { make in
            make.right.centerY.equalTo(codeView);
            make.width.equalTo(100.uiX)
        }
        
        field.snp.makeConstraints { make in
            make.left.equalTo(codeView);
            make.right.equalTo(codeView).offset(-100.uiX);
            make.centerY.equalTo(codeView);
            make.top.equalTo(codeView.snp.top).offset(2.uiX);
        }
        
        lineView.snp.makeConstraints { make in
            make.right.left.bottom.equalTo(codeView);
            make.height.equalTo(1/UIScreen.main.scale);
        }
        
        marginLineView.snp.makeConstraints { make in
            make.left.equalTo(btn.snp.left);
            make.centerY.equalTo(btn);
            make.width.equalTo(1/UIScreen.main.scale);
            make.height.equalTo(26.uiX);
        }
        
        return (codeView, field, btn)
    }
    
    private func getTextField(with placeholder: String) -> PhoneFormattedTextField {
        let textField = PhoneFormattedTextField()
        let placeAtt:[NSAttributedString.Key: Any] = [
            .font: UIFont(style: .regular, size: 15.uiX),
            .foregroundColor: UIColor(hex: "#666666")
        ]
        textField.textColor = .init(hex: "#FFFFFF")
        textField.font = .init(style: .regular, size: 17.uiX)
        textField.keyboardType = .numberPad
        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: placeAtt)
        return textField
    }
    
    private func getOtherLoginView() -> UIView {
        let wechat = getOtherLoginViewItem(name: "微信登录", imgName: "login_img_wx")
        let qq = getOtherLoginViewItem(name: "QQ登录", imgName: "login_img_qq")
        let apple = getOtherLoginViewItem(name: "Apple登录", imgName: "login_img_apple")
        let stack = UIStackView(arrangedSubviews: [wechat, qq, apple], axis: .horizontal)
        stack.distribution = .equalCentering
        stack.alignment = .center
        stack.spacing = 60.uiX
        return stack
    }
    
    private func getOtherLoginViewItem(name: String, imgName: String) -> UIView {
        let view = UIView()
//        view.backgroundColor = .random
        let imgView = UIImageView(image: UIImage(named: imgName))
        let lbl = UILabel()
        lbl.textColor = .init(hex: "#999999")
        lbl.font = .init(style: .regular, size: 10.uiX)
        lbl.text = name
        lbl.textAlignment = .center
        view.addSubview(imgView)
        view.addSubview(lbl)
        imgView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 39.uiX, height: 39.uiX))
            make.top.equalToSuperview()
            make.left.right.equalToSuperview().priority(251)
            make.centerX.equalToSuperview()
        }

        lbl.snp.makeConstraints { make in
            make.top.equalTo(imgView.snp.bottom).offset(6.uiX)
            make.bottom.left.right.equalToSuperview()
        }
        return view
    }

}
