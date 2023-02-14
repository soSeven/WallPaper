//
//  MineTitleTableCell.swift
//  WallPaper
//
//  Created by LiQi on 2020/4/14.
//  Copyright © 2020 Qire. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class MineTitleTableCell: TableViewCell {
    
    let imgView = UIImageView()
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
        lbl.font = .init(style: .regular, size: 10.uiX)
        lbl.layer.cornerRadius = 7.uiX
        lbl.backgroundColor = .init(hex: "#FF2071")
        return lbl
    }()
    let dotView: UIView = {
        let v = UIView()
        v.backgroundColor = .init(hex: "#FF2071")
        v.layer.cornerRadius = Float(4.5).uiX
        return v
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(imgView)
        imgView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 20.uiX, height: 20.uiX))
            make.left.equalToSuperview().offset(15.uiX)
            make.centerY.equalToSuperview()
        }
        
        contentView.addSubview(titleLbl)
        titleLbl.snp.makeConstraints { make in
            make.left.equalTo(self.imgView.snp.right).offset(9.uiX)
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
            make.size.equalTo(CGSize(width: 14.uiX, height: 14.uiX))
            make.right.equalTo(arrowImgView.snp.left).offset(-8.uiX)
            make.centerY.equalToSuperview()
        }
        
        contentView.addSubview(dotView)
        dotView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 9.uiX, height: 9.uiX))
            make.center.equalTo(msgLbl)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Bind
    
    func bind(to viewModel: MineCellViewModel) {
        
        cellDisposeBag = DisposeBag()
        
        imgView.image = UIImage(named: viewModel.imgName)
        titleLbl.text = viewModel.title
        viewModel.number.map{ String($0) }.bind(to: msgLbl.rx.text).disposed(by: cellDisposeBag)
        viewModel.number.map{ $0 == 0 }.bind(to: msgLbl.rx.isHidden).disposed(by: cellDisposeBag)
        viewModel.dot.map{ !$0 }.bind(to: dotView.rx.isHidden).disposed(by: cellDisposeBag)
        
    }
    
}
