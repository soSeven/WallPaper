//
//  WallPaperLoadingView.swift
//  WallPaper
//
//  Created by LiQi on 2020/4/21.
//  Copyright © 2020 Qire. All rights reserved.
//

import UIKit

class WallPaperLoadingView: UIView {
    
    private let duration = 0.75
    private var loading = false
    private let subLayer = CALayer()
    
    override init(frame: CGRect) {
        subLayer.isHidden = true
        subLayer.backgroundColor = UIColor.white.cgColor
        super.init(frame: frame)
        layer.addSublayer(subLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        subLayer.frame = .init(x: (width - 1)/2, y: 0, width: 1, height: height)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startLoading() {
        
        if loading {
            return
        }
        subLayer.isHidden = false
        
        let animationGroup = CAAnimationGroup()
        animationGroup.duration = duration
        animationGroup.beginTime = CACurrentMediaTime()
        animationGroup.repeatCount = HUGE
        animationGroup.timingFunction = .init(name: .easeInEaseOut)
        
        let scaleAnimation = CABasicAnimation()
        scaleAnimation.keyPath = "transform.scale.x";
        scaleAnimation.fromValue = 1;
        scaleAnimation.toValue = 1.0 * frame.size.width;
        
        let alphaAnimation = CABasicAnimation();
        alphaAnimation.keyPath = "opacity";
        alphaAnimation.fromValue = 1.0;
        alphaAnimation.toValue = 0.5;
        
        animationGroup.animations = [scaleAnimation, alphaAnimation]
        
        subLayer.add(animationGroup, forKey: nil)
        isHidden = false
        loading = true
    }
    
    func stopLoading() {
        subLayer.removeAllAnimations()
        subLayer.isHidden = true
        isHidden = true
        loading = false
    }

}
