//
//  WallPaperHomeControler.swift
//  WallPaper
//
//  Created by LiQi on 2020/4/21.
//  Copyright © 2020 Qire. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources
import Reusable
import Hero
import SwiftDate

class WallPaperHomeCollectionHeader: UICollectionReusableView, Reusable {
    
    let nameLbl = UILabel()
    let monthLbl = UILabel()
    let dayLbl = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        nameLbl.textColor = .init(hex: "#ffffff")
        nameLbl.font = .init(style: .regular, size: 16.uiX)
        
        dayLbl.textColor = .init(hex: "#ffffff")
        dayLbl.font = .init(style: .regular, size: 24.uiX)
        
        monthLbl.textColor = .init(hex: "#999999")
        monthLbl.font = .init(style: .regular, size: 12.uiX)
        
        let desLbl = UILabel()
        desLbl.textColor = .init(hex: "#FFFFFF")
        desLbl.text = "发布了视频"
        desLbl.font = .init(style: .regular, size: 12.uiX)
        
        addSubview(nameLbl)
        nameLbl.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(15.uiX)
        }
        
        addSubview(dayLbl)
        dayLbl.snp.makeConstraints { make in
            make.top.equalTo(nameLbl.snp.bottom).offset(10.uiX)
            make.left.equalToSuperview().offset(15.uiX)
        }
        
        addSubview(monthLbl)
        monthLbl.snp.makeConstraints { make in
            make.lastBaseline.equalTo(dayLbl.snp.lastBaseline)
            make.left.equalTo(dayLbl.snp.right).offset(3.uiX)
        }
        
        addSubview(desLbl)
        desLbl.snp.makeConstraints { make in
            make.centerY.equalTo(dayLbl.snp.centerY)
            make.left.equalTo(monthLbl.snp.right).offset(22.uiX)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class WallPaperHomeHeader: UIView {
    
    let imgView = UIImageView()
    let nameLbl = UILabel()
    let sexImgView = UIImageView(image: UIImage(named: "homepage_icon_female"))
    let sexLbl = UILabel()
    let areaLbl = UILabel()
    let coLbl = UILabel()
    let vipImgView = UIImageView(image: UIImage(named: "homepage_img_label_vip"))
    let btn = UIButton()
    let line1 = UIView()
    let line2 = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let titleContentView = UIView()
//        titleContentView.backgroundColor = .red
        
        imgView.cornerRadius = 25.uiX
        addSubview(imgView)
        imgView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 50.uiX, height: 50.uiX))
            make.left.equalToSuperview().offset(15.uiX)
            make.top.equalToSuperview().offset(21.uiX)
        }
        
        addSubview(btn)
        btn.cornerRadius = 16.uiX
        btn.setBackgroundImage(UIImage(color: .init(hex: "#383A43"), size: .init(width: 1, height: 1)), for: .selected)
        btn.setBackgroundImage(UIImage(color: .init(hex: "#FF2071"), size: .init(width: 1, height: 1)), for: .normal)
        btn.setBackgroundImage(UIImage(color: .init(hex: "#FF2071"), size: .init(width: 1, height: 1)), for: .highlighted)
        btn.titleLabel?.font = .init(style: .medium, size: 16)
        btn.setTitle("关注", for: .normal)
        btn.setTitle("取消关注", for: .selected)
        btn.setTitle("关注", for: .highlighted)
        btn.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 100.uiX, height: 32.uiX))
            make.right.equalToSuperview().offset(-15.uiX)
            make.centerY.equalTo(self.imgView)
        }
        addSubview(titleContentView)
        titleContentView.snp.makeConstraints { make in
            make.left.equalTo(imgView.snp.right).offset(15.uiX)
            make.right.equalTo(btn.snp.left).offset(-15.uiX)
            make.centerY.equalTo(self.imgView)
        }
        
        
        line1.backgroundColor = .init(hex: "#999999")
        line2.backgroundColor = .init(hex: "#999999")
        
        titleContentView.addSubview(nameLbl)
        titleContentView.addSubview(vipImgView)
        titleContentView.addSubview(sexImgView)
        titleContentView.addSubview(sexLbl)
        titleContentView.addSubview(areaLbl)
        titleContentView.addSubview(coLbl)
        titleContentView.addSubview(line1)
        titleContentView.addSubview(line2)
        
        nameLbl.snp.makeConstraints { make in
            make.left.top.equalToSuperview()
        }
        
        vipImgView.snp.makeConstraints { make in
            make.centerY.equalTo(nameLbl)
            make.left.equalTo(nameLbl.snp.right).offset(5.uiX)
        }
        
        sexImgView.snp.makeConstraints { make in
            make.top.equalTo(nameLbl.snp.bottom).offset(7.uiX)
            make.left.bottom.equalToSuperview()
        }
        
        sexLbl.snp.makeConstraints { make in
            make.centerY.equalTo(sexImgView)
            make.left.equalTo(sexImgView.snp.right).offset(3.uiX)
        }
        
        line1.snp.makeConstraints { make in
            make.centerY.equalTo(sexImgView)
            make.left.equalTo(sexLbl.snp.right).offset(5.uiX)
            make.height.equalTo(10.uiX)
            make.width.equalTo(1/UIScreen.main.scale)
        }
        
        areaLbl.snp.makeConstraints { make in
            make.centerY.equalTo(sexImgView)
            make.left.equalTo(line1.snp.right).offset(5.uiX)
        }
        
        line2.snp.makeConstraints { make in
            make.centerY.equalTo(sexImgView)
            make.left.equalTo(areaLbl.snp.right).offset(5.uiX)
            make.height.equalTo(10.uiX)
            make.width.equalTo(1/UIScreen.main.scale)
        }
        
        coLbl.snp.makeConstraints { make in
            make.centerY.equalTo(sexImgView)
            make.left.equalTo(line2.snp.right).offset(5.uiX)
        }
        
        nameLbl.textColor = .init(hex: "#ffffff")
        nameLbl.font = .init(style: .medium, size: 17.uiX)
        sexLbl.textColor = .init(hex: "#999999")
        sexLbl.font = .init(style: .regular, size: 12.uiX)
        areaLbl.textColor = .init(hex: "#999999")
        areaLbl.font = .init(style: .regular, size: 12.uiX)
        coLbl.textColor = .init(hex: "#999999")
        coLbl.font = .init(style: .regular, size: 12.uiX)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension Reactive where Base: WallPaperHomeHeader {
    
    var model: Binder<WallPaperUserModel?> {
        return Binder<WallPaperUserModel?>(self.base) { view, model in
            guard let m = model else {
                view.isHidden = true
                return
            }
            view.btn.isSelected = m.isFollow
            view.isHidden = false
            view.nameLbl.text = m.nickname
            view.vipImgView.isHidden = m.isVip > 0
            if m.sex == 1 {
                view.sexImgView.image = UIImage(named: "homepage_icon_male")
                view.sexLbl.text = "男"
            } else if m.sex == 2 {
                view.sexImgView.image = UIImage(named: "homepage_icon_female")
                view.sexLbl.text = "女"
            } else {
                view.sexImgView.image = nil
                view.sexLbl.text = "保密"
            }
            
            if m.area.isEmpty, m.constellation.isEmpty {
                view.line1.isHidden = true
                view.line2.isHidden = true
            } else if m.area.isEmpty {
                view.line1.isHidden = false
                view.line2.isHidden = true
                view.areaLbl.text = m.constellation
            } else if m.constellation.isEmpty {
                view.line1.isHidden = false
                view.line2.isHidden = true
                view.areaLbl.text = m.area
            } else {
                view.line1.isHidden = false
                view.line2.isHidden = false
                view.areaLbl.text = m.area
                view.coLbl.text = m.constellation
            }

            view.imgView.kf.setImage(with: URL(string: m.avatar))
        }
    }
    
}

class WallPaperHomeControler: ViewController {
    
    var viewModel: WallPaperHomeViewModel!
    
    var headerView: WallPaperHomeHeader!
    var collectionView: UICollectionView!
    
    let footerRefreshTrigger = PublishSubject<Void>()
    let isAttention = PublishRelay<Bool>()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        hbd_barTintColor = AppDefine.mainColor
        hbd_barShadowHidden = true

        setupUI()
        setupBinding()
    }
    
    // MARK: - UI
    
    private func setupUI() {
        
        let layout = UICollectionViewFlowLayout()
        let scale: CGFloat = 275.0/165
        let width = (UIDevice.screenWidth - 45.uiX)/2.0
        layout.itemSize = .init(width: width, height: width*scale)
        layout.minimumLineSpacing = 15.uiX
        layout.minimumInteritemSpacing = 15.uiX
        layout.sectionInset = .init(top: 0, left: 15.uiX, bottom: 40.uiX, right: 15.uiX)
        layout.headerReferenceSize = .init(width: 200, height: 70.uiX)
        collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        
        collectionView.backgroundColor = .clear
        if #available(iOS 11, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        }
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        collectionView.register(supplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withClass: WallPaperHomeCollectionHeader.self)
        collectionView.register(cellType: WallPaperInfoCell.self)
        collectionView.mj_footer = RefreshFooter(refreshingBlock: {[weak self] in
            guard let self = self else { return }
            self.footerRefreshTrigger.onNext(())
        })
        
        let height = 100.uiX
        headerView = WallPaperHomeHeader(frame: .init(x: 0, y: -height, width: UIDevice.screenWidth, height: height))
        collectionView.addSubview(headerView)
        collectionView.contentInset = .init(top: height, left: 0, bottom: 50.uiX, right: 0)
    }
    
    private func setupBinding() {
        
        let input = WallPaperHomeViewModel.Input(request: errorBtnTap.startWith(()).asDriver(onErrorJustReturn: ()),
                                                 footerRefresh: footerRefreshTrigger.asDriverOnErrorJustComplete(),
                                                 attention: headerView.btn.rx.tap)
        let output = viewModel.transform(input: input)
        
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, WallPaperModel>>(configureCell: { (dataSource, collectionView, indexPath, model) -> UICollectionViewCell in
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: WallPaperInfoCell.self)
            cell.hero.id = "\(indexPath.section)-\(indexPath.row)"
            cell.bind(model)
            return cell
        }, configureSupplementaryView: { data, collection, title, index -> UICollectionReusableView in
            let head = collection.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, for: index, viewType: WallPaperHomeCollectionHeader.self)
            let section = data.sectionModels[index.section]
            let date = section.model.toDate()
            
            if let d = date {
                head.nameLbl.text = "\(d.year)年"
                head.dayLbl.text = "\(d.day)"
                head.monthLbl.text = "\(d.month)月"
            } else {
                head.nameLbl.text = "未知"
                head.dayLbl.text = "未知"
                head.monthLbl.text = "未知"
            }
            
            if index.section == 0 {
                head.nameLbl.text = "最新动态"
            }
            return head
        })
        
        collectionView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
            guard let self = self else { return }
            let cell = self.collectionView.cellForItem(at: indexPath) as? WallPaperInfoCell
            let model = output.items.value[indexPath.section].wallpaperList[indexPath.row]
            let wallPaper = WallPaperViewController()
            wallPaper.isFromHome = true
            wallPaper.defaultImg = cell?.imgView.image
            let dict:[[String: Any]] = [[
                "page": model.page ?? 0,
                "id": model.id ?? 0
            ]]
            let viewModel = WallPaperViewModel(service: HomeUserWallPaperService(userId: model.userId), jsonDict: dict)
            viewModel.defaultElements = (model, output.items.value[indexPath.section].wallpaperList)
            wallPaper.viewModel = viewModel
            wallPaper.view.hero.id = "\(indexPath.section)-\(indexPath.row)"
//            wallPaper.isHeroEnabled = true
            
            let nav = NavigationController(rootViewController: wallPaper)
            nav.hero.isEnabled = true
            nav.modalPresentationStyle = .overFullScreen
            self.present(nav, animated: true, completion: nil)
            
        }).disposed(by: rx.disposeBag)
        
        Observable.combineLatest(collectionView.rx.didScroll, output.user).subscribe(onNext: { [weak self] _, userModel in
            guard let self = self else { return }
            if self.collectionView.contentOffset.y >= 0, let u = userModel {
                self.navigationItem.title = u.nickname
            } else {
                self.navigationItem.title = nil
            }
        }).disposed(by: rx.disposeBag)
 
        output.user.bind(to: headerView.rx.model).disposed(by: rx.disposeBag)
        output.isAttention.flatMap { Observable.of($0 ? "关注成功" : "已取消关注") }.bind(to: view.rx.mbHudText).disposed(by: rx.disposeBag)
        output.isAttention.bind(to: isAttention).disposed(by: rx.disposeBag)
        output.items.mapMany { model in
            SectionModel<String, WallPaperModel>(model: model.date, items: model.wallpaperList)
        }.bind(to: collectionView.rx.items(dataSource: dataSource)).disposed(by: rx.disposeBag)
        
        output.showErrorView.bind(to: rx.showErrorView()).disposed(by: rx.disposeBag)
        output.firstLoading.bind(to: view.rx.mbHudLoaing).disposed(by: rx.disposeBag)
        output.footerLoading.bind(to: collectionView.mj_footer!.rx.refreshStatus).disposed(by: rx.disposeBag)
    }
    
}
