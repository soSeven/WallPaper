//
//  SearchSortView.swift
//  WallPaper
//
//  Created by LiQi on 2020/4/30.
//  Copyright © 2020 Qire. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SearchSortTableCell: TableViewCell {
    
    lazy var titleLbl: UILabel = {
        let l = UILabel()
        l.textColor = .init(hex: "#666666")
        l.font = .init(style: .regular, size: 14.uiX)
        return l
    }()
    lazy var arrowImgView: UIImageView = {
        let i = UIImageView(image: UIImage(named: "search_icon_choose"))
        return i
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(titleLbl)
        contentView.addSubview(arrowImgView)
        
        titleLbl.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(15.uiX)
        }
        
        arrowImgView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-15.uiX)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

class SearchSortView: UIView {
    
    var tableView: UITableView!
    var titles: [String]
    var selectedIndex = 0
    var action: ((Int)->())?
    
    required init(frame: CGRect, titles: [String]) {
        self.titles = titles
        super.init(frame: frame)
        setupTableView()
        setupBinding()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTableView() {
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.rowHeight = 42.uiX
        if #available(iOS 11, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        tableView.register(cellType: SearchSortTableCell.self)
        addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupBinding() {
        
        Observable.just(titles).bind(to: tableView.rx.items(cellIdentifier: SearchSortTableCell.reuseIdentifier, cellType: SearchSortTableCell.self)) {[weak self] (row, element, cell) in
            guard let self = self else { return }
            if self.selectedIndex == row {
                cell.arrowImgView.isHidden = false
                cell.titleLbl.textColor = .init(hex: "#FF2071")
            } else {
                cell.arrowImgView.isHidden = true
                cell.titleLbl.textColor = .init(hex: "#666666")
            }
            cell.titleLbl.text = element
        }.disposed(by: rx.disposeBag)
        
        tableView.rx.itemSelected.subscribe(onNext: {[weak self] indexPath in
            guard let self = self else { return }
            self.selectedIndex = indexPath.row
            self.tableView.reloadData()
            self.action?(indexPath.row)
        }).disposed(by: rx.disposeBag)
    }
    

}
