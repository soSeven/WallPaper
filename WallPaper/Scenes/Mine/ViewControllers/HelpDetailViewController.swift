//
//  HelpDetailViewController.swift
//  WallPaper
//
//  Created by LiQi on 2020/4/27.
//  Copyright © 2020 Qire. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class HelpDetailViewController: ViewController {
    
    var viewModel: HelpDetailViewModel!

    fileprivate var titleLbl = UILabel()
    fileprivate var contentText = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "常见问题"
        setupUI()
        setupBinding()
    }
    
    // MARK: - UI
    
    private func setupUI() {
        
        titleLbl.textColor = .init(hex: "#ffffff")
        titleLbl.font = .init(style: .medium, size: 16.uiX)
        
        contentText.textColor = .init(hex: "#999999")
        contentText.font = .init(style: .regular, size: 14.uiX)
        contentText.isEditable = false
        contentText.backgroundColor = .clear
        
        view.addSubview(titleLbl)
        view.addSubview(contentText)
        titleLbl.snp.makeConstraints { make in
            make.top.equalTo(view.snp.topMargin).offset(15.uiX)
            make.left.equalToSuperview().offset(15.uiX)
            make.right.equalToSuperview().offset(-15.uiX)
        }
        
        contentText.snp.makeConstraints { make in
            make.top.equalTo(titleLbl.snp.bottom)
            make.left.equalToSuperview().offset(10.uiX)
            make.right.equalToSuperview().offset(-10.uiX)
            make.bottom.equalTo(view.snp.bottomMargin)
        }
    }
    
    // MARK: - Binding
    
    private func setupBinding() {
        
        let input = HelpDetailViewModel.Input(request: errorBtnTap.startWith(()))
        let output = viewModel.transform(input: input)
        
        output.showEmptyView.distinctUntilChanged().bind(to: rx.showEmptyView()).disposed(by: rx.disposeBag)
        output.showErrorView.distinctUntilChanged().bind(to: rx.showErrorView()).disposed(by: rx.disposeBag)
        output.item.bind(to: rx.model).disposed(by: rx.disposeBag)
        viewModel.loading.asObservable().bind(to: view.rx.mbHudLoaing).disposed(by: rx.disposeBag)
    }
    
}

extension Reactive where Base: HelpDetailViewController {
    
    var model: Binder<HelpDetailModel> {
        return Binder<HelpDetailModel>(self.base) { controller, model in
            controller.titleLbl.text = model.title
            controller.contentText.text = model.content
        }
    }
}
