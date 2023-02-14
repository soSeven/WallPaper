//
//  HelpListTableCell.swift
//  WallPaper
//
//  Created by LiQi on 2020/4/27.
//  Copyright © 2020 Qire. All rights reserved.
//

import UIKit
import Reusable
import RxCocoa
import RxSwift

class HelpListTableCell: TableViewCell {

    let titleLbl: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .init(hex: "#FFFFFF")
        lbl.font = .init(style: .regular, size: 15.uiX)
        return lbl
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(titleLbl)
        titleLbl.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15.uiX)
            make.centerY.equalToSuperview()
        }

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Bind
    
    func bind(to viewModel: HelpListModel) {
        
        titleLbl.text = viewModel.title
        
    }

}
