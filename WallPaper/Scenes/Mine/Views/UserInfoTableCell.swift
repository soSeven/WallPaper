//
//  UserInfoTableCell.swift
//  WallPaper
//
//  Created by LiQi on 2020/5/11.
//  Copyright © 2020 Qire. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class UserInfoTableCell: TableViewCell {

    lazy var titleLbl: UILabel = {
        let l = UILabel()
        l.text = ""
        l.textColor = .white
        l.font = .init(style: .regular, size: 15.uiX)
        return l
    }()
    
    lazy var contentLbl: UILabel = {
        let l = UILabel()
        l.text = ""
        l.textColor = .white
        l.font = .init(style: .regular, size: 14.uiX)
        return l
    }()
    
    let arrowImgView = UIImageView(image: UIImage(named: "mine_icon_arrow_right"))
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(titleLbl)
        titleLbl.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15.uiX)
            make.centerY.equalToSuperview()
        }
        
        let stack = UIStackView(arrangedSubviews: [contentLbl, arrowImgView])
        stack.spacing = 5.uiX
        stack.alignment = .center
        arrowImgView.snp.makeConstraints { make in
            make.size.equalTo(arrowImgView.snpSize)
        }
        
        contentView.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-15.uiX)
            make.top.bottom.equalToSuperview()
            make.width.lessThanOrEqualTo(150.uiX)
        }

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Bind
    
    func bind(to viewModel: UserInfoModel) {
        
        cellDisposeBag = DisposeBag()
        
        viewModel.contentColor.bind {[weak self] color in
            guard let self = self else { return }
            self.contentLbl.textColor = color
        }.disposed(by: cellDisposeBag)
        arrowImgView.isHidden = viewModel.arrowHidden
        titleLbl.text = viewModel.title
        viewModel.content.bind(to: contentLbl.rx.text).disposed(by: cellDisposeBag)
        
    }
}
