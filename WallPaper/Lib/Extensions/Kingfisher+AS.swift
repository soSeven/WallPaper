//
//  Kingfisher+AS.swift
//  WallPaper
//
//  Created by LiQi on 2020/4/20.
//  Copyright © 2020 Qire. All rights reserved.
//

import Foundation
import Kingfisher
import AsyncDisplayKit

extension ASNetworkImageNode {
    static func imageNode() -> ASNetworkImageNode {
        return ASNetworkImageNode(cache: ASImageManager.shared, downloader: ASImageManager.shared)
    }
}

extension ASVideoNode {
    static func videoNode() -> ASVideoNode {
        return ASVideoNode(cache: ASImageManager.shared, downloader: ASImageManager.shared)
    }
}

class ASImageManager: NSObject, ASImageDownloaderProtocol, ASImageCacheProtocol {

    static let shared = ASImageManager()
    private override init() {}

    func downloadImage(with url: URL, callbackQueue: DispatchQueue, downloadProgress: ASImageDownloaderProgress?, completion: @escaping ASImageDownloaderCompletion) -> Any? {

        ImageDownloader.default.downloadTimeout = 30.0
        var operation: DownloadTask?
        operation = ImageDownloader.default.downloadImage(with: url, options: nil, progressBlock: { (received, expected) in
            if downloadProgress != nil {
                callbackQueue.async(execute: {
                    let progress = expected == 0 ? 0 : received / expected
                    downloadProgress?(CGFloat(progress))
                })
            }
        }, completionHandler: { result in
            switch result {
            case .success(let imgResult):
                callbackQueue.async(execute: { completion(imgResult.image, nil, nil, nil) })
                ImageCache.default.store(imgResult.image, original: imgResult.originalData, forKey: url.cacheKey, toDisk: true)
            case .failure(let error):
                callbackQueue.async(execute: { completion(nil, error, operation, nil) })
            }
        })
        return operation
    }

    func cancelImageDownload(forIdentifier downloadIdentifier: Any) {
        if let task = downloadIdentifier as? DownloadTask {
            task.cancel()
        }
    }

    func cachedImage(with url: URL, callbackQueue: DispatchQueue, completion: @escaping ASImageCacherCompletion) {
        ImageCache.default.retrieveImage(forKey: url.cacheKey) { result in
            switch result {
            case .success(let imgResult):
                callbackQueue.async { completion(imgResult.image, .synchronous) }
            case .failure:
                break
            }
        }
//        ImageCache.default.retrieveImage(forKey: url.cacheKey, options: nil) { (img, _) in
//            callbackQueue.async { completion(img) }
//        }
    }
}
