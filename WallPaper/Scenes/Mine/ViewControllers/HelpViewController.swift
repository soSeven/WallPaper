//
//  HelpViewController.swift
//  WallPaper
//
//  Created by LiQi on 2020/4/27.
//  Copyright © 2020 Qire. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol HelpViewControllerDelegate: AnyObject {
    func helpDidSelected(item: HelpListModel)
    func helpDidInput()
}

class HelpViewController: ViewController {
    
    var viewModel: HelpViewModel!
    
    var tableView: UITableView!
    weak var delegate: HelpViewControllerDelegate?
    
    private let headerRefreshTrigger = PublishSubject<Void>()
    private let footerRefreshTrigger = PublishSubject<Void>()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "帮助与反馈"
        setupUI()
    }
    
    override func onceWhenViewDidAppear(_ animated: Bool) {
        setupBinding()
    }
    
    // MARK: - UI
    
    
    private func setupUI() {
        let bar = getBarView()
        tableView = getTableView()
        
        view.addSubview(bar)
        view.addSubview(tableView)
        
        bar.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(UIDevice.safeAreaBottom + 75.uiX)
        }
        
        tableView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.bottom.equalTo(bar.snp.top)
        }

    }
    
    private func getBarView() -> UIView {
        let btn = UIButton()
        btn.cornerRadius = 25.uiX
        btn.titleLabel?.font = .init(style: .medium, size: 17.uiX)
        btn.imageEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 10.uiX)
        btn.setTitleColor(.white, for: .normal)
        btn.setImage(UIImage(named: "help_icon_question"), for: .normal)
        btn.setTitle("问题反馈", for: .normal)
        btn.backgroundColor = .init(hex: "#FF2071")
        btn.rx.tap.subscribe(onNext: {[weak self] _ in
            self?.delegate?.helpDidInput()
        }).disposed(by: rx.disposeBag)
        
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
    
    private func getTableView() -> UITableView {
        let tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.backgroundColor = .clear
        tableView.rowHeight = 50.uiX
        tableView.separatorStyle = .none
        tableView.tableHeaderView = UIView()
        tableView.tableFooterView = UIView()
        if #available(iOS 11, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        tableView.register(cellType: HelpListTableCell.self)
        view.addSubview(tableView)
        
        tableView.mj_header = RefreshHeader(refreshingBlock: {[weak self] in
            guard let self = self else { return }
            self.headerRefreshTrigger.onNext(())
        })
        
        tableView.mj_footer = RefreshFooter(refreshingBlock: {[weak self] in
            guard let self = self else { return }
            self.footerRefreshTrigger.onNext(())
        })
        tableView.mj_footer?.isHidden = true
        
        return tableView
    }
    
    // MARK: - Binding
        
        private func setupBinding() {
            
            let input = HelpViewModel.Input(headerRefresh: Observable.merge(headerRefreshTrigger, errorBtnTap.startWith(())),
                                            footerRefresh: footerRefreshTrigger)
            let output = viewModel.transform(input: input)
            
            output.items.asDriver(onErrorJustReturn: []).drive(tableView.rx.items(cellIdentifier: HelpListTableCell.reuseIdentifier, cellType: HelpListTableCell.self)) {collectionView, model, cell in
                cell.bind(to: model)
            }.disposed(by: rx.disposeBag)
            
            tableView.rx.itemSelected.bind { [weak self] indexPath in
                guard let self = self else { return }
                if indexPath.row >= output.items.value.count {
                    return
                }
                let model = output.items.value[indexPath.row]
                self.delegate?.helpDidSelected(item: model)
            }.disposed(by: rx.disposeBag)
            
            if let footer = tableView.mj_footer {
                output.footerLoading.bind(to: footer.rx.refreshStatus).disposed(by: rx.disposeBag)
            }
            if let header = tableView.mj_header {
                output.headerLoading.asObservable().bind(to: header.rx.isAnimating).disposed(by: rx.disposeBag)
            }
            
            output.firstLoading.distinctUntilChanged().bind(to: view.rx.mbHudLoaing).disposed(by: rx.disposeBag)
            output.showEmptyView.distinctUntilChanged().bind(to: rx.showEmptyView()).disposed(by: rx.disposeBag)
            output.showErrorView.distinctUntilChanged().bind(to: rx.showErrorView()).disposed(by: rx.disposeBag)
            
            viewModel.parsedError.bind(to: view.rx.toastError).disposed(by: rx.disposeBag)
            
        }
}
