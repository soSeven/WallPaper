//
//  WallPaperInfoCell.swift
//  WallPaper
//
//  Created by LiQi on 2020/4/11.
//  Copyright © 2020 Qire. All rights reserved.
//

import UIKit
import Reusable
import Kingfisher

class WallPaperInfoCell: UICollectionViewCell, Reusable {
    
    let imgView = UIImageView()
    let vipImgView = UIImageView(image: UIImage(named: "home_img_label_vip"))
    let freeImgView = UIImageView(image: UIImage(named: "home_img_label_free"))
    let shadowImgView = UIImageView(image: UIImage(named: "home_img_shadow"))
    let downloadImgView = UIImageView(image: UIImage(named: "home_icon_download"))
    let placeholderImgView = UIImageView(image: UIImage(named: "cover_img_default"))

    let titleLbl: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .init(hex: "#ffffff")
        lbl.font = .init(style: .regular, size: 13.uiX)
        return lbl
    }()
    
    let numberLbl: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .init(hex: "#ffffff")
        lbl.font = .init(style: .regular, size: 11.uiX)
        return lbl
    }()
    
    let timeLbl: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .init(hex: "#ffffff")
        lbl.font = .init(style: .regular, size: 11.uiX)
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.layer.cornerRadius = 10.uiX
        self.contentView.clipsToBounds = true
        self.contentView.backgroundColor = .init(hex: "#494b55")
        
        self.contentView.addSubview(placeholderImgView)
        placeholderImgView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        self.contentView.addSubview(imgView)
        imgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.contentView.addSubview(vipImgView)
        vipImgView.snp.makeConstraints { make in
            make.size.equalTo(vipImgView.snpSize)
            make.top.equalToSuperview().offset(5.uiX)
            make.right.equalToSuperview().offset(-5.uiX)
        }
        
        self.contentView.addSubview(freeImgView)
        freeImgView.snp.makeConstraints { make in
            make.size.equalTo(vipImgView.snpSize)
            make.top.equalToSuperview().offset(5.uiX)
            make.right.equalToSuperview().offset(-5.uiX)
        }
        
        self.contentView.addSubview(shadowImgView)
        shadowImgView.snp.makeConstraints { make in
            make.height.equalTo(self.shadowImgView.snp.width).multipliedBy(self.shadowImgView.snpScale)
            make.left.right.bottom.equalToSuperview()
        }
        
        self.contentView.addSubview(titleLbl)
        titleLbl.snp.makeConstraints { make in
            make.top.equalTo(self.shadowImgView.snp.top).offset(10.uiX)
            make.left.equalToSuperview().offset(7.uiX)
            make.right.equalToSuperview().offset(-7.uiX)
        }
        
        self.contentView.addSubview(downloadImgView)
        downloadImgView.snp.makeConstraints { make in
            make.size.equalTo(downloadImgView.snpSize)
            make.left.equalToSuperview().offset(7.uiX)
            make.bottom.equalToSuperview().offset(-6.uiX)
        }
        
        self.contentView.addSubview(numberLbl)
        numberLbl.snp.makeConstraints { make in
            make.centerY.equalTo(self.downloadImgView.snp.centerY)
            make.left.equalTo(self.downloadImgView.snp.right).offset(Float(3.5).uiX)
        }

        self.contentView.addSubview(timeLbl)
        timeLbl.snp.makeConstraints { make in
            make.centerY.equalTo(self.downloadImgView.snp.centerY)
            make.right.equalToSuperview().offset(Float(-8.5).uiX)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ model: WallPaperInfoModel) {
        imgView.kf.setImage(with: URL(string: model.cover))
        titleLbl.text = model.descriptionField
        freeImgView.isHidden = (model.isVip > 0)
        vipImgView.isHidden = !(model.isVip > 0)
        numberLbl.text = String(model.visitNum)
        timeLbl.text = String(model.duration/1000) + "s"
    }
    
    func bind(_ model: WallPaperModel) {
        imgView.kf.setImage(with: URL(string: model.cover))
        titleLbl.text = model.descriptionField
        freeImgView.isHidden = (model.isVip > 0)
        vipImgView.isHidden = !(model.isVip > 0)
        numberLbl.text = String(model.visitNum)
        timeLbl.text = String(model.duration/1000) + "s"
    }
    
}
