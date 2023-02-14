//
//  UserInfoNickViewController.swift
//  WallPaper
//
//  Created by LiQi on 2020/5/12.
//  Copyright © 2020 Qire. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class UserInfoNickViewController: ViewController {
    
    var viewModel: UserInfoNickViewModel!
    
    private var saveBtn = Button()
    
    private lazy var textField: UITextField = {
        let t = UITextField()
        t.textColor = .white
        t.returnKeyType = .done
        t.font = .init(style: .regular, size: 15.uiX)
        let att: [NSAttributedString.Key: Any] = [
            .font : UIFont(style: .regular, size: 15.uiX),
            .foregroundColor: UIColor(hex: "#666666")
        ]
        t.attributedPlaceholder = NSAttributedString(string: "请输入昵称...", attributes: att)
        return t
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "修改昵称"
        setupUI()
        setupBinding()
    }
    
    override func onceWhenViewDidAppear(_ animated: Bool) {
        textField.becomeFirstResponder()
    }
    
    // MARK: - Binding
    
    private func setupBinding() {
        
        textField.rx.text.orEmpty.bind {[weak self] text in
            guard let self = self else { return }
            let match = "(^[\u{4e00}-\u{9fa5}]+$)"
            let pre = NSPredicate(format: "SELF matches %@", match)
            if pre.evaluate(with: text) {
                if text.count >= 8 {
                    self.textField.text = String(text.prefix(8))
                }
            } else {
                if text.count >= 16 {
                    self.textField.text = String(text.prefix(16))
                }
            }
        }.disposed(by: rx.disposeBag)
        
        let save = saveBtn.rx.tap.flatMap {[weak self] _  -> Observable<String> in
            guard let self = self else { return Observable.empty() }
            guard let text = self.textField.text, !text.isEmpty else { return Observable.empty() }
            let match = "(^[\u{4e00}-\u{9fa5}]+$)"
            let pre = NSPredicate(format: "SELF matches %@", match)
            if pre.evaluate(with: text) {
                if text.count < 2 {
                    return Observable.empty()
                }
            } else {
                if text.count < 4 {
                    return Observable.empty()
                }
            }
            return Observable.of(text)
        }
        let input = UserInfoNickViewModel.Input(save: save)
        let output = viewModel.transform(input: input)
        
        viewModel.loading.asObservable().bind(to: view.rx.mbHudLoaingForce).disposed(by: rx.disposeBag)
        let completion = {[weak self] in
            guard let self = self else { return }
            self.navigationController?.popViewController()
        }
        output.showSuccess.bind(to: view.rx.mbHudText(completion: completion)).disposed(by: rx.disposeBag)
        output.showSuccess.bind {[weak self] _ in
            guard let self = self else { return }
            guard let text = self.textField.text, !text.isEmpty else { return }
            guard let user = UserManager.shared.login.value else { return }
            user.nickname = text
            UserManager.shared.login.accept(user)
            self.textField.resignFirstResponder()
        }.disposed(by: rx.disposeBag)
        viewModel.parsedError.asObserver().bind(to: view.rx.toastError).disposed(by: rx.disposeBag)
        
    }
    
    // MARK: UI
    
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
        
        textField.text = UserManager.shared.login.value?.nickname
        textField.autocorrectionType = .no
        bgView.addSubview(textField)
        textField.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 15.uiX, bottom: 0, right: 15.uiX))
        }
        
        let lbl = UILabel()
        lbl.text = "2~8个汉字或4~16个英文字母"
        lbl.textColor = .init(hex: "#999999")
        lbl.font = .init(style: .regular, size: 13.uiX)
        view.addSubview(lbl)
        lbl.snp.makeConstraints { make in
            make.top.equalTo(bgView.snp.bottom).offset(13.uiX)
            make.left.equalToSuperview().offset(15.uiX)
        }
        
    }

}
