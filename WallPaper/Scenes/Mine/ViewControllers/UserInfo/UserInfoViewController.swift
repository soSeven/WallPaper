//
//  UserInfoViewController.swift
//  WallPaper
//
//  Created by LiQi on 2020/5/11.
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

class UserInfoModel {
    
    var title = ""
    var content = BehaviorRelay<String>(value: "")
    var action: (() -> ())?
    var arrowHidden = false
    var contentColor = BehaviorRelay<UIColor>(value: .white)
    
}

protocol UserInfoViewControllerDelegate: AnyObject {
    
    func userInfoShowNickName(controller: UserInfoViewController)
    func userInfoShowBirthday(controller: UserInfoViewController)
    func userInfoShowPhone(controller: UserInfoViewController, isChange: Bool)
    
}

class UserInfoViewController: ViewController {
    
    var viewModel: UserInfoViewModel!
    
    let sexRelay = PublishRelay<UserInfoSexType>()
    let areaRelay = PublishRelay<String>()
    let imageRelay = PublishRelay<UIImage>()
    
    private var items: [SectionModel<String, UserInfoModel>] = []
    
    weak var delegate: UserInfoViewControllerDelegate?
    
    private var tableView: UITableView!
    
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
        
        let id = UserInfoModel()
        id.title = "用户ID"
        id.arrowHidden = true
        
        let nick = UserInfoModel()
        nick.title = "昵称"
        nick.action = { [weak self] in
            guard let self = self else { return }
            self.delegate?.userInfoShowNickName(controller: self)
        }
        
        let sex = UserInfoModel()
        sex.title = "性别"
        sex.action = { [weak self] in
            guard let self = self else { return }
            let sheet = UserInfoSexSheetView()
            sheet.sexRelay.bind(to: self.sexRelay).disposed(by: self.rx.disposeBag)
            sheet.show()
        }
        
        let area = UserInfoModel()
        area.title = "地区"
        area.action = { [weak self] in
            guard let self = self else { return }
            let sheet = UserInfoAreaSheetView()
            sheet.areaRelay.bind(to: self.areaRelay).disposed(by: self.rx.disposeBag)
            sheet.show()
        }
        
        let star = UserInfoModel()
        star.title = "星座"
        star.action = { [weak self] in
            guard let self = self else { return }
            self.delegate?.userInfoShowBirthday(controller: self)
        }
        
        let phone = UserInfoModel()
        phone.title = "手机号"
        
        let wx = UserInfoModel()
        wx.title = "微信"
        
        let qq = UserInfoModel()
        qq.title = "QQ"
        
        UserManager.shared.login.subscribe(onNext: { model in
            guard let m = model else { return }
            
            id.content.accept(String(m.id))
            nick.content.accept(String(m.nickname))
            var sexStr = ""
            switch m.sex {
            case 1:
                sexStr = "男"
            case 2:
                sexStr = "女"
            default:
                sexStr = "保密"
            }
            sex.content.accept(sexStr)
            
            //area
            if let areaStr = m.area, !areaStr.isEmpty {
                area.content.accept(areaStr)
                area.contentColor.accept(.white)
            } else {
                area.content.accept("请选择")
                area.contentColor.accept(.init(hex: "#666666"))
            }
            
            //star
            if let starStr = m.constellation, !starStr.isEmpty {
                star.content.accept(starStr)
                star.contentColor.accept(.white)
            } else {
                star.content.accept("请选择")
                star.contentColor.accept(.init(hex: "#666666"))
            }
            
            if m.wxOpenid {
                wx.content.accept("已绑定")
                wx.contentColor.accept(.init(hex: "#666666"))
            } else {
                wx.content.accept("去绑定")
                wx.contentColor.accept(.white)
            }
            
            if let mobile = m.mobile, !mobile.isEmpty {
                phone.content.accept("已绑定")
                phone.contentColor.accept(.init(hex: "#666666"))
                phone.action = { [weak self] in
                    guard let self = self else { return }
                    self.delegate?.userInfoShowPhone(controller: self, isChange: true)
                }
            } else {
                phone.content.accept("去绑定")
                phone.contentColor.accept(.white)
                phone.action = { [weak self] in
                    guard let self = self else { return }
                    self.delegate?.userInfoShowPhone(controller: self, isChange: false)
                }
            }
            
            if m.qqOpenid {
                qq.content.accept("已绑定")
                qq.contentColor.accept(.init(hex: "#666666"))
            } else {
                qq.content.accept("去绑定")
                qq.contentColor.accept(.white)
            }
            
            
        }).disposed(by: rx.disposeBag)
        
        items.append(SectionModel(model: "1", items: [id, nick, sex, area, star]))
        
        items.append(SectionModel(model: "2", items: [phone, wx, qq]))
        
    }
    
    private func setupUI() {
        
        let header = UIView(frame: .init(x: 0, y: 0, width: 0, height: 120.uiX))
        
        let avatarImgView = UIImageView()
        avatarImgView.contentMode = .scaleAspectFill
        avatarImgView.cornerRadius = 31.uiX
        header.addSubview(avatarImgView)
        avatarImgView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(26.uiX)
            make.size.equalTo(CGSize(width: 62.uiX, height: 62.uiX))
        }
        UserManager.shared.login.bind { user in
            avatarImgView.kf.setImage(with: URL(string: user?.avatar), placeholder: UIImage(named: "mine_img_user_default"))
        }.disposed(by: rx.disposeBag)
        
        avatarImgView.rx.tap().subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            PhotoPicker.shared.pickUserInfoPhoto(controller: self) {[weak self] img in
                guard let self = self else { return }
                guard let i = img else { return }
                self.imageRelay.accept(i)
            }
        }).disposed(by: rx.disposeBag)
        
        let lbl = UILabel()
        lbl.text = "点击更换头像"
        lbl.font = .init(style: .regular, size: 12.uiX)
        lbl.textColor = .init(hex: "#999999")
        header.addSubview(lbl)
        lbl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(avatarImgView.snp.bottom).offset(8.uiX)
        }
        
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.backgroundColor = .clear
        tableView.rowHeight = 55.uiX
        tableView.separatorStyle = .none
        tableView.tableHeaderView = header
        tableView.tableFooterView = UIView()
        if #available(iOS 11, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        tableView.register(cellType: UserInfoTableCell.self)
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupBinding() {
        
        let datasource = RxTableViewSectionedReloadDataSource<SectionModel<String, UserInfoModel>>(configureCell: { dataSource, tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: UserInfoTableCell.self)
            cell.bind(to: item)
            return cell
        })
        
        tableView.rx.setDelegate(self).disposed(by: rx.disposeBag)
        Observable.of(items).bind(to: tableView.rx.items(dataSource: datasource)).disposed(by: rx.disposeBag)
        tableView.rx.itemSelected.subscribe(onNext: {[weak self] indexPath in
            guard let self = self else { return }
            self.tableView.deselectRow(at: indexPath, animated: true)
            let model = self.items[indexPath.section].items[indexPath.row]
            model.action?()
        }).disposed(by: rx.disposeBag)
        
        let input = UserInfoViewModel.Input(saveSex: sexRelay.asObservable(),
                                            saveArea: areaRelay.asObservable(),
                                            saveImage: imageRelay.asObservable())
        let output = viewModel.transform(input: input)
        
        output.showSuccess.bind(to: view.rx.mbHudText).disposed(by: rx.disposeBag)
        viewModel.loading.asObservable().bind(to: view.rx.mbHudLoaingForce).disposed(by: rx.disposeBag)
        viewModel.parsedError.asObserver().bind(to: view.rx.toastError).disposed(by: rx.disposeBag)
        
    }
    
}

extension UserInfoViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == items.count - 1 {
            return UIView()
        }
        let v = UIView()
        let lbl = UILabel()
        lbl.text = "多账号登录绑定"
        lbl.font = .init(style: .regular, size: 13.uiX)
        lbl.textColor = .init(hex: "#999999")
        v.addSubview(lbl)
        lbl.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15.uiX)
            make.bottom.equalToSuperview()
        }
        return v
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 30.uiX
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.001
        
    }
}
