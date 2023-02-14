//
//  LoginViewModel.swift
//  WallPaper
//
//  Created by LiQi on 2020/4/16.
//  Copyright © 2020 Qire. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class PhoneViewModel: ViewModel, ViewModelType {
    
    struct CodeEnale {
        let time: Int
        let enable: Bool
    }
    
    struct Input {
        let phone: Driver<String>
        let code: Driver<String>
        let codeTap: ControlEvent<Void>
        let loginTap: ControlEvent<Void>
    }
    
    struct Output {
        let phone: Driver<String>
        let code: Driver<String>
        let signupEnabled: Driver<Bool>
        let codeEnabled: Driver<CodeEnale>
        let login: PublishRelay<Bool>
    }
    
    private var countDownTime = 60
    private var service: PhoneService
    var oldCode: String?
    
    required init(service: PhoneService) {
        self.service = service
    }
    
    func transform(input: Input) -> Output {
        
        let phone: Driver<String> = input.phone.map { text in
            return text
        }
        
        let code: Driver<String> = input.code.map { text in
            if text.count >= 4 {
                return String(text.prefix(4))
            }
            return text
        }
        
        var mobile = ""
        var codeStr = ""
        phone.drive(onNext: { text in
            mobile = text.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
        }).disposed(by: rx.disposeBag)
        code.drive(onNext: { text in
            codeStr = text
        }).disposed(by: rx.disposeBag)
        
        let validPhone: Driver<Bool> = phone.map { text in
            let trim = text.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
            return trim.count == 11 && trim.isValidPhone
        }
        
        let validCode: Driver<Bool> = code.map { text in
            text.count == 4
        }

        let signupEnabled: Driver<Bool> = Driver.combineLatest(validPhone, validCode) { a, b in
            return a && b
        }.distinctUntilChanged()
        
        let codeEnable = BehaviorRelay<CodeEnale>(value: .init(time: 0, enable: true))
        
        let getCode = input.codeTap.flatMapLatest { [weak self] _ ->Observable<Void> in
            guard let self = self else { return  Observable<Void>.empty() }
            return self.getCheckCode(with: mobile)
        }
        
        getCode.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            let timer = Observable<Int>.timer(RxTimeInterval.seconds(0), period: RxTimeInterval.seconds(1), scheduler: MainScheduler.instance).map { self.countDownTime - $0 }.catchErrorJustReturn(0)
            
            timer.takeWhile { $0 > 0}.subscribe(onNext: { time in
                codeEnable.accept(.init(time: time, enable: false))
            }, onCompleted: {
                codeEnable.accept(.init(time: 0, enable: true))
            }).disposed(by: self.rx.disposeBag)
        }).disposed(by: rx.disposeBag)
        
        let validCodeEnable = Observable<CodeEnale>.combineLatest(validPhone.asObservable(), codeEnable.asObservable()) { a, b in
            if a, b.enable {
                return b
            }
            return CodeEnale(time: b.time, enable: false)
        }
        
        let login = PublishRelay<Bool>()
        input.loginTap.bind(onNext: { [weak self] in
            guard let self = self else { return }
            self.getLogin(mobile: mobile, code: codeStr).subscribe(onNext: { _ in
                login.accept(true)
            }, onError: { error in
                login.accept(false)
            }).disposed(by: self.rx.disposeBag)
        }).disposed(by: rx.disposeBag)
        
        return Output(phone: phone,
                      code: code,
                      signupEnabled: signupEnabled,
                      codeEnabled: validCodeEnable.asDriver(onErrorJustReturn: .init(time: 0, enable: false)),
                      login: login)
    }
    
    // MARK: - Service
    
    private func getCheckCode(with mobile: String) -> Observable<Void> {
        return self.service.requestCheckCode(with: mobile).trackActivity(loading).trackError(error).catchErrorJustComplete()
    }
    
    private func getLogin(mobile: String, code: String) -> Observable<Void> {
        return self.service.requestCheckPhone(mobile: mobile, code: code, oldCode: oldCode).asObservable().trackError(error)
    }
    
    
}
