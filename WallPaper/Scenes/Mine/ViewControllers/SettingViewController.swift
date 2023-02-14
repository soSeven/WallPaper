//
//  SettingViewController.swift
//  WallPaper
//
//  Created by LiQi on 2020/4/26.
//  Copyright © 2020 Qire. All rights reserved.
//

import UIKit
import RxDataSources
import Reusable
import RxSwift
import RxCocoa
import Kingfisher
import MBProgressHUD
import SwiftEntryKit

enum SettingEventType {
    case goodJob
    case serviceProtocol
    case userProtocol
    case about
    case login
}

protocol SettingViewControllerDelegate: AnyObject {
    func settingDidClickItem(type: SettingEventType)
}

class SettingModel {
    
    var title = BehaviorRelay<String>(value: "")
    let action = PublishRelay<Void>()
    let detailRelay = BehaviorRelay<String>(value: "")
    
}

class SettingViewController: ViewController {
    
    var items: [SectionModel<String, SettingModel>] = []
    
    weak var delegate: SettingViewControllerDelegate?
    
    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "设置"
        setupData()
        setupUI()
    }
    
    override func onceWhenViewDidAppear(_ animated: Bool) {
        super.onceWhenViewDidAppear(animated)
        setupBinding()
    }
    
    // MARK: - Setup
    
    private func setupData() {
        let setting1 = SettingModel()
        setting1.title.accept("清除缓存")
        setting1.action.bind { _ in
            MBProgressHUD.showWindowLoading()
            DispatchQueue.global().async {
                NetVideoCache.shared.deleteAll()
                ImageCache.default.clearDiskCache()
                DispatchQueue.main.async {
                    setting1.detailRelay.accept("0M")
                    MBProgressHUD.hideWindowLoading()
                }
            }
        }.disposed(by: rx.disposeBag)
        setting1.detailRelay.accept("0M")
        DispatchQueue.global().async {
            var fileSize = NetVideoCache.shared.path.fileSize ?? 0
            ImageCache.default.calculateDiskStorageSize { result in
                switch result {
                case .success(let size):
                    fileSize += UInt64(size)
                case .failure:
                    break
                }
                let str = ByteCountFormatter.string(fromByteCount: Int64(fileSize), countStyle: .file)
                setting1.detailRelay.accept(str)
            }
        }
        
        let setting2 = SettingModel()
        setting2.title.accept("给个好评")
        setting2.action.bind {[weak self] _ in
            self?.delegate?.settingDidClickItem(type: .goodJob)
        }.disposed(by: rx.disposeBag)
        
        items.append(SectionModel(model: "1", items: [setting1, setting2]))
        
        let setting3 = SettingModel()
        setting3.title.accept("服务协议")
        setting3.action.bind {[weak self]  _ in
            self?.delegate?.settingDidClickItem(type: .serviceProtocol)
        }.disposed(by: rx.disposeBag)
        
        let setting4 = SettingModel()
        setting4.title.accept("隐私协议")
        setting4.action.bind {[weak self]  _ in
            self?.delegate?.settingDidClickItem(type: .userProtocol)
        }.disposed(by: rx.disposeBag)
        
        let setting5 = SettingModel()
        setting5.title.accept("关于我们")
        setting5.action.bind {[weak self] _ in
            self?.delegate?.settingDidClickItem(type: .about)
        }.disposed(by: rx.disposeBag)
        
        items.append(SectionModel(model: "2", items: [setting3, setting4, setting5]))
        
        let setting6 = SettingModel()
        UserManager.shared.login.bind { u in
            setting6.title.accept( (u != nil) ? "退出登录": "登录")
        }.disposed(by: rx.disposeBag)
        setting6.detailRelay.accept(" ")
        setting6.action.bind {[weak self] _ in
            if let _ = UserManager.shared.login.value {
                let left = EKAlertMessageView.AlertEvent(title: "取消", action: nil)
                let right = EKAlertMessageView.AlertEvent(title: "确定", action: {
                    UserManager.shared.login.accept(nil)
                })
                EKAlertMessageView.showAlert(title: "温馨提示", detail: "是否确定退出登录？", left: left, right: right)
            } else {
                self?.delegate?.settingDidClickItem(type: .login)
            }
        }.disposed(by: rx.disposeBag)
        
        items.append(SectionModel(model: "3", items: [setting6]))
        
    }
    
    private func setupUI() {
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.backgroundColor = .clear
        tableView.rowHeight = 55.uiX
        tableView.separatorStyle = .none
        tableView.tableHeaderView = UIView()
        tableView.tableFooterView = UIView()
        if #available(iOS 11, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        tableView.register(cellType: SettingTableCell.self)
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupBinding() {
        
        let datasource = RxTableViewSectionedReloadDataSource<SectionModel<String, SettingModel>>(configureCell: { dataSource, tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: SettingTableCell.self)
            cell.bind(to: item)
            return cell
        })
        
        tableView.rx.setDelegate(self).disposed(by: rx.disposeBag)
        Observable.of(items).bind(to: tableView.rx.items(dataSource: datasource)).disposed(by: rx.disposeBag)
        tableView.rx.itemSelected.subscribe(onNext: {[weak self] indexPath in
            guard let self = self else { return }
            self.tableView.deselectRow(at: indexPath, animated: true)
            let model = self.items[indexPath.section].items[indexPath.row]
            model.action.accept(())
        }).disposed(by: rx.disposeBag)
        
    }
    
}

extension SettingViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == items.count - 1 {
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
