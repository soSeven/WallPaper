//
//  HelpInputEditView.swift
//  WallPaper
//
//  Created by LiQi on 2020/4/28.
//  Copyright © 2020 Qire. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import IQKeyboardManagerSwift
import YYText

class HelpInputEditView: UIView {
    
    var selectedId = -1
    
    lazy var textView: IQTextView = {
        let t = IQTextView(frame: .zero)
        let att = NSMutableAttributedString(string: "问题描述越详细，能越快得到更准确的解答！如有bug请先尝试重启APP或更新至最新版本~")
        att.yy_font = .init(style: .regular, size: 14.uiX)
        att.yy_color = .init(hex: "#666666")
        t.attributedPlaceholder = att
        t.backgroundColor = .clear
        t.textColor = .white
        t.font = .init(style: .regular, size: 15.uiX)
        return t
    }()
    lazy var numberLbl: UILabel = {
        let l = UILabel()
        l.text = "0/200"
        l.textColor = .init(hex: "#999999")
        l.font = .init(style: .regular, size: 12.uiX)
        return l
    }()
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: UIDevice.screenWidth/2.0, height: 40.uiX)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let c = UICollectionView(frame: .zero, collectionViewLayout: layout)
        c.backgroundColor = .red
        c.register(cellType: HelpInputCell.self)
        return c
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(textView)
        addSubview(numberLbl)
        addSubview(collectionView)
        
        textView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10.uiX)
            make.left.equalToSuperview().offset(15.uiX)
            make.right.equalToSuperview().offset(-15.uiX)
            make.height.equalTo(50.uiX)
        }
        
        numberLbl.snp.makeConstraints { make in
            make.top.equalTo(textView.snp.bottom).offset(5.uiX)
            make.right.equalToSuperview().offset(-15.uiX)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(numberLbl.snp.bottom).offset(8.uiX)
            make.left.equalToSuperview().offset(15.uiX)
            make.right.equalToSuperview().offset(-15.uiX)
            make.height.equalTo(80.uiX)
        }
        
        textView.rx.text.orEmpty.subscribe(onNext: {[weak self] text in
            guard let self = self else { return }
            if text.count >= 200 {
                self.textView.text = String(text.prefix(200))
            }
            self.numberLbl.text = "\(self.textView.text.count)/200"
        }).disposed(by: rx.disposeBag)
        
//        textView.rx.didEndEditing.subscribe(onNext: { [weak self] in
//            guard let self = self else { return }
//            self.textView.resignFirstResponder()
//        }).disposed(by: rx.disposeBag)
        
        
//        let viewModels = items.map({ i -> HelpInputCellViewModel in
//            let v = HelpInputCellViewModel()
//            v.name.accept(i.name)
//            v.id = i.id
//            return v
//        })
//        let array = Observable.just(viewModels)
//        array.bind(to: collectionView.rx.items(cellIdentifier: HelpInputCell.reuseIdentifier, cellType: HelpInputCell.self)) { (row, element, cell) in
//            cell.bind(to: element)
//        }.disposed(by: rx.disposeBag)
//        collectionView.rx.itemSelected.subscribe(onNext: {[weak self] indexPath in
//            guard let self = self else { return }
//            viewModels.filter { $0.selected.value }.forEach { $0.selected.accept(false) }
//            let current = viewModels[indexPath.row]
//            current.selected.accept(true)
//            self.selectedId = current.id
//        }).disposed(by: rx.disposeBag)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
