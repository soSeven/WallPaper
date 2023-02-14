//
//  ListViewController.swift
//  WallPaper
//
//  Created by LiQi on 2020/4/29.
//  Copyright © 2020 Qire. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ListViewController<T: Mapable>: ViewController {
    
    var viewModel: ListViewModel<T>!
    
    var tableView: UITableView!
    
    private let headerRefreshTrigger = PublishSubject<Void>()
    private let footerRefreshTrigger = PublishSubject<Void>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func onceWhenViewDidAppear(_ animated: Bool) {
        setupBinding()
    }
    
    // MARK: - UI
    
    private func setupUI() {
        
        tableView = getTableView()
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func getTableView() -> UITableView {
        let tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.backgroundColor = .clear
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
        
        makeTableView()
        
        return tableView
    }
    
    // MARK: - Binding
    
    private func setupBinding() {
        
        let input = ListViewModel<T>.Input(headerRefresh: Observable.merge(headerRefreshTrigger, errorBtnTap.startWith(())),
                                           footerRefresh: footerRefreshTrigger)
        let output = viewModel.transform(input: input)
        
        output.items.asDriver(onErrorJustReturn: []).drive(tableView.rx.items(cellIdentifier: HelpListTableCell.reuseIdentifier, cellType: HelpListTableCell.self)) {collectionView, model, cell in
            //                cell.bind(to: model)
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
        
        makeBinding()
        
    }
    
    // MARK: - OverRide
    
    func makeTableView() {
        
    }
    
    func makeBinding() {
        
    }
}
