//
//  PayViewController.swift
//  WallPaper
//
//  Created by LiQi on 2020/5/25.
//  Copyright © 2020 Qire. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol PayViewControllerDelegate: AnyObject {
    func payShowLogin(controller: PayViewController)
}

class PayViewController: ViewController {
    
    var viewModel: PayViewModel!
    weak var delegate: PayViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "VIP会员"
        setupBinding()
    }
    
    // MARK: - Binding
    
    private func setupBinding() {
        let input = PayViewModel.Input(request: Observable<Void>.just(()))
        let output = viewModel.transform(input: input)
        output.items.subscribe(onNext: {[weak self] items in
            guard let self = self else { return }
            self.setupUI(items: items)
        }).disposed(by: rx.disposeBag)
    }
    
    // MARK: - UI
    
    private func setupUI(items: [PayInfoModel]) {
        
        let scrollView = UIScrollView(frame: view.bounds)
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let contentView = UIView()
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        let infoView = PayInfoView()
        UserManager.shared.login.bind(to: infoView.rx.model).disposed(by: rx.disposeBag)
        infoView.rx.tap().subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.delegate?.payShowLogin(controller: self)
        }).disposed(by: rx.disposeBag)
        contentView.addSubview(infoView)
        infoView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
        
        let priceView = PayPriceView(items: items)
        contentView.addSubview(priceView)
        priceView.snp.makeConstraints { make in
            make.top.equalTo(infoView.snp.bottom)
            make.left.equalToSuperview().offset(15.uiX)
            make.right.equalToSuperview().offset(-15.uiX)
        }
        
        let powerView = PayPowerView()
        contentView.addSubview(powerView)
        powerView.snp.makeConstraints { make in
            make.top.equalTo(priceView.snp.bottom)
            make.left.equalToSuperview().offset(15.uiX)
            make.right.equalToSuperview().offset(-15.uiX)
            make.bottom.equalTo(contentView.snp.bottom)
        }
        
        
    }
    

}
