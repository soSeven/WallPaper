//
//  WallPaperCellNode.swift
//  WallPaper
//
//  Created by LiQi on 2020/4/18.
//  Copyright © 2020 Qire. All rights reserved.
//

import Foundation
import AsyncDisplayKit
import RxGesture
import RxSwift
import RxCocoa

class WallPaperCellInfoBottomNode: ASControlNode {
    
    let imgNode = ASImageNode()
    let textNode = ASTextNode()
    var progressView: UIProgressView!
    var loadingView: WallPaperLoadingView!
    
    override init() {
        super.init()
        imgNode.image = UIImage(named: "wallpaper_detail_icon_setting")
        
        let att: [NSAttributedString.Key: Any] = [
            .font: UIFont(style: .regular, size: 17.uiX),
            .foregroundColor: UIColor(hex: "#ffffff")
        ]
        textNode.attributedText = NSAttributedString(string: "设为壁纸", attributes: att)
        
        addSubnode(imgNode)
        addSubnode(textNode)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let stack = ASStackLayoutSpec.horizontal()
        stack.children = [imgNode, textNode]
        stack.justifyContent = .center
        stack.alignItems = .center
        stack.spacing = Float(6.5).uiX
        return stack
    }
    
    override func didLoad() {
        super.didLoad()
        
        progressView = ProgressView()
        progressView.backgroundColor = .clear
        progressView.trackTintColor = .clear
        progressView.progressTintColor = .init(hex: "#ffffff")
        progressView.progress = 0
        view.addSubview(progressView)
        progressView.isHidden = true
        
        loadingView = WallPaperLoadingView()
        loadingView.stopLoading()
        view.addSubview(loadingView)
    }
    
    override func layoutDidFinish() {
        super.layoutDidFinish()
        
        progressView.frame = .init(x: 0, y: 0, width: view.bounds.width, height: 1/UIScreen.main.scale)
        
        loadingView.frame = .init(x: 0, y: 0, width: view.bounds.width, height: 1/UIScreen.main.scale)
    }
}

class WallPaperCellInfoNode: ASDisplayNode {
    
    let bottomBar = WallPaperCellInfoBottomNode()
    
    let contentBar = ASDisplayNode()
    let contentShadowImg = ASImageNode()
    let nameText = ASTextNode()
    let descText = ASTextNode()
    var markTexts = [ASTextNode]()
    var downNodes = [ASDisplayNode]()
    
    let iphoneXBar = ASDisplayNode()
    
    let avatarImgNode = ASNetworkImageNode.imageNode()
    let attentionNode = ASButtonNode()
    let zanNode = ASButtonNode()
    let shareNode = ASButtonNode()
    let createNode = ASButtonNode()
    
    required init(model: WallPaperModel) {
        
//        paperModel = model
        
        super.init()
        bottomBar.backgroundColor = UIColor(hex: "#000000").alpha(0.4)
        bottomBar.style.height = ASDimensionMakeWithPoints(56.uiX)
        
        iphoneXBar.backgroundColor = UIColor(hex: "#000000").alpha(0.4)
        iphoneXBar.style.height = ASDimensionMakeWithPoints(UIDevice.safeAreaBottom)
        
        addSubnode(iphoneXBar)
        addSubnode(bottomBar)
        addSubnode(contentBar)
        
        let img = UIImage(named: "wallpaper_detail_img_bgd")!
        contentShadowImg.image = img
        let height = UIDevice.screenWidth*img.snpScale
        contentShadowImg.style.height = ASDimensionMakeWithPoints(height)
        addSubnode(contentShadowImg)
        
        let att: [NSAttributedString.Key: Any] = [
            .font: UIFont(style: .medium, size: 17.uiX),
            .foregroundColor: UIColor(hex: "#ffffff")
        ]
        nameText.attributedText = NSAttributedString(string: "@" + model.userNickname, attributes: att)
        addSubnode(nameText)
        
        let descAtt: [NSAttributedString.Key: Any] = [
            .font: UIFont(style: .regular, size: 15.uiX),
            .foregroundColor: UIColor(hex: "#ffffff")
        ]
        descText.attributedText = NSAttributedString(string: model.descriptionField, attributes: descAtt)
        descText.maximumNumberOfLines = 4
        addSubnode(descText)
        
        for mark in model.categories {
            let markText = ASTextNode()
            let markAtt: [NSAttributedString.Key: Any] = [
                .font: UIFont(style: .regular, size: 11.uiX),
                .foregroundColor: UIColor(hex: "#ffffff")
            ]
//            markText.style.height = ASDimensionMakeWithPoints(21.uiX)
            markText.textContainerInset = .init(top: 5.uiX, left: 7.uiX, bottom: 5.uiX, right: 7.uiX)
            markText.cornerRadius = 3.uiX
            markText.clipsToBounds = true
            markText.backgroundColor = UIColor(hex: "#000000").alpha(0.5)
            markText.attributedText = NSAttributedString(string: mark.name, attributes: markAtt)
            addSubnode(markText)
            markTexts.append(markText)
        }
        
        let vipOrFreeNode = ASImageNode()
        vipOrFreeNode.style.width = ASDimensionMakeWithPoints(22.uiX)
        vipOrFreeNode.style.height = ASDimensionMakeWithPoints(11.uiX)
        if model.isVip > 0 {
            vipOrFreeNode.image = UIImage(named: "wallpaper_detail_img_vip")
        } else {
            vipOrFreeNode.image = UIImage(named: "wallpaper_detail_img_vip")
        }
        addSubnode(vipOrFreeNode)
        downNodes.append(vipOrFreeNode)
        
        let lineNode1 = ASDisplayNode()
        lineNode1.style.width = ASDimensionMakeWithPoints(1/UIScreen.main.scale)
        lineNode1.style.height = ASDimensionMakeWithPoints(Float(8.5).uiX)
        lineNode1.backgroundColor = .init(hex: "#ffffff")
        addSubnode(lineNode1)
        downNodes.append(lineNode1)
        
        let timeAtt: [NSAttributedString.Key: Any] = [
            .font: UIFont(style: .medium, size: 12.uiX),
            .foregroundColor: UIColor(hex: "#ffffff")
        ]
        let timeText = ASTextNode()
        timeText.attributedText = NSAttributedString(string: String(model.duration), attributes: timeAtt)
        addSubnode(timeText)
        downNodes.append(timeText)
        
        let lineNode2 = ASDisplayNode()
        lineNode2.style.width = ASDimensionMakeWithPoints(1/UIScreen.main.scale)
        lineNode2.style.height = ASDimensionMakeWithPoints(Float(8.5).uiX)
        lineNode2.backgroundColor = .init(hex: "#ffffff")
        addSubnode(lineNode2)
        downNodes.append(lineNode2)
        
        let downText = ASButtonNode()
        let downTitle = NSAttributedString(string: String(model.setNum), attributes: timeAtt)
        downText.setImage(UIImage(named: "wallpaper_detail_icon_download"), for: .normal)
        downText.setAttributedTitle(downTitle, for: .normal)
        downText.contentSpacing = 3.uiX
        addSubnode(downText)
        downNodes.append(downText)
        
        createNode.contentSpacing = 7.uiX
        createNode.laysOutHorizontally = false
        createNode.style.width = ASDimensionMakeWithPoints(Float(48).uiX)
        createNode.setImage(UIImage(named: "wallpaper_detail_img_make"), for: .normal)
        createNode.setAttributedTitle(NSAttributedString(string: "创作同款", attributes: timeAtt), for: .normal)
        addSubnode(createNode)
        
        shareNode.contentSpacing = 6.uiX
        shareNode.laysOutHorizontally = false
        shareNode.style.width = ASDimensionMakeWithPoints(Float(48).uiX)
        shareNode.setImage(UIImage(named: "wallpaper_detail_icon_share"), for: .normal)
        shareNode.setAttributedTitle(NSAttributedString(string: "分享", attributes: timeAtt), for: .normal)
        addSubnode(shareNode)
        
        shareNode.contentSpacing = 7.uiX
        zanNode.laysOutHorizontally = false
        zanNode.style.width = ASDimensionMakeWithPoints(Float(48).uiX)
        zanNode.setImage(UIImage(named: "wallpaper_detail_icon_like"), for: .selected)
        zanNode.setImage(UIImage(named: "wallpaper_detail_icon_like_nor"), for: .normal)
        zanNode.setAttributedTitle(NSAttributedString(string: "赞", attributes: timeAtt), for: .normal)
        addSubnode(zanNode)
        
        avatarImgNode.style.width = ASDimensionMakeWithPoints(Float(48).uiX)
        avatarImgNode.style.height = ASDimensionMakeWithPoints(Float(48).uiX)
        avatarImgNode.cornerRadius = 24.uiX
        avatarImgNode.borderColor = UIColor(hex: "#ffffff").cgColor
        avatarImgNode.borderWidth = 1
        avatarImgNode.url = URL(string: model.userAvatar)
        addSubnode(avatarImgNode)
        
        attentionNode.style.width = ASDimensionMakeWithPoints(Float(20).uiX)
        attentionNode.style.height = ASDimensionMakeWithPoints(Float(20).uiX)
        attentionNode.setImage(UIImage(named: "wallpaper_detail_icon_add"), for: .normal)
        addSubnode(attentionNode)
        
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        contentBar.style.flexGrow = 2
        let contentSpec = layoutContentNode()
        contentSpec.style.flexGrow = 2
        let stack = ASStackLayoutSpec.vertical()
        stack.children = [contentSpec, bottomBar, iphoneXBar]
        stack.justifyContent = .end
        return stack
    }
    
    private func layoutContentNode() -> ASLayoutSpec{
//        contentShadowImg.style.flexShrink = 1
        let stack = ASStackLayoutSpec.vertical()
        stack.child = contentShadowImg
        stack.justifyContent = .end
        stack.alignItems = .stretch
        let overlayImg = ASOverlayLayoutSpec(child: contentBar, overlay: stack)
        
        let downStack = ASStackLayoutSpec.horizontal()
        downStack.children = downNodes
        downStack.alignItems = .center
        downStack.justifyContent = .start
        downStack.spacing = 11.uiX
        
        let textStack = ASStackLayoutSpec.vertical()
        nameText.style.spacingAfter = -8.uiX
        descText.style.spacingAfter = -3.uiX
        if markTexts.count > 0 {
            let markStack = ASStackLayoutSpec.horizontal()
            markStack.children = markTexts
            markStack.alignItems = .center
            markStack.justifyContent = .start
            markStack.spacing = 11.uiX
            textStack.children = [nameText, descText, downStack, markStack]
        } else {
            textStack.children = [nameText, descText, downStack]
        }
        
        textStack.justifyContent = .end
        textStack.alignItems = .start
        textStack.spacing = 11.uiX
        
        let textOverlay = ASOverlayLayoutSpec(child: overlayImg, overlay: ASInsetLayoutSpec(insets: .init(top: 0, left: 15.uiX, bottom: 15.uiX, right: 80.uiX), child: textStack))
        
        
        let attentionStack = ASStackLayoutSpec.vertical()
        attentionStack.children = [avatarImgNode, attentionNode]
        attentionStack.alignItems = .center
        attentionStack.justifyContent = .center
        avatarImgNode.style.spacingAfter = -11.uiX
        
        let btnstack = ASStackLayoutSpec.vertical()
        btnstack.children = [attentionStack, zanNode, shareNode, createNode]
        btnstack.alignItems = .end
        btnstack.justifyContent = .end
        btnstack.spacing = 30.uiX
        
        let overlay = ASOverlayLayoutSpec(child: textOverlay, overlay: ASInsetLayoutSpec(insets: .init(top: 0, left: 0, bottom: 17.uiX, right: 10.uiX), child: btnstack))
        
        return overlay
    }
    
}

class WallPaperCellNode: ASCellNode {
    
    let videoNode = ASVideoNode.videoNode()
    let viewModel: WallPaperCellNodeViewModel
    let infoNode: WallPaperCellInfoNode
    unowned var parentNode: ASCollectionNode?
    unowned var parentController: UIViewController?
    
    let zan = PublishRelay<Void>()
    let attention = PublishRelay<Void>()
    
    required init(model: WallPaperCellNodeViewModel) {
        viewModel = model
        infoNode = WallPaperCellInfoNode(model: viewModel.model)
        super.init()
        neverShowPlaceholders = true
        videoNode.url = URL(string: viewModel.model.cover)
        videoNode.shouldAutoplay = false
        videoNode.shouldAutorepeat = true
        self.addSubnode(videoNode)
        self.addSubnode(infoNode)
    }
    
    override func didLoad() {
        super.didLoad()
        videoNode.assetURL = URL(string: viewModel.model.video)
        videoNode.gravity = AVLayerVideoGravity.resizeAspectFill.rawValue
        videoNode.delegate = self
        
        infoNode.bottomBar.addTarget(self, action: #selector(onClickMake), forControlEvents: .touchUpInside)
        infoNode.attentionNode.addTarget(self, action: #selector(onClickAttention), forControlEvents: .touchUpInside)
        infoNode.shareNode.addTarget(self, action: #selector(onClickShare), forControlEvents: .touchUpInside)
        infoNode.zanNode.addTarget(self, action: #selector(onClickZan), forControlEvents: .touchUpInside)
        infoNode.createNode.addTarget(self, action: #selector(onClickCreate), forControlEvents: .touchUpInside)
        infoNode.avatarImgNode.addTarget(self, action: #selector(onClickAvatar), forControlEvents: .touchUpInside)
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(onClickDoubleTap(tap: )))
        doubleTap.numberOfTapsRequired = 2
        infoNode.contentBar.view.addGestureRecognizer(doubleTap)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(onClickSingleTap(tap: )))
        tap.numberOfTapsRequired = 1
        infoNode.contentBar.view.addGestureRecognizer(tap)
        
        tap.require(toFail: doubleTap)
        
        setupBinding()
    }
    
    private func setupBinding() {
        
        let input = WallPaperCellNodeViewModel.Input(zan: zan, attention: attention)
        let output = viewModel.transform(input: input)
        
        output.isZan.bind {[weak self] iszan in
            guard let self = self else { return }
            self.infoNode.zanNode.isSelected = iszan
            let timeAtt: [NSAttributedString.Key: Any] = [
                .font: UIFont(style: .medium, size: 12.uiX),
                .foregroundColor: UIColor(hex: "#ffffff")
            ]
            self.infoNode.zanNode.setAttributedTitle(NSAttributedString(string: iszan ? "已赞" : "赞", attributes: timeAtt), for: .normal)
        }.disposed(by: rx.disposeBag)
        
        viewModel.isAttention.skip(1).distinctUntilChanged().flatMap({ a in
            return a ? Observable<String>.just("关注成功") : Observable<String>.just("已取消关注")
        }).bind(to: view.rx.mbHudText).disposed(by: rx.disposeBag)
        
    }
    
    // MARK: - Event
    @objc
    private func onClickSingleTap(tap: UITapGestureRecognizer) {
        parentNode?.view.isScrollEnabled = false
        parentController?.navigationItem.leftBarButtonItem?.customView?.isHidden = true
        let v = WallPaperCoverView(frame: bounds)
        view.addSubview(v)
        v.layoutIfNeeded()
        v.hideAnimation = { [weak self] in
            guard let self = self else { return }
            self.infoNode.alpha = 1
        }
        v.hideCompletion = { [weak self] in
            guard let self = self else { return }
            self.parentNode?.view.isScrollEnabled = true
            self.parentController?.navigationItem.leftBarButtonItem?.customView?.isHidden = false
        }
        v.show(animation: {[weak self] in
            guard let self = self else { return }
            self.infoNode.alpha = 0
        }, completion: {
            
        })
    }
    
    @objc
    private func onClickDoubleTap(tap: UITapGestureRecognizer) {
        if let view = tap.view {
            self.showLikeImg(with: tap.location(in: view), view: view)
            if !viewModel.model.isZan {
                zan.accept(())
            }
        }
    }
    
    @objc
    private func onClickMake() {
        viewModel.download.onNext(viewModel.model)
    }
    
    @objc
    private func onClickAttention() {
        if !viewModel.model.isFollow {
            attention.accept(())
        }
    }
    
    @objc
    private func onClickShare() {
        viewModel.share.onNext(viewModel.model)
    }
    
    @objc
    private func onClickZan() {
        zan.accept(())
    }
    
    @objc
    private func onClickCreate() {
        viewModel.create.onNext(viewModel.model)
    }
    
    @objc
    private func onClickAvatar() {
        viewModel.userHome.onNext(viewModel.model)
    }
    
    // MARK: - Layout
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let inset = ASInsetLayoutSpec(insets: .zero, child: videoNode)
        let overlay = ASOverlayLayoutSpec(child: inset, overlay: infoNode)
        return overlay
    }
    
    private func showLikeImg(with point: CGPoint, view: UIView) {
        let img = UIImage(named: "wallpaper_detail_icon_like")!
        let imgView = UIImageView(image: img)
        imgView.frame = .init(x: 0, y: 0, width: img.size.width * 3, height: img.size.height * 3)
        imgView.center = point
        
        let leftOrRight = Bool.random() ? 1 : -1
        imgView.transform = imgView.transform.rotated(by: CGFloat(Float.pi / 9.0 * Float(leftOrRight)))
        view.addSubview(imgView)
        
        UIView.animate(withDuration: 0.1, animations: {
            imgView.transform = imgView.transform.scaledBy(x: 1.2, y: 1.2)
        }) { finished in
            imgView.transform = imgView.transform.scaledBy(x: 0.8, y: 0.8)
            UIView.animate(withDuration: 1.0, delay: 0.3, options: .allowAnimatedContent, animations: {
                var imgViewFrame = imgView.frame
                imgView.transform = .identity
                imgViewFrame.origin.y -= 100
                imgView.frame = imgViewFrame
                imgView.transform = imgView.transform.scaledBy(x: 1.8, y: 1.8)
                imgView.alpha = 0
            }) { finished in
                imgView.removeFromSuperview()
            }
        }
    }
}

extension WallPaperCellNode: ASVideoNodeDelegate {
    
    func videoNode(_ videoNode: ASVideoNode, didPlayToTimeInterval timeInterval: TimeInterval) {
        
        if let duration = videoNode.asset?.duration, duration.timescale > 0 {
            let total = Double(duration.value) / Double(duration.timescale)
            infoNode.bottomBar.progressView.progress = Float(timeInterval/total)
        }
    }
    
    func videoNode(_ videoNode: ASVideoNode, willChange state: ASVideoNodePlayerState, to toState: ASVideoNodePlayerState) {
        switch toState {
        case .loading, .initialLoading, .unknown, .readyToPlay, .playbackLikelyToKeepUpButNotPlaying:
            infoNode.bottomBar.loadingView.startLoading()
            infoNode.bottomBar.progressView.isHidden = true
        default:
            infoNode.bottomBar.loadingView.stopLoading()
            infoNode.bottomBar.progressView.isHidden = false
        }
    }
    
}
