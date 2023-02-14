//
//  HelpInputCellViewModel.swift
//  WallPaper
//
//  Created by LiQi on 2020/4/28.
//  Copyright © 2020 Qire. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class HelpInputCellViewModel {
    
    var name = BehaviorRelay<String>(value: "")
    var id = 0
    var selected = BehaviorRelay<Bool>(value: false)
    
}
