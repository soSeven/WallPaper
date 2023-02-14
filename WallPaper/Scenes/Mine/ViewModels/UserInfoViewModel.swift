//
//  UserInfoViewModel.swift
//  WallPaper
//
//  Created by LiQi on 2020/5/12.
//  Copyright © 2020 Qire. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class UserInfoViewModel: ViewModel, ViewModelType {
    
    struct Input {
        let saveSex: Observable<UserInfoSexType>
        let saveArea: Observable<String>
        let saveImage: Observable<UIImage>
    }
    
    struct Output {
        let showSuccess: PublishRelay<String>
//        let sexSuccess: PublishRelay<Int>
//        let areaSuccess: PublishRelay<String>
    }
    
    func transform(input: Input) -> Output {
        
        let showSuccess = PublishRelay<String>()
        
        input.saveSex.subscribe(onNext: { [weak self] type in
            guard let self = self else { return }
            let value = type.rawValue
            self.requestSave(type:.sex, value: "\(value)").subscribe(onNext: { _ in
                showSuccess.accept("修改成功")
                guard let user = UserManager.shared.login.value else { return }
                user.sex = value
                UserManager.shared.login.accept(user)
            }).disposed(by: self.rx.disposeBag)
        }).disposed(by: rx.disposeBag)
        
        input.saveArea.subscribe(onNext: { [weak self] value in
            guard let self = self else { return }
            self.requestSave(type:.area, value: value).subscribe(onNext: { _ in
                showSuccess.accept("修改成功")
                guard let user = UserManager.shared.login.value else { return }
                user.area = value
                UserManager.shared.login.accept(user)
            }).disposed(by: self.rx.disposeBag)
        }).disposed(by: rx.disposeBag)
        
        input.saveImage.subscribe(onNext: {[weak self] image in
            guard let self = self else { return }
            self.requestUpload(image: image).subscribe(onNext: { value in
                showSuccess.accept("修改成功")
                guard let user = UserManager.shared.login.value else { return }
                user.avatar = value
                UserManager.shared.login.accept(user)
            }, onError: { error in

            }).disposed(by: self.rx.disposeBag)
        }).disposed(by: rx.disposeBag)
        
        return Output(showSuccess: showSuccess)
    }
    
    /// MARK: - Request
    
    func requestSave(type: UserInfoChangeType, value: String) -> Observable<Void> {
        
        return NetManager.requestResponse(.changeUserInfo(type: type, value: value)).asObservable().trackError(error).trackActivity(loading)
    }
    
    func requestUpload(image: UIImage) -> Observable<String> {

        return NetManager.requestResponseObj(.upImage(image: image, dirName: "avatar")).flatMap { rep  -> Single<String> in
            let url = rep.data?.stringValue ?? ""
            return NetManager.requestResponse(.changeUserInfo(type: .avatar, value: url)).flatMap { _ in
                return Single.just(url)
            }
        }.asObservable().trackError(error).trackActivity(loading)

    }
    
}
