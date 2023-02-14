//
//  ZanViewController.swift
//  WallPaper
//
//  Created by LiQi on 2020/5/11.
//  Copyright © 2020 Qire. All rights reserved.
//

import UIKit

protocol ZanViewControllerDelegate: AnyObject {
    
    func showWallPaperController(controller: ZanViewController, model: WallPaperInfoModel, image: UIImage?)
    
}

class ZanViewController: ViewController {
    
    weak var delegate: ZanViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "赞过"
        let list = WallPaperListViewController()
        let service = ZanWallPaperListService()
        let viewModel = WallPapreListViewModel(service: service)
        list.viewModel = viewModel
        list.itemAction = {[weak self] model, image in
            guard let self = self else { return }
            self.delegate?.showWallPaperController(controller: self, model: model, image: image)
        }
        addChild(list)
        view.addSubview(list.view)
        list.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        list.wallPaperListView.collectionView.contentInset = .init(top: 20, left: 0, bottom: 40, right: 0)
        list.wallPaperListView.collectionView.mj_header?.ignoredScrollViewContentInsetTop = 20
    }
    

}
