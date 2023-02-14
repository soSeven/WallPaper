//
//  UserInfoAreaSheetView.swift
//  WallPaper
//
//  Created by LiQi on 2020/5/12.
//  Copyright © 2020 Qire. All rights reserved.
//

import UIKit
import SwiftEntryKit
import RxSwift
import RxCocoa
import MBProgressHUD
import SwiftyJSON
import FileKit

class UserInfoAreaModel: Mapable {
    
    let name: String
    let child: [UserInfoAreaCityModel]
    
    required init(json: JSON) {
        name = json["name"].stringValue
        child = json["child"].arrayValue.map{UserInfoAreaCityModel(json: $0)}
    }
}

class UserInfoAreaCityModel: Mapable {
    
    let name: String
    let child: [String]
    
    required init(json: JSON) {
        name = json["name"].stringValue
        child = json["child"].arrayValue.map{$0.stringValue}
    }
}

class UserInfoAreaSheetView: UIView {
    
    private var provinceIndex = 0
    private var cityIndex = 0
    private var districtIndex = 0
    
    let areaRelay = PublishRelay<String>()
    
    private var dataArray = [UserInfoAreaModel]()
    
    private lazy var pickerView: UIPickerView = {
        let p = UIPickerView()
        return p
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupData()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Data
    
    private func setupData() {
        let jsonPath = Path(Bundle.main.path(forResource: "area_list", ofType: ".json") ?? "")
        let jsonStr = try? String(contentsOfPath: jsonPath)
        let json = JSON(parseJSON: jsonStr ?? "")
        dataArray = json.arrayValue.map{UserInfoAreaModel(json: $0)}
    }
    
    // MARK: - UI
    
    private func setupUI() {
        let toolBar = getToolBar()
        
        let line = UIView()
        line.backgroundColor = .init(hex: "#eeeeee")
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        addSubview(toolBar)
        addSubview(line)
        addSubview(pickerView)
        
        toolBar.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(45.uiX)
        }
        
        line.snp.makeConstraints { make in
            make.top.equalTo(toolBar.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
        pickerView.snp.makeConstraints { make in
            make.top.equalTo(line.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().priority(.high)
        }
    }
    
    private func getToolBar() -> UIView {
        let v = UIView()
        
        let cancel = getBtn(title: "取消")
        cancel.tag = 0
        let decide = getBtn(title: "确定")
        decide.tag = 1
        
        v.addSubview(cancel)
        v.addSubview(decide)
        
        cancel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15.uiX)
            make.centerY.equalToSuperview()
        }
        
        decide.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-15.uiX)
            make.centerY.equalToSuperview()
        }
        
        return v
    }
    
    private func getBtn(title: String) -> UIButton {
        let btn = Button()
        btn.setTitleColor(.init(hex: "#111111"), for: .normal)
        btn.titleLabel?.font = .init(style: .regular, size: 17.uiX)
        btn.setTitle(title, for: .normal)
        btn.addTarget(self, action: #selector(onClickBtn(btn:)), for: .touchUpInside)
        return btn
    }
    
    @objc
    private func onClickBtn(btn: UIButton) {
        SwiftEntryKit.dismiss()
        if btn.tag != 0 {
            let p = dataArray[provinceIndex]
            let c = p.child[cityIndex]
            var district = ""
            if districtIndex < c.child.count {
                district = c.child[districtIndex]
            }
            let area = "\(p.name)\(c.name)\(district)"
            areaRelay.accept(area)
        }
    }
    
    // MARK: - Show
    
    func show() {
        
        var attributes = EKAttributes.bottomToast
        
        attributes.screenBackground = .color(color: .init(.init(white: 0, alpha: 0.6)))
        attributes.entryBackground = .color(color: .init(.init(hex: "#F7F7F7")))
        attributes.screenInteraction = .dismiss
        attributes.entryInteraction = .absorbTouches
        attributes.displayDuration = .infinity
        
        attributes.entranceAnimation = .translation
        attributes.exitAnimation = .translation
        
        SwiftEntryKit.display(entry: self, using: attributes)
    }
}

extension UserInfoAreaSheetView: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return dataArray.count
        case 1:
            let p = dataArray[provinceIndex]
            return p.child.count
        default:
            let p = dataArray[provinceIndex]
            let c = p.child[cityIndex]
            return c.child.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var text = ""
        switch component {
        case 0:
            let m = dataArray[row]
            text = m.name
        case 1:
            let p = dataArray[provinceIndex]
            let c = p.child[row]
            text = c.name
        default:
            let p = dataArray[provinceIndex]
            let c = p.child[cityIndex]
            text = c.child[row]
        }
        
        if let lbl = view as? UILabel {
            lbl.text = text
            return lbl
        } else {
            let lbl = UILabel()
            lbl.font = .init(style: .regular, size: 17.uiX)
            lbl.textColor = .init(hex: "#111111")
            lbl.textAlignment = .center
            lbl.text = text
            return lbl
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 35.uiX
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            provinceIndex = row
            cityIndex = 0
            districtIndex = 0
            
            pickerView.reloadComponent(1)
            pickerView.reloadComponent(2)
        case 1:
            cityIndex = row
            districtIndex = 0
            
            pickerView.reloadComponent(2)
            
        default:
            districtIndex = row
        }
        
        pickerView.selectRow(provinceIndex, inComponent: 0, animated: true)
        pickerView.selectRow(cityIndex, inComponent: 1, animated: true)
        pickerView.selectRow(districtIndex, inComponent: 2, animated: true)
        
    }
    
}
