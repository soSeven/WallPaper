//
//  SearchViewController.swift
//  WallPaper
//
//  Created by LiQi on 2020/4/29.
//  Copyright © 2020 Qire. All rights reserved.
//

import UIKit

protocol SearchViewControllerDelegate: AnyObject {
    
    func searchDidClose(controller: SearchViewController)
    
    func searchShowWallPaper(controller: SearchViewController, model: WallPaperInfoModel, image: UIImage?, sortId: Int, kindId: Int, colorId: Int, search: String)
    
}

class SearchViewController: ViewController {
    
    weak var delegate: SearchViewControllerDelegate?
    
    var searchBar: SearchBarView!
    var contentView: UIView!
    
    var placeHolder: String?
    
    lazy var historyController: SearchHistoryViewController = {
        let h = SearchHistoryViewController()
        h.viewModel = SearchHistoryViewModel()
        self.addChild(h)
        self.view.addSubview(h.view)
        h.view.snp.makeConstraints { make in
            make.edges.equalTo(self.contentView)
        }
        return h
    }()
    
    lazy var resultController: SearchResultViewController = {
        let r = SearchResultViewController()
        r.viewModel = SearchResultViewModel()
        self.addChild(r)
        self.view.addSubview(r.view)
        r.view.snp.makeConstraints { make in
            make.edges.equalTo(self.contentView)
        }
        return r
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        hbd_barHidden = true
        LibsManager.shared.setupKeyboardManagerShow(show: false)
        setupUI()
        setupBinding()
    }
    
    override func onceWhenViewDidAppear(_ animated: Bool) {
        searchBar.textField.becomeFirstResponder()
    }
    
    deinit {
        LibsManager.shared.setupKeyboardManagerShow(show: true)
    }
    
    // MARK: - Binding
    
    private func setupBinding() {
        
        searchBar.textField.rx.controlEvent(.editingDidEndOnExit).bind {[weak self] _ in
            guard let self = self else { return }
            self.searchWallPaper(search: self.searchBar.textField.text)
        }.disposed(by: rx.disposeBag)
        
        searchBar.textField.rx.controlEvent(.editingDidBegin).bind {[weak self] _ in
            guard let self = self else { return }
            self.resultController.view.isHidden = true
            self.historyController.view.isHidden = false
        }.disposed(by: rx.disposeBag)
        
        historyController.search.bind {[weak self] str in
            guard let self = self else { return }
            self.searchBar.textField.resignFirstResponder()
            self.searchWallPaper(search: str)
        }.disposed(by: rx.disposeBag)
        
        resultController.showWallPaper.subscribe(onNext: {[weak self] m in
            guard let self = self else { return }
            let (model, img) = m
            let sortId = self.resultController.sortRelay.value
            let kindId = self.resultController.kindRelay.value
            let colorId = self.resultController.colorRelay.value
            let search = self.resultController.searchRelay.value
            self.delegate?.searchShowWallPaper(controller: self, model: model, image: img, sortId: sortId, kindId: kindId, colorId: colorId, search: search)
        }).disposed(by: rx.disposeBag)
    }
    
    // MARK: - UI
    
    private func setupUI() {
        
        searchBar = SearchBarView()
        searchBar.textField.placeholder = placeHolder ?? "搜索"
        searchBar.vipBtn.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            self.delegate?.searchDidClose(controller: self)
        }).disposed(by: rx.disposeBag)
        view.addSubview(searchBar)
        searchBar.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(UIDevice.statusBarHeight + 64.uiX)
        }
        
        contentView = UIView()
        view.addSubview(contentView)
        contentView.backgroundColor = .red
        contentView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(searchBar.snp.bottom)
        }
        
        self.historyController.view.isHidden = false
        self.resultController.view.isHidden = true
        
        
    }
    
    private func searchWallPaper(search: String?) {
        var s = ""
        if let search = search, !search.isEmpty {
            s = search
        } else {
            if let p = placeHolder, p != "搜索" {
                s = p
            } else {
                return
            }
        }
        searchBar.textField.text = s
        resultController.view.isHidden = false
        historyController.view.isHidden = true
        historyController.addHistoryRecord.accept(s)
        resultController.searchRelay.accept(s)
    }

}
