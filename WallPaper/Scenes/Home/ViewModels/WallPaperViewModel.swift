//
//  WallPaperViewModel.swift
//  WallPaper
//
//  Created by LiQi on 2020/4/18.
//  Copyright © 2020 Qire. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import Photos

class WallPaperViewModel: ViewModel, ViewModelType {
    
    enum DownloadType {
        case start
        case downloading
        case finish
        case error(String)
    }
    
    private let service: WallPaperService
    private let jsonDict: [[String:Any]]
    
    private let download = PublishSubject<WallPaperModel>()
    private let userHome = PublishSubject<WallPaperModel>()
    private let create = PublishSubject<WallPaperModel>()
    private let attention = PublishSubject<Bool>()
    private let share = PublishSubject<WallPaperModel>()
    private let zan = PublishSubject<WallPaperCellNodeViewModel>()
    private let login = PublishSubject<Void>()
    
    var defaultElements: (WallPaperModel?, [WallPaperModel]) = (nil, [])
    struct Input {
        let requestCurrent: Driver<Void>
        let requestNext: PublishRelay<WallPaperModel>
        let requestPrevious: PublishRelay<WallPaperModel>
    }
    
    struct Output {
        let currentItems: BehaviorRelay<(WallPaperCellNodeViewModel?, [WallPaperCellNodeViewModel])>
        let previousItems: BehaviorRelay<[WallPaperCellNodeViewModel]>
        let nextItems: BehaviorRelay<[WallPaperCellNodeViewModel]>
        let isShowLoading: BehaviorRelay<Bool>
        let isShowErrorView: BehaviorRelay<Bool>
        let downloadProgess: PublishSubject<(Float, DownloadType)>
        let share: PublishSubject<WallPaperModel>
        let login: PublishSubject<Void>
        let userHome: PublishSubject<WallPaperModel>
        let create: PublishSubject<WallPaperModel>
    }
    
    init(service: WallPaperService, jsonDict: [[String:Any]]) {
        self.service = service
        self.jsonDict = jsonDict
        super.init()
    }
    
    func transform(input: WallPaperViewModel.Input) -> WallPaperViewModel.Output {
        
        let previousElements = BehaviorRelay<[WallPaperCellNodeViewModel]>(value: [])
        let currentElements = BehaviorRelay<(WallPaperCellNodeViewModel?, [WallPaperCellNodeViewModel])>(value: (nil, []))
        let nextElements = BehaviorRelay<[WallPaperCellNodeViewModel]>(value: [])
        let isShowLoading = BehaviorRelay<Bool>(value: false)
        let isShowErrorView = BehaviorRelay<Bool>(value: false)
        
        input.requestCurrent.drive(onNext: { [weak self] _ in
            guard let self = self else { return }
            isShowLoading.accept(true)
            isShowErrorView.accept(false)
            self.requestCurrent().subscribe(onNext: { items in
//                guard let self = self else { return }
                if items.isEmpty {
                    return
                }
                let arr = [items.first!]
                currentElements.accept((items.first, arr))
                isShowLoading.accept(false)
            }, onError: { error in
                isShowLoading.accept(false)
                isShowErrorView.accept(true)
            }).disposed(by: self.rx.disposeBag)
        }).disposed(by: rx.disposeBag)
        
        var previousLoading = false
        input.requestPrevious.subscribe(onNext: {[weak self] model in
            guard let self = self else { return }
            if previousLoading {
                return
            }
            previousLoading = true
            self.requestPrevious(item: model).subscribe(onNext: { items in
                previousElements.accept(items)
                previousLoading = false
            }, onError: { error in
                previousLoading = false
            }).disposed(by: self.rx.disposeBag)
        }).disposed(by: rx.disposeBag)
        
        var nextLoading = false
        input.requestNext.subscribe(onNext: {[weak self] model in
            guard let self = self else { return }
            if nextLoading {
                return
            }
            nextLoading = true
            self.requestNext(item: model).subscribe(onNext: { items in
                nextElements.accept(items)
                nextLoading = false
            }, onError: { error in
                nextLoading = false
            }).disposed(by: self.rx.disposeBag)
        }).disposed(by: rx.disposeBag)
        
        let downloadProgess = PublishSubject<(Float, DownloadType)>()
        download.subscribe(onNext: {[weak self] model in
            guard let self = self else { return }
            downloadProgess.onNext((0, .start))
            self.downloadVideo(with: model, downloadProgess: downloadProgess)
        }).disposed(by: rx.disposeBag)
        
        return Output(currentItems: currentElements,
                      previousItems: previousElements,
                      nextItems: nextElements,
                      isShowLoading: isShowLoading,
                      isShowErrorView: isShowErrorView,
                      downloadProgess: downloadProgess,
                      share: share,
                      login: login,
                      userHome: userHome,
                      create: create)
    }
    
    // MARK: - Download
    
    private func downloadVideo(with model: WallPaperModel, downloadProgess: PublishSubject<(Float, DownloadType)>) {
        
        let existVideo = NetVideoCache.shared.exist(item: model.video)
        
        if existVideo {
            let videoURL = NetVideoCache.shared.createPath(item: model.video).url
//            print(videoURL)
            LivePhoto.generate(from: nil, videoURL: videoURL, progress: { progress in
                DispatchQueue.main.async {
                    downloadProgess.on(.next((Float(progress), .downloading)))
                }
            }) { livePhoto, resources in
                DispatchQueue.main.async {
                    if let resources = resources {
                        LivePhoto.saveToLibrary(resources, completion: { (success, msg) in
                            DispatchQueue.main.async {
                                if success {
                                    downloadProgess.on(.next((1, .finish)))
                                }
                                else {
                                    downloadProgess.on(.next((1, .error(msg ?? "保存失败"))))
                                }
                                LivePhoto.clearCache()
                            }
                        })
                    } else {
                        downloadProgess.on(.next((1, .error("解析失败"))))
                    }
                }
            }
            return
        }
        
        NetManager.download(.downloadVideo(url: model.video)).subscribe(onNext: { progress in
            downloadProgess.on(.next((Float(progress * 0.5), .downloading)))
        }, onError: { error in
            downloadProgess.on(.next((0.5, .error("下载失败"))))
        }, onCompleted: {
            let videoURL = NetVideoCache.shared.createPath(item: model.video).url
//            print(videoURL)
            LivePhoto.generate(from: nil, videoURL: videoURL, progress: { progress in
                DispatchQueue.main.async {
                    downloadProgess.on(.next((Float(progress * 0.5 + 0.5), .downloading)))
                }
            }) { livePhoto, resources in
                DispatchQueue.main.async {
                    if let resources = resources {
                        LivePhoto.saveToLibrary(resources, completion: { (success, msg) in
                            DispatchQueue.main.async {
                                if success {
                                    downloadProgess.on(.next((1, .finish)))
                                }
                                else {
                                    downloadProgess.on(.next((1, .error(msg ?? "保存失败"))))
                                }
                                LivePhoto.clearCache()
                            }
                        })
                    } else {
                        downloadProgess.on(.next((1, .error("解析失败"))))
                    }
                }
            }
        }).disposed(by: self.rx.disposeBag)
    }
    
    // MARK: - Request
    
    private func requestCurrent() -> Observable<[WallPaperCellNodeViewModel]> {
        
        self.service.requestCurrentWallPaper(jsonDict: jsonDict).mapMany({ model in
            return self.getViewModel(with: model)
        }).trackActivity(loading).trackError(error)
    }
    
    private func requestNext(item: WallPaperModel) -> Observable<[WallPaperCellNodeViewModel]> {
        self.service.requestNextWallPaper(item: item).mapMany({ model in
            return self.getViewModel(with: model)
        }).trackActivity(loading).trackError(error)
    }
    
    private func requestPrevious(item: WallPaperModel) -> Observable<[WallPaperCellNodeViewModel]> {
        self.service.requestPreviousWallPaper(item: item).mapMany({ model in
            return self.getViewModel(with: model)
        }).trackActivity(loading).trackError(error)
    }
    
    private func getViewModel(with model: WallPaperModel) -> WallPaperCellNodeViewModel {
        let viewModel = WallPaperCellNodeViewModel(model: model)
        viewModel.download.bind(to: download).disposed(by: rx.disposeBag)
        viewModel.share.bind(to: share).disposed(by: rx.disposeBag)
        viewModel.login.bind(to: login).disposed(by: rx.disposeBag)
        viewModel.userHome.bind(to: userHome).disposed(by: rx.disposeBag)
        viewModel.create.bind(to: create).disposed(by: rx.disposeBag)
        viewModel.parsedError.bind(to: parsedError).disposed(by: rx.disposeBag)
        return viewModel
    }
    
    private func requestZan(item: WallPaperModel) -> Observable<ZanModel?> {
        return NetManager.requestObj(.zan(id: item.id), type: ZanModel.self).asObservable().trackError(error)
    }
}
