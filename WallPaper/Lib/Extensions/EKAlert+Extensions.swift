//
//  EKAlert+Extensions.swift
//  WallPaper
//
//  Created by LiQi on 2020/4/27.
//  Copyright © 2020 Qire. All rights reserved.
//

import Foundation
import SwiftEntryKit

extension EKAlertMessageView {
    
    struct AlertEvent {
        let title: String
        let action: (() -> ())?
    }
    
    class func showAlert(title: String, detail: String, left: AlertEvent, right: AlertEvent) {
        let title = EKProperty.LabelContent(
               text: title,
               style: EKProperty.LabelStyle(font: .init(style: .regular, size: 15.uiX), color: .white, alignment: .center)
           )
           let description = EKProperty.LabelContent(
               text: detail,
               style: EKProperty.LabelStyle(font: .init(style: .regular, size: 14.uiX), color: .white, alignment: .center)
           )
        let leftTitle = EKProperty.LabelContent(
            text: left.title,
            style: EKProperty.LabelStyle(font: .init(style: .regular, size: 15.uiX), color: .white, alignment: .center)
        )
        let rightTitle = EKProperty.LabelContent(
            text: right.title,
            style: EKProperty.LabelStyle(font: .init(style: .regular, size: 15.uiX), color: .white, alignment: .center)
        )
        let leftButtonContent = EKProperty.ButtonContent(label: leftTitle, backgroundColor: .clear, highlightedBackgroundColor: .clear, contentEdgeInset: 10, displayMode: .light, accessibilityIdentifier: nil) {
            left.action?()
            SwiftEntryKit.dismiss()
        }
        let rightButtonContent = EKProperty.ButtonContent(label: rightTitle, backgroundColor: .clear, highlightedBackgroundColor: .clear, contentEdgeInset: 10, displayMode: .light, accessibilityIdentifier: nil) {
            right.action?()
            SwiftEntryKit.dismiss()
        }
        let button = EKProperty.ButtonBarContent(with: [leftButtonContent, rightButtonContent], separatorColor: .init(.init(hex: "#666666")), expandAnimatedly: false)
        let msg = EKAlertMessage(simpleMessage: EKSimpleMessage(title: title, description: description), buttonBarContent: button)
        let msgView = EKAlertMessageView(with: msg)
        var attribute = EKAttributes()
        attribute.positionConstraints.size = .init(width: .ratio(value: 0.7), height: .intrinsic)
        attribute.positionConstraints.verticalOffset = 100.uiX
        attribute.position = .center
        attribute.screenBackground = .color(color: .init(.init(white: 0, alpha: 0.7)))
        attribute.entryBackground = .color(color: .init(AppDefine.mainColor))
        attribute.screenInteraction = .dismiss
        attribute.entryInteraction = .absorbTouches
        attribute.roundCorners = .all(radius: 4.uiX)
        attribute.displayDuration = .infinity
        SwiftEntryKit.display(entry: msgView, using: attribute)
    }
    
}
