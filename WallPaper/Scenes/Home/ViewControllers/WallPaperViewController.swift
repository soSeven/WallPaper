//
//  WallPaperViewController.swift
//  WallPaper
//
//  Created by LiQi on 2020/4/18.
//  Copyright © 2020 Qire. All rights reserved.
//

import UIKit
import AsyncDisplayKit
import RxSwift
import RxCocoa
import Hero
import Photos
import MBProgressHUD
import SwiftEntryKit

protocol WallPaperViewControllerDelegate: AnyObject {
    
    func wallPaperShowUserHome(controller: WallPaperViewController, viewModel: WallPaperCellNodeViewModel) -> WallPaperHomeControler
}

class WallPaperViewController: ASDKViewController<WallPaperNode> {
    
    var viewModel: WallPaperViewModel!
    var isFromHome = false
    var defaultImg: UIImage?
    
    weak var delegate: WallPaperViewControllerDelegate?
    
    var currentModels = [WallPaperCellNodeViewModel]()
    var currentModel: WallPaperCellNodeViewModel!
    
    var requestNext = PublishRelay<WallPaperModel>()
    var requestPrevious = PublishRelay<WallPaperModel>()
    
    var currentPlayCellNode: WallPaperCellNode?
    
    var backImgView: UIImageView?
    
    override init() {
        let node = WallPaperNode()
        super.init(node: node)
        node.collectionNode.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("deinit \(self)" )
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hbd_barAlpha = 0
        view.backgroundColor = AppDefine.mainColor
        node.collectionNode.backgroundColor = AppDefine.mainColor
        node.collectionNode.view.isPagingEnabled = true
        node.collectionNode.showsVerticalScrollIndicator = false
        node.collectionNode.showsHorizontalScrollIndicator = false
        if #available(iOS 11, *) {
            node.collectionNode.view.contentInsetAdjustmentBehavior = .never
        }
        node.collectionNode.delegate = self
        node.collectionNode.view.scrollsToTop = false
        
        if let img = defaultImg {
            let backImgView = UIImageView(image: img)
            backImgView.contentMode = .scaleAspectFill
            backImgView.frame = .init(x: 0, y: 0, width: UIDevice.screenWidth, height: UIDevice.screenHeight)
            node.view.addSubview(backImgView)
            self.backImgView = backImgView
        }
        
        if isFromHome {
            let backBtn = Button()
            backBtn.addTarget(self, action: #selector(onClickBack), for: .touchUpInside)
            backBtn.setImage(UIImage(named: "login_icon_return"), for: .normal)
            backBtn.frame = .init(x: 0, y: 0, width: 40, height: 40)
            backBtn.contentHorizontalAlignment = .left
            //        backBtn.alig
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backBtn)
        }
        
        setupPan()
        setupBinding()
    }
    
    // MARK: - Binding
    
    private func setupBinding() {
        
        let requestCurrent = Driver<Void>.just(())
        let input = WallPaperViewModel.Input(requestCurrent: requestCurrent,
                                             requestNext:requestNext,
                                             requestPrevious: requestPrevious)
        
        let output = viewModel.transform(input: input)
        output.currentItems.bind { [weak self] (currentItem, arr) in
            guard let self = self else { return }
            guard let item = currentItem else { return }
            self.currentModels = arr
            self.node.collectionNode.reloadData { [weak self] in
                guard let self = self else { return }
                let index = self.currentModels.firstIndex { $0 === item} ?? 0
                self.node.collectionNode.scrollToItem(at: IndexPath(row: index, section: 0), at: .centeredVertically, animated: false)
                self.playVideo(with: index)
                if !self.isFromHome {
                    self.isInteractivePushGestureEnabled = true
                    self.interactivePushGestureDelegate = self
                }
                self.requestCache(currentIdx: index)
                UIView.animate(withDuration: 0.3, animations: {
                    self.backImgView?.alpha = 0
                }) { finished in
                    self.backImgView?.removeFromSuperview()
                }
            }
            
        }.disposed(by: rx.disposeBag)
        
        output.nextItems.bind {[weak self] items in
            guard let self = self else { return }
            if items.count == 0 { return }
            var indexPaths = [IndexPath]()
            let newTotal = items.count + self.currentModels.count
            for row in (self.currentModels.count)..<newTotal {
                let path = IndexPath(row: row, section: 0)
                indexPaths.append(path)
            }
            self.currentModels.append(contentsOf: items)
            self.node.collectionNode.insertItems(at: indexPaths)
        }.disposed(by: rx.disposeBag)

        output.previousItems.bind {[weak self] items in
            guard let self = self else { return }
            if items.count == 0 { return }
            var indexPaths = [IndexPath]()
            for row in 0..<items.count {
                let path = IndexPath(row: row, section: 0)
                indexPaths.append(path)
            }
            self.currentModels.insert(contentsOf: items, at: 0)
            self.node.collectionNode.performBatch(animated: false, updates: { [weak self] in
                guard let self = self else { return }
                self.node.layout.isInsertingToTop = true
                self.node.collectionNode.insertItems(at: indexPaths)
            }) { finished in
                self.node.layout.isInsertingToTop = false
            }
        }.disposed(by: rx.disposeBag)
        
        var hud: MBProgressHUD?
        output.downloadProgess.bind {[weak self] progress, download in
            guard let self = self else { return }
            switch download {
            case .start:
                hud = MBProgressHUD.showAdded(to: self.navigationController!.view, animated: true)
                hud?.mode = .determinateHorizontalBar
                hud?.label.text = "正在设置..."
                hud?.bezelView.style = .solidColor
                hud?.bezelView.color = .init(white: 0, alpha: 0.8)
                hud?.contentColor = .white
                hud?.completionBlock = {
                    hud = nil
                }
            case .downloading:
                hud?.progress = progress
            case .finish:
                hud?.mode = .text
                hud?.label.text = "设置成功，已添加到相册"
                hud?.hide(animated: true, afterDelay: 2)
            case .error(let msg):
                hud?.mode = .text
                hud?.label.text = msg
                hud?.hide(animated: true, afterDelay: 2)
            }
        }.disposed(by: rx.disposeBag)
        
        output.share.subscribe(onNext: {[weak self] model in
            guard let self = self else { return }
            let sheetView = WallPaperShareSheetView(id: self.currentModel.model.id, viewController: self)
            sheetView.show()
        }).disposed(by: rx.disposeBag)
        
        output.isShowLoading.distinctUntilChanged().bind(to: view.rx.mbHudLoaing).disposed(by: rx.disposeBag)
        
        output.userHome.subscribe(onNext: {[weak self] model in
            guard let self = self else { return }
            let controller = self.delegate?.wallPaperShowUserHome(controller: self, viewModel: self.currentModel)
            if let v = controller {
                self.navigationController?.pushViewController(v)
            }
        }).disposed(by: rx.disposeBag)
        
        viewModel.parsedError.bind(to: view.rx.toastError).disposed(by: rx.disposeBag)
        
    }
    
    // MARK: - Cache
    
    private func requestCache(currentIdx: Int) {
        if currentIdx < 5, let first = currentModels.first {
            requestPrevious.accept(first.model)
        }
        if currentModels.count - currentIdx < 5, let last = currentModels.last {
            requestNext.accept(last.model)
        }
    }
    
    // MARK: - Play
    
    private func playVideo(with index: Int) {
        let cell = node.collectionNode.nodeForItem(at: IndexPath(row: index, section: 0)) as? WallPaperCellNode
        guard let cellNode = cell else {
            return
        }
        if let last = currentPlayCellNode, last.viewModel.model.id != cellNode.viewModel.model.id {
            last.videoNode.pause()
        }
        cellNode.videoNode.play()
        currentPlayCellNode = cellNode
        currentModel = cellNode.viewModel
    }
    
    // MARK: - Hero
    
    private func setupPan() {
        if isFromHome {
            let screenEdgePanGR = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleScreenPan(pan:)))
            screenEdgePanGR.edges = .left
            view.addGestureRecognizer(screenEdgePanGR)
        } else {
            
//            let screenEdgePanGR = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleHomeScreenPan(pan:)))
//            screenEdgePanGR.edges = .right
//            view.addGestureRecognizer(screenEdgePanGR)
            
        }
    }
    
    @objc
    private func handleScreenPan(pan: UIPanGestureRecognizer) {
        switch pan.state {
        case .began:
            dismiss(animated: true, completion: nil)
        case .changed:
            let progress = pan.translation(in: nil).x / view.bounds.width
            Hero.shared.update(progress)
        default:
            if (pan.translation(in: nil).x + pan.velocity(in: nil).x) / view.bounds.width > 0.5 {
                Hero.shared.finish()
            } else {
                Hero.shared.cancel()
            }
        }
    }
    
    @objc
    private func onClickBack() {
        hero.dismissViewController()
    }
    
    // MARK: - Event

}

extension WallPaperViewController: ASCollectionDataSource {
    
    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        return currentModels.count
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
        let model = currentModels[indexPath.row]
        return {
            let cellNode = WallPaperCellNode(model: model)
            cellNode.parentNode = collectionNode
            cellNode.parentController = self
            return cellNode
        }
    }
    
}

extension WallPaperViewController: ASCollectionDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let y = scrollView.contentOffset.y
        let currrentIndexPath = node.collectionNode.indexPathForItem(at: .init(x: 0, y: y))
        guard let currentIndexPath = currrentIndexPath else {
            return
        }
        requestCache(currentIdx: currentIndexPath.row)
        playVideo(with: currentIndexPath.row)
        
    }
}

extension WallPaperViewController: UIViewControllerInteractivePushGestureDelegate {
    
    func destinationViewController(from fromViewController: UIViewController!) -> UIViewController! {
        return self.delegate?.wallPaperShowUserHome(controller: self, viewModel: self.currentModel)
    }
    
}


