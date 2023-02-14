//
//  ShareViewModel.swift
//  WallPaper
//
//  Created by LiQi on 2020/5/9.
//  Copyright © 2020 Qire. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class ShareViewModel: ViewModel, ViewModelType {
    
    let viewController: UIViewController
    let id: Int
    
    struct Input {
        let share: Observable<ShareType>
    }
    
    struct Output {
        let hud: PublishRelay<String?>
    }
    
    init(id: Int, viewController: UIViewController) {
        self.id = id
        self.viewController = viewController
    }
    
    func transform(input: Input) -> Output {
        
        let hud = PublishRelay<String?>()
        
        input.share.subscribe(onNext: {[weak self] type in
            guard let self = self else { return }
            hud.accept(nil)
            self.requestShare(type: type, viewController: self.viewController).subscribe(onNext: { success in
                hud.accept(success)
            }, onError: { error in
                if let e = error as? NetError {
                    switch e {
                    case let .error(code: _, msg: msg):
                        hud.accept(msg)
                    }
                }
                hud.accept("分享失败")
            }).disposed(by: self.rx.disposeBag)
            
        }).disposed(by: rx.disposeBag)
        
        return Output(hud: hud)
    }
    
    /// MARK: - Request
    
    func requestShare(type: ShareType, viewController: UIViewController) -> Observable<String> {
        
        return NetManager.requestObj(.share(id: id), type: ShareModel.self).asObservable().flatMapLatest { model in
            return Observable<ShareModel>.create { obser in
                guard let m = model else {
                    obser.onError(NetError.error(code: -1000, msg: "数据错误"))
                    return Disposables.create()
                }
                guard let url = URL(string: m.img) else {
                    obser.onError(NetError.error(code: -1000, msg: "分享地址错误"))
                    return Disposables.create()
                }
                DispatchQueue.global().async {
                    let imgData = try? Data(contentsOf: url)
                    if let data = imgData, let img = UIImage(data: data) {
                        m.requestImg = img
                        DispatchQueue.main.async {
                            obser.onNext(m)
                            obser.onCompleted()
                        }
                    } else {
                        DispatchQueue.main.async {
                            obser.onError(NetError.error(code: -1000, msg: "分享图片错误"))
                        }
                    }
                }
                return Disposables.create()
            }
        }.flatMapLatest { m in
            
            return Observable<String>.create { obser in
                let messageObj = UMSocialMessageObject()
                let web = UMShareWebpageObject.shareObject(withTitle: m.title, descr: m.description, thumImage: m.requestImg!)
                web?.webpageUrl = m.url;
                messageObj.shareObject = web
                UMSocialManager.default()?.share(to: self.getShareType(type: type), messageObject: messageObj, currentViewController: self.viewController, completion: { result, error in
                    if let _ = error {
                        obser.onError(NetError.error(code: -1000, msg: "分享图片错误"))
                    } else {
                        obser.onNext("分享成功")
                        obser.onCompleted()
                    }
                })
                return Disposables.create()
            }
            
            }.timeout(RxTimeInterval.seconds(15), scheduler: MainScheduler.instance)
    }
                
    private func getShareType(type: ShareType) -> UMSocialPlatformType {
        switch type {
        case .wxFriend:
            return .wechatSession
        case .wxZone:
            return .wechatTimeLine
        case .qqZone:
            return .QQ
        case .qqFriend:
            return .qzone
        default:
            return .wechatSession
        }
    }
}
