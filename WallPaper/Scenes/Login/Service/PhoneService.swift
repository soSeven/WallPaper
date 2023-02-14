//
//  PhoneService.swift
//  WallPaper
//
//  Created by LiQi on 2020/5/13.
//  Copyright © 2020 Qire. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol PhoneService {
    
    func requestCheckCode(with mobile: String) -> Observable<Void>
    
    func requestCheckPhone(mobile: String, code: String, oldCode: String?) -> Observable<Void>
    
}

class LoginPhoneService: PhoneService {
    
    func requestCheckCode(with mobile: String) -> Observable<Void> {
        return NetManager.requestResponse(.getCheckCode(mobile: mobile, event: .regLogin)).asObservable()
    }
    
    func requestCheckPhone(mobile: String, code: String, oldCode: String?) -> Observable<Void> {
        return UserManager.shared.login(with: .phone(mobile: mobile, code: code)).asObservable()
    }
    
}

class CheckPhoneService: PhoneService {
    
    func requestCheckCode(with mobile: String) -> Observable<Void> {
        return NetManager.requestResponse(.getCheckCode(mobile: mobile, event: .check)).asObservable()
    }
    
    func requestCheckPhone(mobile: String, code: String, oldCode: String?) -> Observable<Void> {
        return Single.just(()).asObservable()
    }
    
}

class ChangePhoneService: PhoneService {
    
    func requestCheckCode(with mobile: String) -> Observable<Void> {
        return NetManager.requestResponse(.getCheckCode(mobile: mobile, event: .regLogin)).asObservable()
    }
    
    func requestCheckPhone(mobile: String, code: String, oldCode: String?) -> Observable<Void> {
        return NetManager.requestResponse(.changePhone(mobile: mobile, code: code, oldCode: oldCode ?? "")).asObservable()
    }
    
}

class BindPhoneService: PhoneService {
    
    func requestCheckCode(with mobile: String) -> Observable<Void> {
        return NetManager.requestResponse(.getCheckCode(mobile: mobile, event: .bind)).asObservable()
    }
    
    func requestCheckPhone(mobile: String, code: String, oldCode: String?) -> Observable<Void> {
        return NetManager.requestResponse(.bindPhone(mobile: mobile, code: code)).asObservable()
    }
    
}
