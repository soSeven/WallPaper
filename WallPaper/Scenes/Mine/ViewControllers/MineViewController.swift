//
//  MineViewController.swift
//  WallPaper
//
//  Created by LiQi on 2020/4/9.
//  Copyright © 2020 Qire. All rights reserved.
//

import UIKit
import RxDataSources
import Reusable

protocol MineViewControllerDelegate: AnyObject {
    
    func mineDidSelectItem(with item: MineCellViewModel)
    func mineDidSelectInfo()
    func mineDidSelectVip()
    
}

class MineViewController: ViewController {
    
    var viewModel: MineViewModel!
    
    weak var delegate: MineViewControllerDelegate?
    
    var tableView: UITableView!
    var headerView: MineInfoView!

    override func viewDidLoad() {
        super.viewDidLoad()
        hbd_barHidden = true
        setupUI()
    }
    
    override func onceWhenViewDidAppear(_ animated: Bool) {
        super.onceWhenViewDidAppear(animated)
        setupBinding()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        tableView = UITableView(frame: view.bounds, style: .grouped)
        tableView.backgroundColor = .clear
        tableView.rowHeight = 55.uiX
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        let header = MineInfoView(frame: .init(x: 0, y: 0, width: 0, height: 185.uiX + UIDevice.statusBarHeight))
        header.infoBtn.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.delegate?.mineDidSelectInfo()
        }).disposed(by: rx.disposeBag)
        header.vipBtn.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.delegate?.mineDidSelectVip()
        }).disposed(by: rx.disposeBag)
        headerView = header
        header.backgroundColor = .clear
        tableView.tableHeaderView = header
        if #available(iOS 11, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        tableView.register(cellType: MineTitleTableCell.self)
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupBinding() {
        
        let datasource = RxTableViewSectionedReloadDataSource<MineSection>(configureCell: { dataSource, tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: MineTitleTableCell.self)
            cell.bind(to: item)
            return cell
        })
        
        tableView.rx.setDelegate(self).disposed(by: rx.disposeBag)
        
        let input = MineViewModel.Input()
        let output = viewModel.transform(input: input)
        
        output.sectionItems.bind(to: tableView.rx.items(dataSource: datasource)).disposed(by: rx.disposeBag)
        tableView.rx.itemSelected.subscribe(onNext: {[weak self] indexPath in
            guard let self = self else { return }
            self.tableView.deselectRow(at: indexPath, animated: true)
            self.delegate?.mineDidSelectItem(with: output.sectionItems.value[indexPath.section].items[indexPath.row])
        }).disposed(by: rx.disposeBag)
        
        output.login.bind(to: headerView.rx.model).disposed(by: rx.disposeBag)
        
    }
    
}

extension MineViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section != 0 {
            return UIView()
        }
        let v = UIView()
        let lineView = UIView()
        v.addSubview(lineView)
        lineView.backgroundColor = .init(hex: "#2B2E3E")
        lineView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15.uiX)
            make.right.equalToSuperview().offset(-15.uiX)
            make.centerY.equalToSuperview()
            make.height.equalTo(1/UIScreen.main.scale)
        }
        return v
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 15.uiX
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.001
        
    }
}


