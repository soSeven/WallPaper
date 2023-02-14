//
//  WebView.swift
//  WallPaper
//
//  Created by LiQi on 2020/4/26.
//  Copyright © 2020 Qire. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit
import WebKit

final class WebViewController: ViewController {

    // MARK: - Fields

    private var webView: WKWebView?

    private lazy var progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.progressTintColor = .white
        progressView.trackTintColor = .clear
        return progressView
    }()

    private var disposeBag = DisposeBag()

    var url: URL?
    
    // MARK: - Lifecycle

    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: webConfiguration)

        webView.allowsBackForwardNavigationGestures = true
        webView.isMultipleTouchEnabled = true

        view = webView
        self.webView = webView
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        guard let navigationController = navigationController else {
            return
        }
        progressView.frame = CGRect(x: 0, y: navigationController.navigationBar.frame.size.height - progressView.frame.size.height, width: navigationController.navigationBar.frame.size.width, height: progressView.frame.size.height)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupBinding()
        setupData()
    }

    // MARK: - Setup

    private func setupUI() {
        navigationController?.navigationBar.addSubview(progressView)
    }

    private func setupData() {
        if let url = url {
            load(url)
        }
    }

    private func setupBinding() {

        guard let webView = webView else {
            return
        }

        webView.rx.title.bind(to: navigationItem.rx.title).disposed(by: disposeBag)
        webView.rx.estimatedProgress.bind { [weak self] estimatedProgress in
            self?.progressView.alpha = 1
            self?.progressView.setProgress(Float(estimatedProgress), animated: true)

            if estimatedProgress >= 1.0 {
                UIView.animate(withDuration: 0.3, delay: 0.3, options: .curveEaseOut, animations: { [weak self] in
                    self?.progressView.alpha = 0
                    }, completion: { [weak self] _ in
                        self?.progressView.setProgress(0, animated: false)
                })
            }
        }.disposed(by: disposeBag)
    }

    private func load(_ url: URL) {
        guard let webView = webView else {
            return
        }
        let request = URLRequest(url: url)
        DispatchQueue.main.async {
            webView.load(request)
        }
    }
}

