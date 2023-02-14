//
//  AttentionUserViewController.swift
//  WallPaper
//
//  Created by LiQi on 2020/4/29.
//  Copyright © 2020 Qire. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol AttentionUserViewControllerDelegate: AnyObject {
    
    func attentionUserShowWallPaperHome(controller: AttentionUserViewController, viewModel: AttentionUserCellViewModel)
    
}

class AttentionUserViewController: ViewController {
    
    var viewModel: AttentionUserViewModel!
    var tableView: UITableView!
    
    weak var delegate: AttentionUserViewControllerDelegate?
    
    private let headerRefreshTrigger = PublishSubject<Void>()
    private let footerRefreshTrigger = PublishSubject<Void>()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "关注"
        setupUI()
    }
    
    override func onceWhenViewDidAppear(_ animated: Bool) {
        setupBinding()
    }
    
    private func setupUI() {
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.backgroundColor = .clear
        tableView.rowHeight = 82.uiX
        tableView.separatorStyle = .none
        tableView.tableHeaderView = UIView()
        tableView.tableFooterView = UIView()
        if #available(iOS 11, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        tableView.register(cellType: AttentionUserTableCell.self)
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
        
        let input = AttentionUserViewModel.Input(headerRefresh: Observable.merge(headerRefreshTrigger, errorBtnTap.startWith(())),
                                        footerRefresh: footerRefreshTrigger)
        let output = viewModel.transform(input: input)
        
        output.items.asDriver(onErrorJustReturn: []).drive(tableView.rx.items(cellIdentifier: AttentionUserTableCell.reuseIdentifier, cellType: AttentionUserTableCell.self)) {collectionView, model, cell in
            cell.bind(to: model)
        }.disposed(by: rx.disposeBag)
        
        tableView.rx.itemSelected.subscribe(onNext: {[weak self] indexPath in
            guard let self = self else { return }
            let m = output.items.value[indexPath.row]
            self.delegate?.attentionUserShowWallPaperHome(controller: self, viewModel: m)
        }).disposed(by: rx.disposeBag)
        
        if let footer = tableView.mj_footer {
            output.footerLoading.bind(to: footer.rx.refreshStatus).disposed(by: rx.disposeBag)
        }
        if let header = tableView.mj_header {
            output.headerLoading.asObservable().bind(to: header.rx.isAnimating).disposed(by: rx.disposeBag)
        }
        
        output.firstLoading.distinctUntilChanged().bind(to: view.rx.mbHudLoaing).disposed(by: rx.disposeBag)
        output.showEmptyView.distinctUntilChanged().bind(to: rx.showEmptyView(imageName: "attention_img_default", title: "你关注的用户都在这")).disposed(by: rx.disposeBag)
        output.showErrorView.distinctUntilChanged().bind(to: rx.showErrorView()).disposed(by: rx.disposeBag)
        
        viewModel.parsedError.bind(to: view.rx.toastError).disposed(by: rx.disposeBag)
    }
    
}
