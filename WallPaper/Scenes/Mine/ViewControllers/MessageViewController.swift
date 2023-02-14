//
//  MessageViewController.swift
//  WallPaper
//
//  Created by LiQi on 2020/4/28.
//  Copyright © 2020 Qire. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MessageViewController: ViewController {
    
    var viewModel: ListViewModel<MessageListModel>!
    var tableView: UITableView!
    
    private let headerRefreshTrigger = PublishSubject<Void>()
    private let footerRefreshTrigger = PublishSubject<Void>()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "消息"
        setupUI()
    }
    
    override func onceWhenViewDidAppear(_ animated: Bool) {
        setupBinding()
    }
    
    private func setupUI() {
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.backgroundColor = .clear
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200.uiX
        tableView.separatorStyle = .none
        tableView.tableHeaderView = UIView()
        tableView.tableFooterView = UIView()
        tableView.allowsSelection = false
        if #available(iOS 11, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        tableView.register(cellType: MessageTableCell.self)
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    
        tableView.mj_header = RefreshHeader(refreshingBlock: {[weak self] in
            guard let self = self else { return }
            self.headerRefreshTrigger.onNext(())
        })
        
        tableView.mj_footer = RefreshFooter(refreshingBlock: {[weak self] in
            guard let self = self else { return }
            self.footerRefreshTrigger.onNext(())
        })
        tableView.mj_footer?.isHidden = true
    }
    
    private func setupBinding() {
        
        let input = ListViewModel<MessageListModel>.Input(headerRefresh: Observable.merge(headerRefreshTrigger, errorBtnTap.startWith(())),
                                        footerRefresh: footerRefreshTrigger)
        let output = viewModel.transform(input: input)
        
        output.items.asDriver(onErrorJustReturn: []).drive(tableView.rx.items(cellIdentifier: MessageTableCell.reuseIdentifier, cellType: MessageTableCell.self)) {collectionView, model, cell in
            cell.bind(to: model)
        }.disposed(by: rx.disposeBag)
        
        if let footer = tableView.mj_footer {
            output.footerLoading.bind(to: footer.rx.refreshStatus).disposed(by: rx.disposeBag)
        }
        if let header = tableView.mj_header {
            output.headerLoading.asObservable().bind(to: header.rx.isAnimating).disposed(by: rx.disposeBag)
        }
        
        output.firstLoading.distinctUntilChanged().bind(to: view.rx.mbHudLoaing).disposed(by: rx.disposeBag)
        output.showEmptyView.distinctUntilChanged().bind(to: rx.showEmptyView(imageName: "news_img_default", title: "暂无消息")).disposed(by: rx.disposeBag)
        output.showErrorView.distinctUntilChanged().bind(to: rx.showErrorView()).disposed(by: rx.disposeBag)
    }
    
}
