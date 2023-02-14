//
//  WallPaperFlowLayout.swift
//  WallPaper
//
//  Created by LiQi on 2020/4/20.
//  Copyright © 2020 Qire. All rights reserved.
//

import UIKit

class WallPaperFlowLayout: UICollectionViewFlowLayout {
    
    var isInsertingToTop = false
    
    override func prepare() {
      super.prepare()
      guard let collectionView = collectionView else {
        return
      }
      if !isInsertingToTop {
        return
      }
      let oldSize = collectionView.contentSize
      let newSize = collectionViewContentSize
      let contentOffsetY = collectionView.contentOffset.y + newSize.height - oldSize.height
      collectionView.setContentOffset(CGPoint(x: collectionView.contentOffset.x, y: contentOffsetY), animated: false)
    }

}

