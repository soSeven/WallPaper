//
//  WallPaperCoverView.swift
//  WallPaper
//
//  Created by LiQi on 2020/5/7.
//  Copyright © 2020 Qire. All rights reserved.
//

import UIKit

class WallPaperCoverView: UIView {
    
    var hideAnimation: (()->())?
    var hideCompletion: (()->())?
    
    private let animationHeight = 200.uiX

    private let topImgView = UIImageView(image: UIImage(named: "wallpaper_preview_img_time"))
    private var stack: UIStackView!
    
    private let bottomImgView1 = UIImageView(image: UIImage(named: "wallpaper_preview_icon_dh"))
    private let bottomImgView2 = UIImageView(image: UIImage(named: "wallpaper_preview_icon_dx"))
    private let bottomImgView3 = UIImageView(image: UIImage(named: "wallpaper_preview_icon_wx"))
    private let bottomImgView4 = UIImageView(image: UIImage(named: "wallpaper_preview_icon_app"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        topImgView.transform = .init(translationX: 0, y: -animationHeight)
        topImgView.alpha = 0
        addSubview(topImgView)
        topImgView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(100.uiX)
        }
        
        stack = UIStackView(arrangedSubviews: [bottomImgView1, bottomImgView2, bottomImgView3, bottomImgView4])
        stack.distribution = .equalSpacing
        stack.alpha = 0
        stack.transform = .init(translationX: 0, y: animationHeight)
        addSubview(stack)
        stack.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20.uiX)
            make.right.equalToSuperview().offset(-20.uiX)
            make.bottom.equalToSuperview().offset(-50.uiX - UIDevice.safeAreaBottom)
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(onClickSingleTap(tap: )))
        tap.numberOfTapsRequired = 1
        addGestureRecognizer(tap)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Event
    @objc
    private func onClickSingleTap(tap: UITapGestureRecognizer) {
        hide(animation: nil, completion: nil)
    }
    
    func show(animation: (()->())?, completion:  (()->())?) {
        UIView.animate(withDuration: 0.3, animations: {
            self.stack.transform = .identity
            self.topImgView.transform = .identity
            self.stack.alpha = 1
            self.topImgView.alpha = 1
            animation?()
        }, completion: { finished in
            completion?()
        })
    }
    
    func hide(animation: (()->())?, completion:  (()->())?) {
        UIView.animate(withDuration: 0.3, animations: {
            self.stack.transform = .init(translationX: 0, y: self.animationHeight)
            self.topImgView.transform = .init(translationX: 0, y: -self.animationHeight)
            self.stack.alpha = 0
            self.topImgView.alpha = 0
            self.hideAnimation?()
            self.hideCompletion?()
            animation?()
        }, completion: { finished in
            self.removeFromSuperview()
            completion?()
        })
    }
}
