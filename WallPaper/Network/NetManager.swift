//
//  NetManager.swift
//  WallPaper
//
//  Created by LiQi on 2020/4/10.
//  Copyright © 2020 Qire. All rights reserved.
//

import Foundation
import Moya
import RxSwift
import RxCocoa
import SwiftyJSON
import FileKit

enum NetError: Error {
    case error(code: Int, msg: String)
}

struct Response {
    var code = 0
    var data: JSON?
    var msg = ""
}

class NetManager {
    
    static let NotJsonCode = 999999
    
    class func requestResponseObj(_ target: NetAPI) -> Single<Response> {
        
        return Single.create { single in
            let cancellableToken = NetProvider.request(target) { result in
                switch result {
                case let .success(response):
                    let dataOptional = try? response.mapJSON()
                    guard let data = dataOptional else {
                        single(.error(NetError.error(code: self.NotJsonCode, msg: "解析错误")))
                        return
                    }
                    let json = JSON(data)
                    let ybResponse = Response(code: json["code"].intValue, data: json["data"], msg: json["msg"].stringValue)
                    switch ybResponse.code {
                    case 1:
                        single(.success(ybResponse))
                    default:
                        single(.error(NetError.error(code: ybResponse.code, msg: ybResponse.msg)))
                    }
                case let .failure(error):
                    single(.error(NetError.error(code: error.errorCode, msg: error.localizedDescription)))
                }
            }
            return Disposables.create {
                cancellableToken.cancel()
            }
        }
    }
    
    class func requestResponse(_ target: NetAPI) -> Single<Void> {
        
        return Single.create { single in
            let cancellableToken = NetProvider.request(target) { result in
                switch result {
                case let .success(response):
                    let dataOptional = try? response.mapJSON()
                    guard let data = dataOptional else {
                        single(.error(NetError.error(code: self.NotJsonCode, msg: "解析错误")))
                        return
                    }
                    let json = JSON(data)
                    let ybResponse = Response(code: json["code"].intValue, data: json["data"], msg: json["msg"].stringValue)
                    switch ybResponse.code {
                    case 1:
                        single(.success(()))
                    default:
                        single(.error(NetError.error(code: ybResponse.code, msg: ybResponse.msg)))
                    }
                case let .failure(error):
                    single(.error(NetError.error(code: error.errorCode, msg: error.localizedDescription)))
                }
            }
            return Disposables.create {
                cancellableToken.cancel()
            }
        }
    }
    
    class func requestObj<T: Mapable>(_ target: NetAPI, type: T.Type) -> Single<T?> {
        return Single.create { single in
            let cancellableToken = NetProvider.request(target) { result in
                switch result {
                case let .success(response):
                    let dataOptional = try? response.mapJSON()
                    guard let data = dataOptional else {
                        single(.error(NetError.error(code: self.NotJsonCode, msg: "解析错误")))
                        return
                    }
                    let json = JSON(data)
                    let ybResponse = Response(code: json["code"].intValue, data: json["data"], msg: json["msg"].stringValue)
                    switch ybResponse.code {
                    case 1:
                        guard let responseData = ybResponse.data else {
                            single(.success(nil))
                            return
                        }
                        let obj = T(json: responseData)
                        single(.success(obj))
                    default:
                        single(.error(NetError.error(code: ybResponse.code, msg: ybResponse.msg)))
                    }
                case let .failure(error):
                    single(.error(NetError.error(code: error.errorCode, msg: error.localizedDescription)))
                }
            }
            return Disposables.create {
                cancellableToken.cancel()
            }
        }
    }
    
    class func requestObjArray<T: Mapable>(_ target: NetAPI, type: T.Type) -> Single<[T]> {
        return Single.create { single in
            let cancellableToken = NetProvider.request(target) { result in
                switch result {
                case let .success(response):
                    let dataOptional = try? response.mapJSON()
                    guard let data = dataOptional else {
                        single(.error(NetError.error(code: NotJsonCode, msg: "解析错误")))
                        return
                    }
                    let json = JSON(data)
                    let ybResponse = Response(code: json["code"].intValue, data: json["data"], msg: json["msg"].stringValue)
                    switch ybResponse.code {
                    case 1:
                        guard let responseData = ybResponse.data else {
                            single(.success([]))
                            return
                        }
                        let objArray = responseData.arrayValue.compactMap { T(json: $0) }
                        single(.success(objArray))
                    default:
                        single(.error(NetError.error(code: ybResponse.code, msg: ybResponse.msg)))
                    }
                case let .failure(error):
                    single(.error(NetError.error(code: error.errorCode, msg: error.localizedDescription)))
                }
            }
            return Disposables.create {
                cancellableToken.cancel()
            }
        }
    }
    
    // MARK: - Download
    
    class func download(_ target: NetAPI) -> Observable<Double> {
        
        return Observable<Double>.create { observer in
            let cancellableToken = NetProvider.request(target, callbackQueue: .main, progress: { progressResponse in
                observer.onNext(progressResponse.progress)
            }) { result in
                switch result {
                case .success:
                    observer.onCompleted()
                case let .failure(error):
                    observer.onError(NetError.error(code: error.errorCode, msg: error.localizedDescription))
                }
            }
            return Disposables.create {
                cancellableToken.cancel()
            }
        }
    }
}
