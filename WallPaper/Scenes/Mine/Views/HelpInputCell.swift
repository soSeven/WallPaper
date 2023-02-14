//
//  HelpInputCell.swift
//  WallPaper
//
//  Created by LiQi on 2020/4/28.
//  Copyright © 2020 Qire. All rights reserved.
//

import UIKit
import RxSwift

class HelpInputCell: CollectionViewCell {
    
    lazy var titleLbl: UILabel = {
        let l = UILabel()
        l.textColor = .white
        l.font = .init(style: .regular, size: 14.uiX)
        return l
    }()
    lazy var markImgView: UIImageView = {
        let i = UIImageView(image: UIImage(named: "question_img_symbol"))
        return i
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(titleLbl)
        contentView.addSubview(markImgView)
        
        titleLbl.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(markImgView.snp.right).offset(9.uiX)
        }
        markImgView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15.uiX)
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(to model: HelpInputCellViewModel) {
        
        cellDisposeBag = DisposeBag()
        
        model.name.bind(to: titleLbl.rx.text).disposed(by: cellDisposeBag)
        model.selected.bind {[weak self] selected in
            guard let self = self else { return }
            self.markImgView.image = UIImage(named: selected ? "question_img_choose":"question_img_choose_nor")
        }.disposed(by: cellDisposeBag)
    }
}
