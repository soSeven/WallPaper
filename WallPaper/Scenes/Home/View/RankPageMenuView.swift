//
//  RankPageMenuView.swift
//  WallPaper
//
//  Created by LiQi on 2020/4/17.
//  Copyright © 2020 Qire. All rights reserved.
//

import UIKit

class RankPageMenuView: UIView {
    
    weak var pageController: QXPageController?
    
    private let leftMargin = 15.uiX
    private var itemMargin: CGFloat = 35.uiX
    
    let scrollView = UIScrollView()
    var btns = [UIButton]()
    var currentIndex = 0
    
    required init(frame: CGRect, titles: [String], itemMargin: CGFloat = 35.uiX) {
        super.init(frame: frame)
        self.itemMargin = itemMargin
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
            let btn = getItem(with: value)
            btn.tag = index
            btns.append(btn)
            
            let h: CGFloat = bounds.height
            let x: CGFloat = startX
            let y: CGFloat = 0
            let w = btn.width
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
        currentBtn.isSelected = false
        let nextBtn = btns[index]
        nextBtn.isSelected = true
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
    
    private func getItem(with title: String) -> UIButton {
        let btn = UIButton()
        
        let normAtt: [NSAttributedString.Key:Any] = [
            .font: UIFont(style: .regular, size: 15.uiX),
            .foregroundColor: UIColor(hex: "#999999")
        ]
        let norm = NSAttributedString(string: title, attributes: normAtt)
        
        let selectedAtt: [NSAttributedString.Key:Any] = [
            .font: UIFont(style: .regular, size: 15.uiX),
            .foregroundColor: UIColor(hex: "#FF2071")
        ]
        let selected = NSAttributedString(string: title, attributes: selectedAtt)
        
        btn.addTarget(self, action: #selector(onClickItem(btn:)), for: .touchUpInside)
        btn.setAttributedTitle(norm, for: .normal)
        btn.setAttributedTitle(selected, for: .selected)
        btn.sizeToFit()
        
        return btn
    }
}

extension RankPageMenuView: QXPageControllerItemBarDelegate {
    
    func pageController(_ pageController: QXPageController, slideToProgress progress: CGFloat) {
        let tag: Int = Int(progress)
        let rate: CGFloat = progress - CGFloat(tag)
        var currentItem: UIButton? = nil
        if tag < btns.count {
            currentItem = btns[tag]
        }
//        var nextItem: UIButton? = nil
//        if tag+1 < btns.count {
//            nextItem = self.btns[tag + 1]
//        }
        if rate == 0.0 {
            let currentBtn = btns[currentIndex]
            currentBtn.isSelected = false
            currentItem?.isSelected = true
            currentIndex = tag
            scrollToCenter(animated: true)
            return
        }
    }
    
    
}
