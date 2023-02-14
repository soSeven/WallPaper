//
//  MBProgressHUD+Rx.swift
//  WallPaper
//
//  Created by LiQi on 2020/4/17.
//  Copyright © 2020 Qire. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import MBProgressHUD

extension Reactive where Base: UIView {
    
    var mbHudText: Binder<String> {
        
        return Binder(self.base) {v, text in
            let hud = MBProgressHUD.showAdded(to: v, animated: true)
            hud.mode = .text
            hud.label.text = text
            hud.bezelView.style = .solidColor
            hud.bezelView.color = .init(white: 0, alpha: 0.8)
            hud.contentColor = .white
            hud.hide(animated: true, afterDelay: 2)
        }
        
    }
    
    func mbHudText(completion: @escaping () -> ()) -> Binder<String> {
        
        return Binder(self.base) {v, text in
            let hud = MBProgressHUD.showAdded(to: v, animated: true)
            hud.mode = .text
            hud.label.text = text
            hud.bezelView.style = .solidColor
            hud.bezelView.color = .init(white: 0, alpha: 0.8)
            hud.contentColor = .white
            hud.hide(animated: true, afterDelay: 1.5)
            hud.completionBlock = completion
        }
        
    }
    
    var mbHudLoaing: Binder<Bool> {
        
        return Binder(self.base) { v, hidden in
            
            if hidden {
                let mb = MBProgressHUD.showAdded(to: v, animated: true)
                mb.bezelView.style = .solidColor
                mb.bezelView.color = .clear//[UIColor colorWithWhite:0.8f alpha:0.6f]
                mb.contentColor = .white
                mb.tag = -111111
            } else {
                for sub in v.subviews {
                    if let mb = sub as? MBProgressHUD, mb.tag == -111111 {
                        mb.hide(animated: true)
                        break
                    }
                }
            }
        }
    }
    
    var mbHudLoaingForce: Binder<Bool> {
        
        return Binder(self.base) { v, hidden in
      
            if hidden {
                v.window?.isUserInteractionEnabled = false
                let mb = MBProgressHUD.showAdded(to: v, animated: true)
                mb.bezelView.style = .solidColor
                mb.bezelView.color = .clear//[UIColor colorWithWhite:0.8f alpha:0.6f]
                mb.contentColor = .white
                mb.tag = -111111
                mb.completionBlock = {
                    v.window?.isUserInteractionEnabled = true
                }
            } else {
                for sub in v.subviews {
                    if let mb = sub as? MBProgressHUD, mb.tag == -111111 {
                        mb.hide(animated: true)
                        break
                    }
                }
            }
        }
    }
    
}

