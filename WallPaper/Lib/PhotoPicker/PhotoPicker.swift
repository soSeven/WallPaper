//
//  PhotoPicker.swift
//  WallPaper
//
//  Created by LiQi on 2020/5/13.
//  Copyright © 2020 Qire. All rights reserved.
//

import Foundation

class PhotoPicker {
    
    static let shared = PhotoPicker()
    
    func pickUserInfoPhoto(controller: UIViewController, completion: @escaping (UIImage?)->()) {
        let imagePickerVc = TZImagePickerController(maxImagesCount: 1, delegate: nil)
        imagePickerVc?.allowPickingOriginalPhoto = false
        imagePickerVc?.allowPickingVideo = false
        imagePickerVc?.showSelectedIndex = true
        imagePickerVc?.hideWhenCanNotSelect = true
        imagePickerVc?.showPhotoCanSelectLayer = true
        imagePickerVc?.showPhotoCannotSelectLayer = true
        let color: UIColor = .init(hex: "#ff5252")
        imagePickerVc?.iconThemeColor = color
        imagePickerVc?.statusBarStyle = .lightContent
        imagePickerVc?.oKButtonTitleColorNormal = color
        imagePickerVc?.oKButtonTitleColorDisabled = color.alpha(0.5)
        imagePickerVc?.photoSelImage = UIImage(color: color, size: .init(width: 24, height: 24))
        imagePickerVc?.photoOriginSelImage = UIImage(color: color, size: .init(width: 20, height: 20))
        imagePickerVc?.naviBgColor = AppDefine.mainColor
        imagePickerVc?.naviBgTintColor = .white
        imagePickerVc?.barItemTextColor = .white
        imagePickerVc?.preferredLanguage = "zh-Hans"
        imagePickerVc?.modalPresentationStyle = .overCurrentContext
        imagePickerVc?.didFinishPickingPhotosHandle = { images, assets, isSelectOriginalPhoto in
            completion(images?.first)
        }
        controller.present(imagePickerVc!, animated: true, completion: nil)
    }
}
