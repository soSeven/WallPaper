//
//  SettingTableCell.swift
//  WallPaper
//
//  Created by LiQi on 2020/4/26.
//  Copyright © 2020 Qire. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class SettingTableCell: TableViewCell {

    let titleLbl: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .init(hex: "#FFFFFF")
        lbl.font = .init(style: .regular, size: 15.uiX)
        return lbl
    }()
    let arrowImgView = UIImageView(image: UIImage(named: "mine_icon_arrow"))
    let msgLbl: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .init(hex: "#FFFFFF")
        lbl.font = .init(style: .regular, size: 14.uiX)
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
        
        contentView.addSubview(arrowImgView)
        arrowImgView.snp.makeConstraints { make in
            make.size.equalTo(arrowImgView.snpSize)
            make.right.equalToSuperview().offset(-15.uiX)
            make.centerY.equalToSuperview()
        }
        
        contentView.addSubview(msgLbl)
        msgLbl.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-15.uiX)
            make.centerY.equalToSuperview()
        }

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Bind
    
    func bind(to viewModel: SettingModel) {
        
        cellDisposeBag = DisposeBag()
        
        viewModel.title.bind(to: titleLbl.rx.text).disposed(by: cellDisposeBag)
        viewModel.detailRelay.bind {[weak self] text in
            guard let self = self else { return }
            if text.isEmpty {
                self.msgLbl.isHidden = true
                self.arrowImgView.isHidden = false
                self.msgLbl.text = nil
            } else {
                self.msgLbl.text = text
                self.msgLbl.isHidden = false
                self.arrowImgView.isHidden = true
            }
        }.disposed(by: cellDisposeBag)
        
    }

}
