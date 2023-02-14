//
//  ColorPageMenuView.swift
//  WallPaper
//
//  Created by LiQi on 2020/4/17.
//  Copyright © 2020 Qire. All rights reserved.
//

import UIKit

protocol ColorPageItemSelect where Self: UIView {

    func setupSelect(selected: Bool)
}

class ColorAllPageItem: UIView, ColorPageItemSelect {
    
    let colorView = UIView()
    let innerView = UIView()
    let btn = UIButton()
    let lbl = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(innerView)
        self.clipsToBounds = true
        lbl.text = "全部"
        lbl.font = .init(style: .regular, size: 11.uiX)
        innerView.backgroundColor = .init(hex: "#999999")
        colorView.backgroundColor = AppDefine.mainColor
        innerView.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 2.uiX, left: 2.uiX, bottom: 2.uiX, right: 2.uiX))
        }
        self.addSubview(colorView)
        colorView.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 4.uiX, left: 4.uiX, bottom: 4.uiX, right: 4.uiX))
        }
        self.addSubview(btn)
        btn.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        self.addSubview(lbl)
        lbl.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        colorView.layer.cornerRadius = (self.width/2.0 - 4.uiX)
        innerView.layer.cornerRadius = (self.width/2.0 - 2.uiX)
        layer.cornerRadius = self.width/2.0
    }
    
    func setupSelect(selected: Bool) {
        if selected {
            lbl.textColor = .init(hex: "#FF2071")
            backgroundColor = .init(hex: "#FF2071")
            innerView.backgroundColor = AppDefine.mainColor
        } else {
            lbl.textColor = .init(hex: "#999999")
            innerView.backgroundColor = .init(hex: "#999999")
            backgroundColor = .clear
        }
    }
}

class ColorPageItem: UIView, ColorPageItemSelect {
    
    let colorView = UIView()
    let innerView = UIView()
    let btn = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(innerView)
        self.clipsToBounds = true
        innerView.backgroundColor = AppDefine.mainColor
        colorView.backgroundColor = .white
        innerView.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 2.uiX, left: 2.uiX, bottom: 2.uiX, right: 2.uiX))
        }
        self.addSubview(colorView)
        colorView.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 4.uiX, left: 4.uiX, bottom: 4.uiX, right: 4.uiX))
        }
        self.addSubview(btn)
        btn.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        colorView.layer.cornerRadius = (self.width/2.0 - 4.uiX)
        innerView.layer.cornerRadius = (self.width/2.0 - 2.uiX)
        layer.cornerRadius = self.width/2.0
    }
    
    func setupSelect(selected: Bool) {
        if selected {
            backgroundColor = .init(hex: "#FF2071")
        } else {
            backgroundColor = .clear
        }
    }
}

class ColorPageMenuView: UIView {

    weak var pageController: QXPageController?
    
    private let leftMargin = 15.uiX
    private let itemMargin = 11.uiX
    
    let scrollView = UIScrollView()
    var btns = [ColorPageItemSelect]()
    var currentIndex = 0
    
    required init(frame: CGRect, titles: [String]) {
        super.init(frame: frame)
        scrollView.frame = bounds
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        //        scrollView.delegate = self
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        }
        self.addSubview(scrollView)
        
        var startX = leftMargin
        for (index, value) in titles.enumerated() {
            var btn: ColorPageItemSelect!
            if index == 0 {
                let all = ColorAllPageItem()
                all.btn.tag = index
                all.btn.addTarget(self, action: #selector(onClickItem(btn:)), for: .touchUpInside)
                btn = all
            } else {
                let item = getItem(with: value)
                item.btn.tag = index
                btn = item
            }
            btns.append(btn)
            
            let h: CGFloat = 41.uiX
            let x: CGFloat = startX
            let y: CGFloat = (scrollView.height - h)/2.0
            let w = 41.uiX
            btn.frame = .init(x: x, y: y, width: w, height: h)
            startX += w + itemMargin
            scrollView.addSubview(btn)
        }
        scrollView.contentSize = .init(width: CGFloat.maximum(scrollView.width, startX), height: 0)
        
        selectedItem(index: 0, animated: false)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Event
    
    @objc
    private func onClickItem(btn: UIButton) {
        select(index: btn.tag, with: true)
    }
    
    // MARK: - Tool
    
    func select(index: Int, with animated: Bool) {
        var nIndex = index
        
        if currentIndex > (btns.count - 1) {
            return;
        }
        if nIndex > (self.btns.count - 1) {
            nIndex = currentIndex;
        }
        
        if nIndex == self.currentIndex {
            return;
        }
        
        selectedItem(index: nIndex, animated: animated)
    }
    
    private func selectedItem(index: Int, animated: Bool) {
        if btns.count == 0 {
            return;
        }
        let currentBtn = btns[currentIndex]
        currentBtn.setupSelect(selected: false)
        let nextBtn = btns[index]
        nextBtn.setupSelect(selected: true)
        currentIndex = index
        scrollToCenter(animated: animated)
        pageController?.setSelectedIndex(index, animated: false)
    }
    
    private func scrollToCenter(animated: Bool) {
        if currentIndex > btns.count - 1 {
            return
        }
        let currentBtn = btns[currentIndex]
        
        let halfW = scrollView.width/2.0
        let offsetXMin = halfW
        let offsetXMax = scrollView.contentSize.width - halfW
        let centerX = currentBtn.center.x
        
        if centerX > offsetXMin, centerX < offsetXMax {
            scrollView.setContentOffset(.init(x: centerX - halfW, y: 0), animated: animated)
        } else if (centerX <= offsetXMin) {
            scrollView.setContentOffset(.init(x: 0, y: 0), animated: animated)
        } else {
            scrollView.setContentOffset(.init(x: scrollView.contentSize.width - 2*halfW, y: 0), animated: animated)
        }
    }
    
    private func getItem(with colorTitle: String) -> ColorPageItem {
        let item = ColorPageItem()
        item.colorView.backgroundColor = .init(hex: colorTitle)
        item.btn.addTarget(self, action: #selector(onClickItem(btn:)), for: .touchUpInside)
        return item
    }
    
}

extension ColorPageMenuView: QXPageControllerItemBarDelegate {
    
    func pageController(_ pageController: QXPageController, slideToProgress progress: CGFloat) {
        let tag: Int = Int(progress)
        let rate: CGFloat = progress - CGFloat(tag)
        var currentItem: ColorPageItemSelect? = nil
        if tag < btns.count {
            currentItem = btns[tag]
        }
//        var nextItem: UIButton? = nil
//        if tag+1 < btns.count {
//            nextItem = self.btns[tag + 1]
//        }
        if rate == 0.0 {
            let currentBtn = btns[currentIndex]
            currentBtn.setupSelect(selected: false)
            currentItem?.setupSelect(selected: true)
            currentIndex = tag
            scrollToCenter(animated: true)
            return
        }
    }
    
    
}
