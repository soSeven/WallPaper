//
//  NetCache.swift
//  WallPaper
//
//  Created by LiQi on 2020/4/23.
//  Copyright © 2020 Qire. All rights reserved.
//

import Foundation
import FileKit
import Kingfisher
import CryptoSwift

protocol NetCacheType: AnyObject {
    
    associatedtype Item
    associatedtype Result
    
    func createPath(item: Item) -> Path
    
    func save(item: Item) -> Bool
    
    func exist(item: Item) -> Bool
    
    func get(item: Item) -> Result?
    
    func delete(item: Item) -> Bool
    
    func deleteAll() -> Bool
}

class NetVideoCache: NetCacheType {
    
    typealias Item = String
    typealias Result = Path
    
    static let shared = NetVideoCache()
    
    let path = Path.userCaches + "videoCache"
    
    init() {
        try? path.createDirectory()
    }
    
    func createPath(item: String) -> Path {
        return path + "\(item.md5()).mp4"
    }
    
    func save(item: String) -> Bool {
        return false
    }
    
    func exist(item: String) -> Bool {
        let path = createPath(item: item)
        return path.exists
        
    }
    
    func get(item: String) -> Path? {
        let path = createPath(item: item)
        if path.exists {
            return path
        }
        return nil
    }
    
    func delete(item: String) -> Bool {
        let path = createPath(item: item)
        do {
            try path.deleteFile()
            return true
        } catch {
            return false
        }
    }
    
    @discardableResult
    func deleteAll() -> Bool {
        do {
            try path.deleteFile()
            try path.createDirectory()
            return true
        } catch {
            return false
        }
    }

}

class NetLivePhotoCache: NetCacheType {
    
    typealias Item = String
    typealias Result = Path
    
    static let shared = NetLivePhotoCache()
    
    let path = Path.userCaches + "livePhoto"
    
    init() {
        try? path.createDirectory()
    }
    
    func createPath(item: String) -> Path {
        return path + "\(item.md5()).mp4"
    }
    
    func save(item: String) -> Bool {
        return false
    }
    
    func exist(item: String) -> Bool {
        let path = createPath(item: item)
        return path.exists
        
    }
    
    func get(item: String) -> Path? {
        let path = createPath(item: item)
        if path.exists {
            return path
        }
        return nil
    }
    
    func delete(item: String) -> Bool {
        let path = createPath(item: item)
        do {
            try path.deleteFile()
            return true
        } catch {
            return false
        }
    }
    
    func deleteAll() -> Bool {
        do {
            try path.deleteFile()
            try path.createDirectory()
            return true
        } catch {
            return false
        }
    }

}


class NetSearchCache: NetCacheType {
    
    typealias Item = [String]
    
    typealias Result = Path
    
    static let shared = NetSearchCache()
    
    let path = Path.userCaches + "search.plist"
    
    init() {
        if !path.exists {
            try? path.createFile()
        }
    }
    
    func createPath(item: [String]) -> Path {
        fatalError("不需要实现")
    }
    
    @discardableResult
    func save(item: [String]) -> Bool {
        do {
            try item.write(to: path, atomically: true)
            return true
        } catch {
            return false
        }
    }
    
    func exist(item: [String]) -> Bool {
        fatalError("不需要实现")
    }
    
    func get(item: [String]) -> Path? {
        fatalError("不需要实现")
    }
    
    func delete(item: [String]) -> Bool {
        fatalError("不需要实现")
    }
    
    @discardableResult
    func deleteAll() -> Bool {
        return save(item: [])
    }
    
    func getAll() -> [String] {
        do {
            let a = try Array<String>.read(from: path)
            return a
        } catch {
            return []
        }
        
    }
    
    
}
