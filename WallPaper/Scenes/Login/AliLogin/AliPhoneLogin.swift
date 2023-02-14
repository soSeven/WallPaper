//
//  AliPhoneLogin.swift
//  WallPaper
//
//  Created by LiQi on 2020/4/14.
//  Copyright © 2020 Qire. All rights reserved.
//

import UIKit
import ATAuthSDK
import Toast_Swift
import SwifterSwift
import RxCocoa

protocol AliPhoneLoginDelegate: AnyObject {
    
    func aliloginShowOtherLogin()
    
}

class AliPhoneLogin: NSObject {
    
    private static var authSuccess = false
    private var viewController: UIViewController
    weak var delegate: AliPhoneLoginDelegate?
    
    required init(controller: UIViewController) {
        viewController = controller
        super.init()
    }
    
    deinit {
        print("deinit")
    }
    
    // MARK: - Login
    
    func show() {
        login(with: viewController)
    }
    
    private func login(with controller: UIViewController) {
        controller.view.makeToastActivity(.center)
        if AliPhoneLogin.authSuccess {
            self.phoneLogin(with: controller)
        } else {
            TXCommonHandler.sharedInstance().setAuthSDKInfo(AppDefine.aliAuthKey) { dict in
                DispatchQueue.main.async {
                    if let code = dict["resultCode"] as? String, code == PNSCodeSuccess {
                        self.phoneLogin(with: controller)
                    } else {
                        controller.view.hideToastActivity()
                        self.presetenPhoneLoginController()
                    }
                }
            }
        }
    }
    
    private func phoneLogin(with controller: UIViewController) {
        let model = getCustomModel()
        TXCommonHandler.sharedInstance().checkEnvAvailable { resultDic in
            
            DispatchQueue.main.async {
                
                guard let code = resultDic?["resultCode"] as? String, code == PNSCodeSuccess else {
                    controller.view.hideToastActivity()
                    self.presetenPhoneLoginController()
                    return
                }
                
                TXCommonHandler.sharedInstance().getLoginToken(withTimeout: 3, controller: controller, model: model) { resultDic in
                    if let code = resultDic["resultCode"] as? String {
                        if code == PNSCodeLoginControllerPresentSuccess {
                            controller.view.hideToastActivity()
                        } else if code == PNSCodeLoginControllerClickCancel {
                            // 点击了授权页的返回
                        } else if code == PNSCodeLoginControllerClickChangeBtn {
                            // 点击切换其他登录方式按钮
                        } else if code == PNSCodeLoginControllerClickLoginBtn {
//                            controller.view.hideToastActivity()
                            controller.view.makeToastActivity(.center)
                        } else if code == PNSCodeLoginControllerClickCheckBoxBtn {
                            // 点击check box
                        } else if code == PNSCodeLoginControllerClickProtocol {
                            // 点击了协议富文本
                        } else if code == PNSCodeSuccess, let token = resultDic["token"] as? String {
                            controller.view.hideToastActivity()
                            UserManager.shared.login(with: .aliAu(token: token)).subscribe(onSuccess: { _ in
                                TXCommonHandler.sharedInstance().cancelLoginVC(animated: true, complete: nil)
                            }).disposed(by: self.rx.disposeBag)
                        } else {
                            controller.view.hideToastActivity()
                            self.presetenPhoneLoginController()
                        }
                    } else {
                        controller.view.hideToastActivity()
                        self.presetenPhoneLoginController()
                    }
                }
                
            }
        }
    }
    
    private func presetenPhoneLoginController() {
        TXCommonHandler.sharedInstance().cancelLoginVC(animated: false, complete: nil)
        delegate?.aliloginShowOtherLogin()
    }
    
    private func getCustomModel() -> TXCustomModel {
        
        //默认，注：model的构建需要放在主线程
        let model = TXCustomModel()
        model.navTitle = NSAttributedString(string: "");
        model.navColor = .clear
        model.navIsHidden = true
        
        let closeImg = UIImage(named: "login_icon_close")!
        
        let titleLbl = UILabel()
        titleLbl.font = .init(style: .medium, size: 27)
        titleLbl.textColor = .init(hex: "#ffffff")
        titleLbl.text = "欢迎使用咔咔"
        titleLbl.backgroundColor = .clear
        titleLbl.sizeToFit()
        
        let width = titleLbl.bounds.size.width
        let height = titleLbl.bounds.size.height
        let logoImg = titleLbl.screenshot ?? UIImage()
        model.logoImage = logoImg
        model.logoFrameBlock = { screenSize, superViewSize, frame in
            let x = (UIDevice.screenWidth - width)/2.0;
            let y = 94.uiX + UIDevice.statusBarHeight;
            return CGRect(x: x, y: y, width: width, height: height)
        }
        
        let sloganAtt: [NSAttributedString.Key: Any] = [
            .font: UIFont(style: .regular, size: 13.uiX),
            .foregroundColor: UIColor(hex: "#999999")
        ]
        let str = TXCommonUtils.getCurrentCarrierName() ?? ""
        let sloganText = "\(str)提供认证服务"
        let sloganTextAtt = NSAttributedString(string: sloganText, attributes: sloganAtt)
        model.sloganText = sloganTextAtt
        model.sloganFrameBlock = { screenSize, superViewSize, frame in
            let width = frame.size.width
            let height = frame.size.height
            let x = (UIDevice.screenWidth - width)/2.0
            let y = 207.uiX  + UIDevice.statusBarHeight
            return CGRect(x: x, y: y, width: width, height: height)
        }
            
        model.numberFont = UIFont(style: .regular, size: 23.uiX)
        model.numberColor = .init(hex: "#ffffff")
        model.numberFrameBlock = { screenSize, superViewSize, frame in
            let width = frame.size.width
            let height = frame.size.height
            let x = (UIDevice.screenWidth - width)/2.0
            let y = 174.uiX + UIDevice.statusBarHeight
            return CGRect(x: x, y: y, width: width, height: height)
        }
        
        let loginImg = UIImage(named: "login_img_btn_auto")!
        model.loginBtnBgImgs = [loginImg, loginImg, loginImg];
        let loginAtt: [NSAttributedString.Key: Any] = [
            .font: UIFont(style: .medium, size: 16.uiX),
            .foregroundColor: UIColor(hex: "#FFFFFF")
        ]
        let loginTextAtt = NSAttributedString(string: "本机号码免密登录", attributes: loginAtt)
        model.loginBtnText = loginTextAtt;
        model.loginBtnFrameBlock = { screenSize, superViewSize, frame in
            let width = 210.uiX
            let height = 50.uiX
            let x = (UIDevice.screenWidth - width)/2.0
            let y = 253.uiX + UIDevice.statusBarHeight
            return CGRect(x: x, y: y, width: width, height: height)
        }
            
        let changeAtt: [NSAttributedString.Key: Any] = [
            .font: UIFont(style: .regular, size: 12.uiX),
            .foregroundColor: UIColor(hex: "#999999")
        ]
        let changeTextAtt = NSAttributedString(string: "首次登录将自动注册账号", attributes: changeAtt)
        model.changeBtnTitle = changeTextAtt;
        model.changeBtnFrameBlock = { screenSize, superViewSize, frame in
            let width = UIDevice.screenWidth
            let height = frame.size.height
            let x: CGFloat = 0.0
            let y = 312.uiX + UIDevice.statusBarHeight
            return CGRect(x: x, y: y, width: width, height: height)
        }
        
        model.checkBoxIsChecked = true
        model.checkBoxIsHidden = true
        model.privacyAlignment = .center
        model.privacyPreText = "同意"
        model.privacySufText = "并授权咔咔视频获得本机号码"
        model.privacyFont = .init(style: .regular, size: 12.uiX);
        model.privacyColors = [UIColor(hex: "#999999"), UIColor(hex: "#666666")]
        model.privacyOperatorPreText = "《"
        model.privacyOperatorSufText = "》"
        model.privacyNavBackImage = closeImg
        model.privacyNavColor = AppDefine.mainColor
        model.privacyNavTitleColor = .white
        model.privacyFrameBlock = { screenSize, superViewSize, frame in
            let width = frame.size.width
            let height = frame.size.height
            let x = (UIDevice.screenWidth - width)/2.0;
            let y = UIDevice.screenHeight - height - 31.uiX - UIDevice.safeAreaBottom
            return CGRect(x: x, y: y, width: width, height: height)
            
        }
        
        let bgImgView = UIImageView(image: UIImage(named: "login_img_bgd"))
        
        let closeBtn = UIButton()
        closeBtn.setImage(closeImg, for: .normal)
        closeBtn.rx.tap.subscribe(onNext: {
            TXCommonHandler.sharedInstance().cancelLoginVC(animated: true, complete: nil)
        }).disposed(by: rx.disposeBag)
        
        let otherLogin = UIButton()
        let otherLoginAtt: [NSAttributedString.Key: Any] = [
            .font: UIFont(style: .regular, size: 14.uiX),
            .foregroundColor: UIColor(hex: "#ffffff"),
            .underlineStyle: 1
        ]
        let otherLoginTextAtt = NSAttributedString(string: "其他登录方式", attributes: otherLoginAtt)
        otherLogin.setAttributedTitle(otherLoginTextAtt, for: .normal)
        otherLogin.rx.tap.subscribe(onNext: {
            TXCommonHandler.sharedInstance().cancelLoginVC(animated: true, complete: nil)
        }).disposed(by: rx.disposeBag)
        
        model.customViewBlock = { superCustomView in
            superCustomView.addSubview(bgImgView)
            superCustomView.addSubview(closeBtn)
            superCustomView.addSubview(otherLogin)
        }
        
        model.customViewLayoutBlock = { screenSize, contentViewFrame, navFrame, titleBarFrame, logoFrame, sloganFrame, numberFrame, loginFrame, changeBtnFrame, privacyFrame in
            var width = UIDevice.screenWidth;
            var height = UIDevice.screenHeight;
            var x: CGFloat = 0;
            var y: CGFloat = 0;
            bgImgView.frame = .init(x: x, y: y, width: width, height: height)
            
            width = 18.uiX
            height = 18.uiX
            x = 15.uiX
            y = 23.uiX + UIDevice.statusBarHeight
            closeBtn.frame = .init(x: x, y: y, width: width, height: height)
            
            width = 100.uiX
            height = 16.uiX
            x = (UIDevice.screenWidth - width)/2.0;
            y = UIDevice.screenHeight - height - 106.uiX - UIDevice.safeAreaBottom
            otherLogin.frame = .init(x: x, y: y, width: width, height: height)
        };
        return model

    }
    
}
