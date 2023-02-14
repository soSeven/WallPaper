//
//  WallPaperShareSheetView.swift
//  WallPaper
//
//  Created by LiQi on 2020/5/9.
//  Copyright © 2020 Qire. All rights reserved.
//

import UIKit
import SwiftEntryKit
import RxSwift
import RxCocoa
import MBProgressHUD

enum ShareType: Int {
    case qqFriend
    case qqZone
    case wxFriend
    case wxZone
    case sina
    case copy
    case download
}

class WallPaperShareSheetView: UIView {
    
    let viewModel: ShareViewModel
    let sharePublish = PublishRelay<ShareType>()
    let viewController: UIViewController
    
    convenience init(id: Int, viewController: UIViewController) {
        self.init(frame: .zero, id: id, viewController: viewController)
    }
    
    required init(frame: CGRect, id: Int, viewController: UIViewController) {
        self.viewController = viewController
        self.viewModel = ShareViewModel(id: id, viewController: viewController)
        super.init(frame: frame)
        setupUI()
        setupBinding()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Binding
    
    private func setupBinding() {
        
        let input = ShareViewModel.Input(share: sharePublish.asObservable())
        let output = viewModel.transform(input: input)
        
        var hud: MBProgressHUD?
        output.hud.bind { str in
            if let s = str {
                hud?.mode = .text
                hud?.label.text = s
                hud?.hide(animated: true, afterDelay: 2)
            } else {
                hud = MBProgressHUD.showAdded(to: SwiftEntryKit.window!, animated: true)
                hud?.mode = .indeterminate
                hud?.label.text = "正在分享..."
                hud?.bezelView.style = .solidColor
                hud?.bezelView.color = .init(white: 0, alpha: 0.8)
                hud?.contentColor = .white
                hud?.completionBlock = {
                    hud = nil
                    SwiftEntryKit.dismiss()
                }
            }
        }.disposed(by: rx.disposeBag)
    }
    
    // MARK: - UI
    
    private func setupUI() {
        
        let lbl = UILabel()
        lbl.text = "分享给好友"
        lbl.textColor = .init(hex: "#999999")
        lbl.textAlignment = .center
        lbl.font = .init(style: .regular, size: 13.uiX)
        
        let line1 = [
            getItem(name: "QQ好友", imgName: "wallpaper_share_qq", type: .qqFriend),
            getItem(name: "QQ空间", imgName: "wallpaper_share_qzone", type: .qqZone),
            getItem(name: "微信好友", imgName: "wallpaper_share_wx", type: .wxFriend),
            getItem(name: "朋友圈", imgName: "wallpaper_share_pyq", type: .wxZone),
            getItem(name: "微博", imgName: "wallpaper_share_wb", type: .sina)
        ]
        
        let stack1 = UIStackView(arrangedSubviews: line1, axis: .horizontal)
        stack1.distribution = .equalCentering
        stack1.alignment = .center
        stack1.spacing = 30.uiX
        
        let line2 = [
            getItem(name: "复制链接", imgName: "wallpaper_share_link", type: .copy),
            getItem(name: "保存至手机", imgName: "wallpaper_share_save", type: .sina)
        ]
        
        let stack2 = UIStackView(arrangedSubviews: line2, axis: .horizontal)
        stack2.distribution = .equalCentering
        stack2.alignment = .center
        stack2.spacing = 30.uiX
        
        let cancel = UIButton()
        cancel.backgroundColor = .init(hex: "#1E202C")
        cancel.setTitle("取消", for: .normal)
        cancel.setTitleColor(.white, for: .normal)
        cancel.titleLabel?.font = .init(style: .medium, size: 18.uiX)
        
        
        addSubview(lbl)
        addSubview(stack1)
        addSubview(stack2)
        addSubview(cancel)
        
        lbl.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(68.uiX)
        }
        
        stack1.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(lbl.snp.bottom)
        }
        
        stack2.snp.makeConstraints { make in
            make.left.equalTo(stack1.snp.left)
            make.top.equalTo(stack1.snp.bottom).offset(28.uiX)
        }
        
        cancel.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(49.uiX)
            make.top.equalTo(stack2.snp.bottom).offset(33.uiX)
        }
    }
    
    private func getItem(name: String, imgName: String, type: ShareType) -> UIView {
        let view = UIView()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(onClickItem(tap:)))
        view.addGestureRecognizer(tap)
        view.tag = type.rawValue
        
        let imgView = UIImageView(image: UIImage(named: imgName))
        let lbl = UILabel()
        lbl.textColor = .init(hex: "#999999")
        lbl.font = .init(style: .regular, size: 11.uiX)
        lbl.text = name
        lbl.textAlignment = .center
        view.addSubview(imgView)
        view.addSubview(lbl)
        imgView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 41.uiX, height: 41.uiX))
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
        }
        
        lbl.snp.makeConstraints { make in
            make.top.equalTo(imgView.snp.bottom).offset(6.uiX)
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        return view
    }
    
    // MARK: - Event
    
    @objc
    private func onClickItem(tap: UITapGestureRecognizer) {
        guard let v = tap.view, let type = ShareType(rawValue: v.tag) else {
            return
        }
        sharePublish.accept(type)
        
    }
    
    // MARK: - Show
    
    func show() {
        
        var attributes = EKAttributes.bottomToast
        
        //        attributes.screenBackground = .color(color: .init(.init(white: 0, alpha: 0.7)))
        attributes.entryBackground = .color(color: .init(AppDefine.mainColor))
        attributes.screenInteraction = .dismiss
        attributes.entryInteraction = .absorbTouches
        attributes.displayDuration = .infinity
        attributes.roundCorners = .top(radius: 10.uiX)
        
        attributes.entranceAnimation = .translation
        attributes.exitAnimation = .translation
        
        SwiftEntryKit.display(entry: self, using: attributes)
    }
    
}
