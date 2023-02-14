//
//  AboutViewController.swift
//  WallPaper
//
//  Created by LiQi on 2020/4/26.
//  Copyright © 2020 Qire. All rights reserved.
//

import UIKit

class AboutViewController: ViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "关于我们"
        setupUI()
    }
    
    // MARK: - UI
    
    private func setupUI() {
        
        let imgView = UIImageView(image: UIImage(named: "about_img_logo"))
        view.addSubview(imgView)
        imgView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 75.uiX, height: 75.uiX))
            make.top.equalTo(view.snp.topMargin).offset(82.uiX)
            make.centerX.equalToSuperview()
        }
        
        let lbl1 = UILabel()
        view.addSubview(lbl1)
        lbl1.text = "咔咔动态壁纸"
        lbl1.font = .init(style: .medium, size: 18.uiX)
        lbl1.textColor = .init(hex: "#ffffff")
        lbl1.snp.makeConstraints { make in
            make.top.equalTo(imgView.snp.bottom).offset(21.uiX)
            make.centerX.equalToSuperview()
        }
        
        let lbl2 = UILabel()
        view.addSubview(lbl2)
        lbl2.text = "动起来  拥有精彩未来"
        lbl2.font = .init(style: .regular, size: 13.uiX)
        lbl2.textColor = .init(hex: "#999999")
        lbl2.snp.makeConstraints { make in
            make.top.equalTo(lbl1.snp.bottom).offset(5.uiX)
            make.centerX.equalToSuperview()
        }
        
        let lbl3 = UILabel()
        view.addSubview(lbl3)
        lbl3.text = "v" + (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "")
        lbl3.font = .init(style: .regular, size: 13.uiX)
        lbl3.textColor = .init(hex: "#999999")
        lbl3.snp.makeConstraints { make in
            make.top.equalTo(lbl2.snp.bottom).offset(5.uiX)
            make.centerX.equalToSuperview()
        }
        
        let lbl4 = UILabel()
        view.addSubview(lbl4)
        lbl4.text = "Copyright ©2016-2020 \n奇热公司.All Rights Reserved"
        lbl4.numberOfLines = 0
        lbl4.font = .init(style: .regular, size: 10.uiX)
        lbl4.textColor = .init(hex: "#B3B3B3")
        lbl4.textAlignment = .center
        lbl4.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.snp.bottomMargin).offset(-20.uiX)
        }
    }

}
