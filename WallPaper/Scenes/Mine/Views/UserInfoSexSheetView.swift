//
//  UserInfoSexSheetView.swift
//  WallPaper
//
//  Created by LiQi on 2020/5/12.
//  Copyright © 2020 Qire. All rights reserved.
//

import UIKit
import SwiftEntryKit
import RxSwift
import RxCocoa
import MBProgressHUD

enum UserInfoSexType: Int {
    case man = 1
    case woman = 2
    case secret = 3
}

class UserInfoSexSheetView: UIView {
    
    let sexRelay = PublishRelay<UserInfoSexType>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    
    private func setupUI() {
        
        let lbl = UILabel()
        lbl.text = "请选择性别"
        lbl.textColor = .init(hex: "#666666")
        lbl.textAlignment = .center
        lbl.font = .init(style: .regular, size: 14.uiX)
        
        let man = getBtn(name: "男", tag: 1)
        
        let woman = getBtn(name: "女", tag: 2)
        
        let secret = getBtn(name: "保密", tag: 3)
        
        let line1 = getLineView()
        let line2 = getLineView()
        
        let stack = UIStackView(arrangedSubviews: [man, line1, woman, line2, secret])
        stack.axis = .vertical
        
        let cancel = getBtn(name: "取消", tag: 0)
        
        addSubview(lbl)
        addSubview(stack)
        addSubview(cancel)
        
        lbl.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(45.uiX)
        }
        
        stack.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(lbl.snp.bottom)
        }
        
        cancel.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(stack.snp.bottom).offset(11.uiX)
        }
    }
    
    private func getLineView() -> UIView {
        let lineView = UIView()
        lineView.backgroundColor = .init(hex: "#EEEEEE")
        lineView.snp.makeConstraints { make in
            make.height.equalTo(0.5)
        }
        return lineView
    }
    
    private func getBtn(name: String, tag: Int) -> UIButton {
        let btn = UIButton()
        btn.tag = tag
        btn.backgroundColor = .white
        btn.setTitle(name, for: .normal)
        btn.setTitleColor(.init(hex: "#111111"), for: .normal)
        btn.titleLabel?.font = .init(style: .medium, size: 15.uiX)
        btn.addTarget(self, action: #selector(onClickItem(btn:)), for: .touchUpInside)
        btn.snp.makeConstraints { make in
            make.height.equalTo(55.uiX)
        }
        return btn
    }
    
    // MARK: - Event
    
    @objc
    private func onClickItem(btn: UIButton) {
        if let type = UserInfoSexType.init(rawValue: btn.tag) {
            sexRelay.accept(type)
        }
        SwiftEntryKit.dismiss()
    }
    
    // MARK: - Show
    
    func show() {
        
        var attributes = EKAttributes.bottomToast
        
        attributes.screenBackground = .color(color: .init(.init(white: 0, alpha: 0.6)))
        attributes.entryBackground = .color(color: .init(.init(hex: "#F7F7F7")))
        attributes.screenInteraction = .dismiss
        attributes.entryInteraction = .absorbTouches
        attributes.displayDuration = .infinity
        
        attributes.entranceAnimation = .translation
        attributes.exitAnimation = .translation
        
        SwiftEntryKit.display(entry: self, using: attributes)
    }
    
}
