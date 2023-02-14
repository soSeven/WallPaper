//
//  WallPaperNode.swift
//  WallPaper
//
//  Created by LiQi on 2020/4/18.
//  Copyright © 2020 Qire. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class WallPaperNode: ASDisplayNode {
    
    let collectionNode: ASCollectionNode
    let layout: WallPaperFlowLayout
    
    override init() {
        layout = WallPaperFlowLayout()
        layout.itemSize = .init(width: UIDevice.screenWidth, height: UIDevice.screenHeight)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        collectionNode = ASCollectionNode(collectionViewLayout: layout)
        super.init()
        
        self.addSubnode(collectionNode)
    }
    
    // MARK: - Layout
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let inset = ASInsetLayoutSpec(insets: .init(top: 0, left: 0, bottom: 0, right: 0), child: collectionNode)
        return inset
    }
}


