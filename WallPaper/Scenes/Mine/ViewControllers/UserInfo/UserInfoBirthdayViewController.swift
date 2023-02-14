//
//  UserInfoBirthdayViewController.swift
//  WallPaper
//
//  Created by LiQi on 2020/5/12.
//  Copyright © 2020 Qire. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class UserInfoBirthdayViewController: ViewController {
    
    var viewModel: UserInfoBirthdayViewModel!
    
    private var saveBtn = Button()
    
    private lazy var textLbl: UILabel = {
        let t = UILabel()
        t.textColor = .init(hex: "#999999")
        t.font = .init(style: .regular, size: 15.uiX)
        return t
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "修改星座"
        setupUI()
        setupBinding()
    }
    
    // MARK: - Binding
    
    private func setupBinding() {
        let save = saveBtn.rx.tap.flatMap {[weak self] _  -> Observable<String> in
            guard let self = self else { return Observable.empty() }
            guard let text = self.textLbl.text, !text.isEmpty else { return Observable.empty() }
            return Observable.of(text)
        }
        let input = UserInfoBirthdayViewModel.Input(save: save)
        let output = viewModel.transform(input: input)
        
        viewModel.loading.asObservable().bind(to: view.rx.mbHudLoaingForce).disposed(by: rx.disposeBag)
        let completion = {[weak self] in
            guard let self = self else { return }
            self.navigationController?.popViewController()
        }
        output.showSuccess.bind(to: view.rx.mbHudText(completion: completion)).disposed(by: rx.disposeBag)
        output.showSuccess.bind {[weak self] _ in
            guard let self = self else { return }
            guard let text = self.textLbl.text, !text.isEmpty else { return }
            guard let user = UserManager.shared.login.value else { return }
            user.constellation = text
            UserManager.shared.login.accept(user)
        }.disposed(by: rx.disposeBag)
        viewModel.parsedError.asObserver().bind(to: view.rx.toastError).disposed(by: rx.disposeBag)
        
    }
    
    // MARK: - UI
    
    private func setupUI() {
        let att: [NSAttributedString.Key: Any] = [
            .font : UIFont(style: .regular, size: 16.uiX),
            .foregroundColor: UIColor(hex: "#FF2071")
        ]
        saveBtn.setAttributedTitle(.init(string: "保存", attributes: att), for: .normal)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: saveBtn)
        
        let bgView = UIView()
        bgView.backgroundColor = .init(hex: "#242630")
        view.addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(55.uiX)
        }
        
        let starLbl = UILabel()
        starLbl.text = "星座"
        starLbl.textColor = .init(hex: "#ffffff")
        starLbl.font = .init(style: .regular, size: 15.uiX)
        
        bgView.addSubview(starLbl)
        bgView.addSubview(textLbl)
        
        starLbl.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15.uiX)
            make.centerY.equalToSuperview()
        }
        
        textLbl.snp.makeConstraints { make in
            make.left.equalTo(starLbl.snp.right).offset(22.uiX)
            make.centerY.equalToSuperview()
        }
        
        let lbl = UILabel()
        lbl.text = "选择出生日期，系统将自动转换为星座"
        lbl.textColor = .init(hex: "#999999")
        lbl.font = .init(style: .regular, size: 13.uiX)
        view.addSubview(lbl)
        lbl.snp.makeConstraints { make in
            make.top.equalTo(bgView.snp.bottom).offset(13.uiX)
            make.left.equalToSuperview().offset(15.uiX)
        }
        
        let datePicker = UIDatePicker()
        datePicker.backgroundColor = .white
        datePicker.locale = Locale(identifier: "zh")
        datePicker.datePickerMode = .date
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        datePicker.setDate(Date(), animated: true)
        datePicker.maximumDate = Date()
        datePicker.addTarget(self, action: #selector(onDateChange(picker:)), for: .valueChanged)
        view.addSubview(datePicker)
        
        
        datePicker.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
        }
        
        let dateLbl = UILabel()
        dateLbl.text = "你的生日信息不会在个人资料中展示"
        dateLbl.textColor = .init(hex: "#999999")
        dateLbl.font = .init(style: .regular, size: 13.uiX)
        view.addSubview(dateLbl)
        dateLbl.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15.uiX)
            make.bottom.equalTo(datePicker.snp.top).offset(-15.uiX);
        }
        
        if let starText = UserManager.shared.login.value?.constellation {
            textLbl.text = starText
        } else {
            onDateChange(picker: datePicker)
        }
        
    }
    
    // MARK: - Event
    
    @objc
    private func onDateChange(picker: UIDatePicker) {
        
        let components = picker.calendar.dateComponents([.month, .day], from: picker.date)
        let m = components.month ?? 0
        let d = components.day ?? 0
        textLbl.text = getStarStr(month: m, day: d)
    }
    
    func getStarStr(month: Int, day: Int) -> String {
        
        // 月以100倍之月作为一个数字计算出来
        let mmdd = month * 100 + day;
        var result = ""
        
        if ((mmdd >= 321 && mmdd <= 331) ||
            (mmdd >= 401 && mmdd <= 419)) {
            result = "白羊座"
        } else if ((mmdd >= 420 && mmdd <= 430) ||
            (mmdd >= 501 && mmdd <= 520)) {
            result = "金牛座"
        } else if ((mmdd >= 521 && mmdd <= 531) ||
            (mmdd >= 601 && mmdd <= 621)) {
            result = "双子座"
        } else if ((mmdd >= 622 && mmdd <= 630) ||
            (mmdd >= 701 && mmdd <= 722)) {
            result = "巨蟹座"
        } else if ((mmdd >= 723 && mmdd <= 731) ||
            (mmdd >= 801 && mmdd <= 822)) {
            result = "狮子座"
        } else if ((mmdd >= 823 && mmdd <= 831) ||
            (mmdd >= 901 && mmdd <= 922)) {
            result = "处女座"
        } else if ((mmdd >= 923 && mmdd <= 930) ||
            (mmdd >= 1001 && mmdd <= 1023)) {
            result = "天秤座"
        } else if ((mmdd >= 1024 && mmdd <= 1031) ||
            (mmdd >= 1101 && mmdd <= 1122)) {
            result = "天蝎座"
        } else if ((mmdd >= 1123 && mmdd <= 1130) ||
            (mmdd >= 1201 && mmdd <= 1221)) {
            result = "射手座"
        } else if ((mmdd >= 1222 && mmdd <= 1231) ||
            (mmdd >= 101 && mmdd <= 119)) {
            result = "摩羯座"
        } else if ((mmdd >= 120 && mmdd <= 131) ||
            (mmdd >= 201 && mmdd <= 218)) {
            result = "水瓶座"
        } else if ((mmdd >= 219 && mmdd <= 229) ||
            (mmdd >= 301 && mmdd <= 320)) {
            //考虑到2月闰年有29天的
            result = "双鱼座"
        } else{
            print(mmdd)
            result = "日期错误"
        }
        return result
    }
}

