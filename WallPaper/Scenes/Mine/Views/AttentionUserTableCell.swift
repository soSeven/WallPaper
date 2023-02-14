//
//  AttentionUserTableCell.swift
//  WallPaper
//
//  Created by LiQi on 2020/4/29.
//  Copyright © 2020 Qire. All rights reserved.
//

import UIKit
import RxSwift

class AttentionUserTableCell: TableViewCell {
    
    lazy var imgView: UIImageView = {
        let i = UIImageView()
        i.backgroundColor = .darkGray
        i.cornerRadius = 22.uiX
        return i
    }()
    lazy var nameLbl: UILabel = {
        let l = UILabel()
        l.text = ""
        l.textColor = .white
        l.font = .init(style: .medium, size: 15.uiX)
        return l
    }()
    lazy var sexImgView: UIImageView = {
        let i = UIImageView()
        return i
    }()
    lazy var btn: UIButton = {
        let l = UIButton()
        l.cornerRadius = 14.uiX
        l.setTitleColor(.white, for: .normal)
        l.setTitleColor(.white, for: .selected)
        l.setTitle("已关注", for: .selected)
        l.setTitle("关注", for: .normal)
        l.setBackgroundImage(.init(color: .init(hex: "#383A43"), size: .init(width: 1, height: 1)), for: .selected)
        l.setBackgroundImage(.init(color: .init(hex: "#FF2071"), size: .init(width: 1, height: 1)), for: .normal)
        l.titleLabel?.font = .init(style: .medium, size: 14.uiX)
        return l
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(imgView)
        contentView.addSubview(nameLbl)
        contentView.addSubview(sexImgView)
        contentView.addSubview(btn)
        
        imgView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 44.uiX, height: 44.uiX))
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(15.uiX)
        }
        
        nameLbl.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(imgView.snp.right).offset(14.uiX)
        }
        
        sexImgView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(nameLbl.snp.right).offset(5.uiX)
        }
        
        btn.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 68.uiX, height: 28.uiX))
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-15.uiX)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(to model: AttentionUserCellViewModel) {
        
        cellDisposeBag = DisposeBag()
        
        nameLbl.text = model.model.nickname
        imgView.kf.setImage(with: URL(string: model.model.avatar))
        sexImgView.isHidden = false
        switch model.model.sex {
        case 1:
            sexImgView.image = UIImage(named: "mine_icon_male")
        case 2:
            sexImgView.image = UIImage(named: "mine_icon_female")
        default:
            sexImgView.isHidden = true
        }
        model.isAttention.bind(to: btn.rx.isSelected).disposed(by: cellDisposeBag)
        btn.rx.tap.bind(to: model.attention).disposed(by: cellDisposeBag)
    }
    
}
