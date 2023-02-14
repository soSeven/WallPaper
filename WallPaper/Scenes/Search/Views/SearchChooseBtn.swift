//
//  SearchChooseBtn.swift
//  WallPaper
//
//  Created by LiQi on 2020/4/30.
//  Copyright © 2020 Qire. All rights reserved.
//

import UIKit

class SearchChooseBtn: UIView {
    
    static var chooseBtns = [SearchChooseBtn]()
    
    lazy var titleLbl: UILabel = {
        let l = UILabel()
        l.textColor = .init(hex: "#999999")
        l.font = .init(style: .regular, size: 14.uiX)
        return l
    }()
    lazy var arrowImgView: UIImageView = {
        let i = UIImageView(image: UIImage(named: "search_icon_arrow_down"))
        return i
    }()
    
    var action: ((SearchChooseBtn)->())?
    var selected = false
    var containerView: UIView?

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLbl)
        addSubview(arrowImgView)
        
        titleLbl.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
        }
        
        arrowImgView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview()
            make.left.equalTo(titleLbl.snp.right).offset(6.uiX)
        }
        SearchChooseBtn.chooseBtns.append(self)
        
        self.rx.tap().subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            self.action?(self)
        }).disposed(by: rx.disposeBag)
    }
    
    deinit {
        SearchChooseBtn.chooseBtns.removeAll(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSelected(selected: Bool) {
        if selected {
            SearchChooseBtn.chooseBtns.filter { btn -> Bool in
                btn != self && btn.selected
            }.forEach { btn in
                btn.setupSelected(selected: false)
            }
            titleLbl.textColor = .init(hex: "#FF2071")
            arrowImgView.image = UIImage(named: "search_icon_arrow_up")
            arrowImgView.transform = .init(rotationAngle: CGFloat(Float.pi))
            self.selected = true
        } else {
            arrowImgView.image = UIImage(named: "search_icon_arrow_down")
            arrowImgView.transform = .identity
            titleLbl.textColor = .init(hex: "#999999")
            self.selected = false
        }
    }
    
}

class SearchChooseView: UIView {
    
    lazy var contentView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.clear
        return v
    }()
    lazy var bgView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.black.alpha(0.6)
        v.rx.tap().subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            self.dimiss()
        }).disposed(by: rx.disposeBag)
        return v
    }()
    lazy var containerView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.white
        v.clipsToBounds = true
        return v
    }()
    
    var isShow = false
    var chooseBtns: [SearchChooseBtn]

    required init(frame: CGRect, chooseBtns: [SearchChooseBtn]) {
        self.chooseBtns = chooseBtns
        super.init(frame: frame)
//        backgroundColor = .blue
        
        var lastView: UIView = self
        for v in chooseBtns {
            addSubview(v)
            v.action = onclickChooseBtn
            if lastView == self {
                v.snp.makeConstraints { make in
                    make.top.equalToSuperview()
                    make.left.equalToSuperview().offset(15.uiX)
                }
            } else {
                v.snp.makeConstraints { make in
                    make.top.equalToSuperview()
                    make.left.equalTo(lastView.snp.right).offset(26.uiX)
                }
            }
            lastView = v
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func onclickChooseBtn(btn: SearchChooseBtn) {
        guard let superView = superview else {
            return
        }
        
        if btn.selected { //收起
            isShow = false
            superView.isUserInteractionEnabled = false
            UIView.animate(withDuration: 0.3, animations: {
                btn.setupSelected(selected: false)
                self.bgView.alpha = 0
                self.containerView.frame = CGRect(x: 0, y: 0, width: self.contentView.width, height: 0)
            }) { finished in
                superView.isUserInteractionEnabled = true
                self.contentView.removeFromSuperview()
                self.containerView.removeSubviews()
            }
        } else {
            if !isShow { // 第一次
                superView.addSubview(contentView)
                contentView.frame = getShowFrame()
                
                contentView.addSubview(bgView)
                bgView.frame = contentView.bounds
                bgView.alpha = 0
                
                contentView.addSubview(containerView)
                containerView.frame = CGRect(x: 0, y: 0, width: contentView.width, height: 0)
            }
            isShow = true
            
            let lastSubView = containerView.subviews.first
            let currentSubView = btn.containerView
            
            if lastSubView != currentSubView {
                lastSubView?.alpha = 1
                currentSubView?.alpha = 0
                if let v = currentSubView {
                    v.frame = CGRect(x: 0, y: 0, width: containerView.width, height: v.height)
                    containerView.addSubview(v)
                }
            }
            
            superView.isUserInteractionEnabled = false
            UIView.animate(withDuration: 0.3, animations: {
                btn.setupSelected(selected: true)
                self.bgView.alpha = 1
                self.containerView.frame = CGRect(x: 0, y: 0, width: self.contentView.width, height: btn.containerView?.height ?? 0)
                if lastSubView != currentSubView {
                    currentSubView?.alpha = 1
                    lastSubView?.alpha = 0
                }
            }) { finished in
                superView.isUserInteractionEnabled = true
                if lastSubView != currentSubView {
                    lastSubView?.removeFromSuperview()
                }
            }
        }
        
    }
    
    func dimiss() {
        guard let superView = superview else {
            return
        }
        isShow = false
        superView.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.3, animations: {
            self.chooseBtns.filter{$0.selected}.forEach{
                $0.setupSelected(selected: false)
            }
            self.bgView.alpha = 0
            self.containerView.frame = CGRect(x: 0, y: 0, width: self.contentView.width, height: 0)
        }) { finished in
            superView.isUserInteractionEnabled = true
            self.contentView.removeFromSuperview()
            self.containerView.removeSubviews()
        }
    }
    
    private func getShowFrame() -> CGRect {
        guard let superView = superview else {
            return .zero
        }
        let selfFrame = frame
        let superBounds = superView.bounds
        let x: CGFloat = selfFrame.origin.x
        let y: CGFloat = selfFrame.origin.y + selfFrame.size.height
        let w: CGFloat = selfFrame.size.width
        let h: CGFloat = superBounds.height - y
        let frame = CGRect(x: x, y: y, width: w, height: h)
        return frame
    }
    
}
