//
//  HelpInputViewController.swift
//  WallPaper
//
//  Created by LiQi on 2020/4/28.
//  Copyright © 2020 Qire. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import YYText

class HelpInputViewController: ViewController {
    
    var viewModel: HelpInputViewModel!
    
    private var markItems = [HelpTypeModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBinding()
    }
    
    // MARK: - Binding
    
    private func setupBinding() {
        let input = HelpInputViewModel.Input(request: Observable<Void>.just(()))
        let output = viewModel.transform(input: input)
        output.item.subscribe(onNext: {[weak self] items in
            guard let self = self else { return }
            self.markItems = items
            self.setupUI()
        }).disposed(by: rx.disposeBag)
        
        viewModel.loading.asObservable().distinctUntilChanged().bind(to: view.rx.mbHudLoaing).disposed(by: rx.disposeBag)
        output.showEmptyView.distinctUntilChanged().bind(to: rx.showEmptyView()).disposed(by: rx.disposeBag)
        output.showErrorView.distinctUntilChanged().bind(to: rx.showErrorView()).disposed(by: rx.disposeBag)
    }
    
    private func setupBindingAfterUI() {
        
    }

    
    // MARK: - UI
    
    private func setupUI() {
        let bar = getBarView()
        let scrollView = getScrollView()
        
        view.addSubview(bar)
        view.addSubview(scrollView)
        
        bar.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(UIDevice.safeAreaBottom + 75.uiX)
        }
        
        scrollView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.bottom.equalTo(bar.snp.top)
        }

    }
    
    private func getBarView() -> UIView {
        let btn = UIButton()
        btn.cornerRadius = 25.uiX
        btn.titleLabel?.font = .init(style: .medium, size: 17.uiX)
        btn.setTitleColor(.white, for: .normal)
        btn.setTitle("提交", for: .normal)
        btn.backgroundColor = .init(hex: "#FF2071")
        
        let contentView = UIView()
        contentView.backgroundColor = .init(hex: "#21232F")
        contentView.addSubview(btn)
        
        btn.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(13.uiX)
            make.left.equalToSuperview().offset(15.uiX)
            make.right.equalToSuperview().offset(-15.uiX)
            make.height.equalTo(50.uiX)
        }
        
        return contentView
    }
    
    private func getScrollView() -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.keyboardDismissMode = .interactive
        
        let contentView = UIView()
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        let markView = getMarkView()
        contentView.addSubview(markView)
        let questionView = getQuestionView()
        contentView.addSubview(questionView)
        let phoneView = getPhoneView()
        contentView.addSubview(phoneView)
        
        markView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
        }
        questionView.snp.makeConstraints { make in
            make.top.equalTo(markView.snp.bottom).offset(15.uiX)
            make.left.right.equalToSuperview()
        }
        phoneView.snp.makeConstraints { make in
            make.top.equalTo(questionView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        return scrollView
    }
    
    private func getMarkView() -> UIView {
        let contentView = UIView()
        
        let header = HelpInputHeaderView()
        header.titleLbl.text = "问题类型"
        contentView.addSubview(header)
        
        let markView = HelpInputMarkView(frame: .zero, items: markItems)
        contentView.addSubview(markView)
        
        header.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(40.uiX)
        }
        var n = markItems.count / 2
        if markItems.count % 2 != 0 {
            n += 1
        }
        markView.snp.makeConstraints { make in
            make.top.equalTo(header.snp.bottom)
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(((40.uiX) * CGFloat(n)))
        }
        
        return contentView
    }
    
    private func getQuestionView() -> UIView {
        let contentView = UIView()
        
        let header = HelpInputHeaderView()
        header.titleLbl.text = "问题描述"
        contentView.addSubview(header)
        
        let markView = HelpInputEditView()
        contentView.addSubview(markView)
        
        header.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(40.uiX)
        }

        markView.snp.makeConstraints { make in
            make.top.equalTo(header.snp.bottom)
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(190.uiX)
        }
        
        return contentView
    }
    
    private func getPhoneView() -> UIView {
        let contentView = UIView()
        
        let header = HelpInputHeaderView()
        header.titleLbl.text = "联系方式"
        header.starImgView.isHidden = true
        contentView.addSubview(header)
        
        let markView = UITextField()
        markView.textColor = .white
        markView.font = .init(style: .regular, size: 15.uiX)
        let place = NSMutableAttributedString(string: "QQ号/微信号/手机号")
        place.yy_color = .init(hex: "#666666")
        place.yy_font = .init(style: .regular, size: 14.uiX)
        markView.attributedPlaceholder = place
        markView.addPaddingLeft(15.uiX)
        contentView.addSubview(markView)
        
        header.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(40.uiX)
        }
        
        markView.snp.makeConstraints { make in
            make.top.equalTo(header.snp.bottom)
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(50.uiX)
        }
        
        return contentView
    }

}
