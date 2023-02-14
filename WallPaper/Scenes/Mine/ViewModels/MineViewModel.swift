//
//  MineViewModel.swift
//  WallPaper
//
//  Created by LiQi on 2020/4/14.
//  Copyright © 2020 Qire. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

struct MineSection {
    var items: [MineCellViewModel]
}

extension MineSection: SectionModelType {
    
    typealias Item = MineCellViewModel
    
    init(original: MineSection, items: [Item]) {
        self = original
        self.items = items
    }
    
}

class MineViewModel: ViewModel, ViewModelType {
    
    struct Input {
        
    }
    
    struct Output {
        var sectionItems: BehaviorRelay<[MineSection]>
        var login: BehaviorRelay<UserModel?>
    }
    
    func transform(input: MineViewModel.Input) -> MineViewModel.Output {
        
        let sectionItems = BehaviorRelay<[MineSection]>(value: [])
        let login = BehaviorRelay<UserModel?>(value: nil)
        
        let zan = MineCellViewModel(type: .zan)
        let attension = MineCellViewModel(type: .attention)
        let message = MineCellViewModel(type: .message)
        let help = MineCellViewModel(type: .help)
        let setting = MineCellViewModel(type: .setting)
        
        UserManager.shared.login.subscribe(onNext: { user in
            login.accept(user)
            if let user = user {
                message.number.accept(user.messageNum)
            } else {
                message.number.accept(0)
            }
        }).disposed(by: rx.disposeBag)
        
        let section1 = MineSection(items: [zan, attension, message])
        let section2 = MineSection(items: [help, setting])
        sectionItems.accept([section1, section2])
        
        return Output(sectionItems: sectionItems, login: login)
    }
    
    
}
