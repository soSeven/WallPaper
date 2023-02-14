//
//  SearchHistoryViewController.swift
//  WallPaper
//
//  Created by LiQi on 2020/4/29.
//  Copyright © 2020 Qire. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import SwiftEntryKit

class SearchHistoryViewController: ViewController {
    
    private static var historyExtend = false
    
    enum HistoryType {
        case btn
        case record(String)
    }

    // MARK: - UI
    
    private var collectionView: UICollectionView!
    
    // MARK: - Data
    
    var viewModel: SearchHistoryViewModel!
    
    let search = PublishRelay<String>()
    
    private let deleteHistoryRecord = PublishRelay<Void>()
    let addHistoryRecord = PublishRelay<String>()
    
    private var records = [String]()
    private var hots = [SearchHomeListModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBinding()
    }
    
    private func setupUI() {
        let layout = UICollectionViewLeftAlignedLayout()
        collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        if #available(iOS 11, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        }
        collectionView.register(cellType: SearchHistoryBtnCell.self)
        collectionView.register(cellType: SearchHotCell.self)
        collectionView.register(cellType: SearchHistoryTitleCell.self)
        collectionView.register(supplementaryViewType: SearchTitleHeaderView.self, ofKind: UICollectionView.elementKindSectionHeader)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .onDrag
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupBinding() {
        
        let input = SearchHistoryViewModel.Input(deleteHistoryRecord: deleteHistoryRecord,
                                                 addHistoryRecord: addHistoryRecord,
                                                 requestHot: Observable<Void>.just(()))
        let output = viewModel.transform(input: input)
        
        output.historyItems.subscribe(onNext: {[weak self] records in
            guard let self = self else { return }
            self.records = records
            self.collectionView.reloadData()
        }).disposed(by: rx.disposeBag)
        
        output.hotItems.subscribe(onNext: {[weak self] models in
            guard let self = self else { return }
            self.hots = models
            self.collectionView.reloadData()
        }).disposed(by: rx.disposeBag)
    }

}

extension SearchHistoryViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            if !SearchHistoryViewController.historyExtend,
                self.records.count > 3,
                indexPath.row == 3{
                SearchHistoryViewController.historyExtend = true
                collectionView.reloadData()
                return
            }
            let str = records[indexPath.row]
            search.accept(str)
        case 1:
            let m = hots[indexPath.row]
            search.accept(m.name)
        default:
            return
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            if !SearchHistoryViewController.historyExtend,
                self.records.count > 3,
                indexPath.row == 3{
                return .init(width: 32.uiX, height: 32.uiX)
            }
            let str: NSString = records[indexPath.row] as NSString
            let size = str.size(withAttributes: [.font: UIFont(style: .regular, size: 14.uiX)])
            return .init(width: CGFloat.minimum(size.width + 34.uiX, UIDevice.screenWidth - 30.uiX), height: 32.uiX)
        default:
            return .init(width: UIDevice.screenWidth/2.0, height: 40.uiX)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        switch section {
        case 0:
            return 10.uiX
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        switch section {
        case 0:
            return 14.uiX
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch section {
        case 0:
            if records.isEmpty {
                return .zero
            }
            return .init(top: 10.uiX, left: 15.uiX, bottom: 22.uiX, right: 15.uiX)
        default:
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        switch section {
        case 0:
            if !records.isEmpty {
                return .init(width: 0, height: 35.uiX)
            }
            return .zero
        default:
            if !hots.isEmpty {
                return .init(width: 0, height: 35.uiX)
            }
            return .zero
        }
    }
}

extension SearchHistoryViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            if !SearchHistoryViewController.historyExtend,
            self.records.count > 3{
                return 4
            }
            return self.records.count
        default:
            return self.hots.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("\(indexPath.section)---\(indexPath.row)")
        switch indexPath.section {
        case 0:
            if !SearchHistoryViewController.historyExtend,
                self.records.count > 3,
                indexPath.row == 3{
                let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: SearchHistoryBtnCell.self)
                return cell
            }
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: SearchHistoryTitleCell.self)
            cell.bind(to: records[indexPath.row])
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: SearchHotCell.self)
            cell.bind(to: hots[indexPath.row], index: indexPath.row)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let head = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, for: indexPath, viewType: SearchTitleHeaderView.self)
        switch indexPath.section {
        case 0:
            head.titleLbl.text = "历史搜索"
            head.btn.isHidden = false
            head.action = { [weak self] in
                guard let self = self else { return }
                self.view.superview?.endEditing(true)
                EKAlertMessageView.showAlert(title: "温馨提示", detail: "是否确定要清空历史搜索记录？", left: EKAlertMessageView.AlertEvent(title: "取消", action: nil), right: EKAlertMessageView.AlertEvent(title: "确定", action: {
                    self.deleteHistoryRecord.accept(())
                }))
            }
        default:
            head.titleLbl.text = "大家都在搜"
            head.btn.isHidden = true
        }
        return head
    }
    
    
}
