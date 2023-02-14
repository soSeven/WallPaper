//
//  HomeViewController.swift
//  WallPaper
//
//  Created by LiQi on 2020/4/9.
//  Copyright © 2020 Qire. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit
import Reusable
import Toast_Swift
import FSPagerView

enum HomeItemType: Int {
    case rank = 0
    case kinds = 1
    case color = 2
    case video = 3
}

protocol HomeViewControllerDelegate: AnyObject {
    
    func showItemController(controller: HomeViewController, with type: HomeItemType)
    func homeDidSelectedItem(controller: HomeViewController, model: WallPaperInfoModel, image: UIImage?, categoryId: Int)
    func homeDidSelectedBanner(controller: HomeViewController, model: BannerModel)
    func homeDidSearch(controller: HomeViewController, model: SearchHomeListModel?)
}

class HomeViewController: ViewController {
    
    var viewModel: HomeViewModel!
    weak var delegate: HomeViewControllerDelegate?
    let isLoading = BehaviorRelay(value: false)
    
    // MARK: - UI
    
    private var wallPaperListView: WallPaperCollectionView!
    private var pagerView: FSPagerView!
    private var pageControl: FSPageControl!
    private var searchLbl: UILabel!
    
    // MARK: - Data
    
    private var banners = [BannerModel]()
    private var currentSearch: SearchHomeListModel?
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hbd_barHidden = true
        automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = AppDefine.mainColor
        setupUI()
        setupBinding()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        
        let (searchBar, slbl, btn) = getSearchBar()
        searchLbl = slbl
        
        wallPaperListView = WallPaperCollectionView(frame: self.view.bounds)
        view.addSubview(wallPaperListView)
        wallPaperListView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(searchBar.snp.bottom)
            make.bottom.equalTo(self.view.snp.bottomMargin)
        }
        
        
//        let scale: CGFloat = 110.0/345.0
        let height = 237.uiX
        
        wallPaperListView.collectionView.contentInset = .init(top: height, left: 0, bottom: 40, right: 0)
        wallPaperListView.collectionView.mj_header?.ignoredScrollViewContentInsetTop = height
        let headerView = UIView(frame: .init(x: 0, y: -height, width: UIDevice.screenWidth, height: height))
//        headerView.backgroundColor = .red
        wallPaperListView.collectionView.addSubview(headerView)
        
        // Create a pager view
        pagerView = FSPagerView(frame: .zero)
        pagerView.isInfinite = true
        pagerView.automaticSlidingInterval = 3
        pagerView.dataSource = self
        pagerView.delegate = self
        pagerView.itemSize = .init(width: 345.uiX, height: 110.uiX)
        pagerView.interitemSpacing = (UIScreen.main.bounds.width - 345)
        pagerView.contentMode = .bottom
        pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        headerView.addSubview(pagerView)
        pagerView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(110.uiX)
        }
        
        // Create a page control
        pageControl = FSPageControl(frame: .zero)
        pageControl.hidesForSinglePage = true
        pagerView.addSubview(pageControl)
        pageControl.snp.makeConstraints { make in
            make.bottom.left.right.equalToSuperview()
            make.height.equalTo(30.uiX)
        }
        
        let stack = UIStackView(arrangedSubviews: [
            getItem(imgName: "home_img_rank", title: "排行", tag: .rank),
            getItem(imgName: "home_img_class", title: "分类", tag: .kinds),
            getItem(imgName: "home_img_color", title: "色系", tag: .color),
            getItem(imgName: "home_img_video", title: "短视频", tag: .video),
        ])
        stack.distribution = .fillEqually
        headerView.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.pagerView.snp.bottom)
            make.height.equalTo(94.uiX)
        }
        
        let lbl = UILabel()
        lbl.text = "最新推荐"
        lbl.textColor = .init(hex: "#ffffff")
        lbl.font = .init(style: .regular, size: 17.uiX)
        headerView.addSubview(lbl)
        lbl.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15.uiX)
            make.top.equalTo(stack.snp.bottom).offset(-4.uiX)
        }
        
    }
    
    private func setupBinding() {
        
        let input = HomeViewModel.Input(requestSearchList: Observable<Void>.just(()),
                                        headerRefresh: wallPaperListView.headerRefreshTrigger.startWith(()),
                                        footerRefresh: wallPaperListView.footerRefreshTrigger)
        let output = viewModel.transform(input: input)
        
        output.items.bind(to: wallPaperListView.itemsRelay).disposed(by: rx.disposeBag)

        wallPaperListView.itemSelected.bind { [weak self] indexPath in
            guard let self = self else { return }
            if indexPath.row >= output.items.value.count {
                return
            }
            let model = output.items.value[indexPath.row]
            let cell = self.wallPaperListView.collectionView.cellForItem(at: indexPath) as? WallPaperInfoCell
            self.delegate?.homeDidSelectedItem(controller: self, model: model, image: cell?.imgView.image, categoryId: 0)
        }.disposed(by: rx.disposeBag)
        
        if let footer = wallPaperListView.collectionView.mj_footer {
            output.footerLoading.bind(to: footer.rx.refreshStatus).disposed(by: rx.disposeBag)
        }
        if let header = wallPaperListView.collectionView.mj_header {
            output.headerLoading.asObservable().bind(to: header.rx.isAnimating).disposed(by: rx.disposeBag)
        }
        
        viewModel.parsedError.bind(to: view.rx.toastError).disposed(by: rx.disposeBag)
        
        // banner
        output.banners.asDriver(onErrorJustReturn: []).drive(onNext: {[weak self] banners in
            guard let self = self else { return }
            self.banners = banners
            self.pageControl.numberOfPages = self.banners.count
            self.pagerView.reloadData()
        }).disposed(by: rx.disposeBag)
        
        output.search.subscribe(onNext: {[weak self] model in
            guard let self = self else { return }
            self.searchLbl.text = "大家都在搜：" + model.name
            self.currentSearch = model
        }).disposed(by: rx.disposeBag)
        
        // tabbar
        wallPaperListView.didScroll.subscribe(onNext: {[weak self] offsetY in
            guard let self = self else { return }
            guard let tabController = self.tabBarController as? TabBarController else { return }
            if offsetY >= UIDevice.screenHeight {
                tabController.scrollToTopStatus.accept(false)
            } else {
                tabController.scrollToTopStatus.accept(true)
            }
        }).disposed(by: rx.disposeBag)
        
        if let tabController = tabBarController as? TabBarController {
            tabController.scrollToTop.subscribe(onNext: {[weak self] _ in
                guard let self = self else { return }
                self.wallPaperListView.collectionView.scrollToItem(at: .init(row: 0, section: 0), at: .top, animated: true)
            }).disposed(by: rx.disposeBag)
        }
        
        
    }
    
    // MARK: - Tool
    
    func getSearchBar() -> (UIView, UILabel, UIButton) {
        
        let searchBar = UIView()
        searchBar.backgroundColor = AppDefine.mainColor
        
        view.addSubview(searchBar)
        searchBar.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(UIDevice.statusBarHeight + 64.uiX)
        }
        
        let vipBtn = UIButton()
        vipBtn.setImage(UIImage(named: "home_img_btn_vip"), for: .normal)
        searchBar.addSubview(vipBtn)
        
        let searchView = UIView()
        searchView.backgroundColor = .init(hex: "#383A43")
        searchView.layer.cornerRadius = 35.uiX/2.0
        searchBar.addSubview(searchView)
        searchView.rx.tap().subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            self.delegate?.homeDidSearch(controller: self, model: self.currentSearch)
        }).disposed(by: rx.disposeBag)
        
        vipBtn.snp.makeConstraints { make in
            make.width.equalTo(36.uiX)
            make.height.equalTo(36.uiX)
            make.right.equalToSuperview().offset(-15.uiX)
            make.centerY.equalTo(searchView)
        }
        
        searchView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15.uiX)
            make.right.equalTo(vipBtn.snp.left).offset(-16.uiX)
            make.bottom.equalToSuperview().offset(-19.uiX)
            make.height.equalTo(35.uiX)
        }
        
        let contentView = UIStackView()
        contentView.spacing = 5.uiX
        let searchImgView = UIImageView(image: UIImage(named: "home_icon_search"))
        searchImgView.snp.makeConstraints { make in
            make.size.equalTo(searchImgView.snpSize)
        }
        let lbl = UILabel()
        lbl.textColor = .init(hex: "#999999")
        lbl.font = .init(style: .regular, size: 14.uiX)
        lbl.text = "大家都在搜"
        contentView.addArrangedSubview(searchImgView)
        contentView.addArrangedSubview(lbl)
        
        searchView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.lessThanOrEqualToSuperview().offset(-15)
        }
        
        return (searchBar, lbl, vipBtn)
    }
    
    func getItem(imgName: String, title: String, tag: HomeItemType) -> UIView {
        let view = UIView()
        
        let imgView = UIImageView()
        let img = UIImage(named: imgName)!
        imgView.image = img
        
        let lbl = UILabel()
        lbl.text = title
        lbl.textColor = .init(hex: "#CCCCCC")
        lbl.font = .init(style: .regular, size: 12.uiX)
        
        view.addSubview(imgView)
        view.addSubview(lbl)
        view.tag = tag.rawValue
        view.rx.tap().subscribe(onNext: { [weak view, weak self] _ in
            guard let self = self else { return }
            self.delegate?.showItemController(controller: self, with: HomeItemType(rawValue: view?.tag ?? 0) ?? .rank)
        }).disposed(by: rx.disposeBag)
        
        lbl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-20.uiX)
        }
        
        imgView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(imgView.snpSize)
            make.bottom.equalTo(lbl.snp.top).offset(-8.uiX)
        }
        
        return view
    }
    
}

extension HomeViewController: FSPagerViewDataSource {
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return self.banners.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let m = banners[index]
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        cell.imageView?.kf.setImage(with: URL(string: m.url))
        cell.imageView?.layer.cornerRadius = 10.uiX
        cell.imageView?.clipsToBounds = true
        cell.contentView.layer.shadowRadius = 0

        return cell
    }
    
}

extension HomeViewController: FSPagerViewDelegate {
    
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
        self.pageControl.currentPage = targetIndex
    }
    
    func pagerViewDidScroll(_ pagerView: FSPagerView) {
        guard self.pageControl.currentPage != pagerView.currentIndex else {
            return
        }
        self.pageControl.currentPage = pagerView.currentIndex
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        if index >= banners.count {
            return
        }
        delegate?.homeDidSelectedBanner(controller: self, model: banners[index])
    }
}
