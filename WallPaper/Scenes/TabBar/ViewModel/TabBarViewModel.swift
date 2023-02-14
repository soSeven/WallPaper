//
//  TabBarViewModel.swift
//  WallPaper
//
//  Created by LiQi on 2020/4/9.
//  Copyright © 2020 Qire. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class TabBarViewModel: ViewModelType {
    
    struct Input {

    }
    
    struct Output {
        let tabBarItems: Driver<[TabBarItem]>
    }
    
    func transform(input: Input) -> Output {
        let items: [TabBarItem] = [.home, .mine]
        let tabBarItems = Driver.just(items)
        return Output(tabBarItems: tabBarItems)
    }
    
//    func viewModel<T: ViewModelType>(for tabBarItem: TabBarItem) -> T {
//        switch tabBarItem {
//        case .home:
//            <#code#>
//        case .mine:
//
//        }
//    }
}
