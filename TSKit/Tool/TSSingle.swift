//
//  TSSingle.swift
//  TSKit
//
//  Created by mc on 2018/8/20.
//  Copyright © 2018年 张玉飞. All rights reserved.
//

/*
 11111111111111111111111111111111111111001111111111111111111111111
 11111111111111111111111111111111111100011111111111111111111111111
 11111111111111111111111111111111100001111111111111111111111111111
 11111111111111111111111111111110000111111111111111111111111111111
 11111111111111111111111111111000000111111111111111111111111111111
 11111111111111111111111111100000011110001100000000000000011111111
 11111111111111111100000000000000000000000000000000011111111111111
 11111111111111110111000000000000000000000000000011111111111111111
 11111111111111111111111000000000000000000000000000000000111111111
 11111111111111111110000000000000000000000000000000111111111111111
 11111111111111111100011100000000000000000000000000000111111111111
 11111111111111100000110000000000011000000000000000000011111111111
 11111111111111000000000000000100111100000000000001100000111111111
 11111111110000000000000000001110111110000000000000111000011111111
 11111111000000000000000000011111111100000000000000011110001111111
 11111110000000011111111111111111111100000000000000001111100111111
 11111111000001111111111111111111110000000000000000001111111111111
 11111111110111111111111111111100000000000000000000000111111111111
 11111111111111110000000000000000000000000000000000000111111111111
 11111111111111111100000000000000000000000000001100000111111111111
 11111111111111000000000000000000000000000000111100000111111111111
 11111111111000000000000000000000000000000001111110000111111111111
 11111111100000000000000000000000000000001111111110000111111111111
 11111110000000000000000000000000000000111111111110000111111111111
 11111100000000000000000001110000001111111111111110001111111111111
 11111000000000000000011111111111111111111111111110011111111111111
 11110000000000000001111111111111111100111111111111111111111111111
 11100000000000000011111111111111111111100001111111111111111111111
 11100000000001000111111111111111111111111000001111111111111111111
 11000000000001100111111111111111111111111110000000111111111111111
 11000000000000111011111111111100011111000011100000001111111111111
 11000000000000011111111111111111000111110000000000000011111111111
 11000000000000000011111111111111000000000000000000000000111111111
 11001000000000000000001111111110000000000000000000000000001111111
 11100110000000000001111111110000000000000000111000000000000111111
 11110110000000000000000000000000000000000111111111110000000011111
 11111110000000000000000000000000000000001111111111111100000001111
 11111110000010000000000000000001100000000111011111111110000001111
 11111111000111110000000000000111110000000000111111111110110000111
 11111110001111111100010000000001111100000111111111111111110000111
 11111110001111111111111110000000111111100000000111111111111000111
 11111111001111111111111111111000000111111111111111111111111100011
 11111111101111111111111111111110000111111111111111111111111001111
 11111111111111111111111111111110001111111111111111111111100111111
 11111111111111111111111111111111001111111111111111111111001111111
 11111111111111111111111111111111100111111111111111111111111111111
 11111111111111111111111111111111110111111111111111111111111111111
 */

import UIKit
import Themes
import SwiftMessages
import Localize_Swift
import YPImagePicker
import StoreKit

typealias ts = TSSingle
typealias R = TSSingle

struct TSSingle {
    static var color = TSColor()
    static let height = TSHeight()
    static let helper = TSHelper()
    static var global = TSGlobal()
    static let keyboard = TSKeyboardMonitor()
    static let app = TSApp()
    static let http = TSHttp()
    static let timer = TSTimer()
    static let customer = TSCustomer()
    static let database = TSDatabase(name: "AppDatabase")
    static let instruction = TSInstruction()
    // 这里可以添加全局索引
}

struct TSColor {
    var nav = "#d61518".color
    var view = "#fff".color
    var separator = "#f1f1f1".color
    var border = "#cacaca".color
    var darkText = "#333".color
    var text = "#000".color
    var lightText = "#9c9c9c".color
    var container = "#f6f6f6".color
    
    var item: UIColor {
        return (nav.isDark ? "#fff" : "#333").color
    }
    
    var unselect: UIColor {
        return (nav.isDark ? "#f6f6f6" : "#1e1e1e").color
    }
    
    let main = "#d61518".color
    let pink = "#e45838".color
    let red = "#ff0000".color
    let yellow = "#FDEC54".color
    var green = "#189D40".color
    let purple = "#7476ff".color
    let orange = "#fdc724".color
    let cyan = "#1997F9".color
    let gray = "#666".color
    var blue = "#57618D".color
    var lightOrange = "#FFF4CB".color
    var lightGray = "#F7F8FA".color
}

struct TSTheme: Themes.Theme {
    var black = false {
        didSet {
            if black {
                ts.color.nav = "#202020".color
                ts.color.view = "#1e1e1e".color
                ts.color.border = "#4f4f4f".color
                ts.color.separator = "#2b2b2b".color
                ts.color.container = "#161614".color
                ts.color.text = "#fff".color
                ts.color.darkText = "#cacaca".color
                ts.color.lightText = "#909090".color
                ts.color.green = "#00d800".color
                ts.color.blue = "#7983AD".color
                ts.color.lightOrange = "#ffe79e".color
                ts.color.lightGray = "#2a2c2e".color
            } else {
                ts.color.nav = "#d61518".color
                ts.color.view = "#fff".color
                ts.color.border = "#cacaca".color
                ts.color.separator = "#f1f1f1".color
                ts.color.container = "#f6f6f6".color
                ts.color.text = "#000".color
                ts.color.darkText = "#333".color
                ts.color.lightText = "#9c9c9c".color
                ts.color.green = "#189D40".color
                ts.color.blue = "#57618D".color
                ts.color.lightOrange = "#FFF4CB".color
                ts.color.lightGray = "#F7F8FA".color
            }
        }
    }
}

struct TSHeight {
    let navBar = 44.em
    let tabBar = 49.em
}

class TSHelper {
    var theme = TSTheme()
    
    var isPhoneX: Bool {
        return CGFloat.safeBottom > 0
    }
    
    var isPad: Bool {
        let device = UIDevice.current.userInterfaceIdiom
        return device == .pad
    }
    
    var appLink: String {
        return "http://itunes.apple.com/cn/app/id" + ts.app.appStoreId
    }
    
    var reviewLink: String {
        return appLink + "?action=write-review"
    }
    
    var isBlackSkin: Bool {
        return theme.black
    }
    
    var currentLanguage: TSLanguage {
        set {
            switch newValue {
            case .Chinese:
                Localize.setCurrentLanguage("zh-Hans")
            case .English:
                Localize.setCurrentLanguage("en")
            }
        }
        get {
            if Localize.currentLanguage() == "en" {
                return .English
            } else {
                return .Chinese
            }
        }
    }
    
    var isChinsesLanguage: Bool {
        return currentLanguage == .Chinese
    }
    
    var isSignin: Bool {
        return !ts.customer.token.isEmpty
    }
    
    
    var orientation: UIInterfaceOrientationMask = .portrait
    // 设置横竖屏
    func setScreenDirection(_ direction: TSScreenDirection) {
        switch direction {
        case .vertical:
            orientation = .portrait
            let orientationTarget = NSNumber(integerLiteral: UIInterfaceOrientation.portrait.rawValue)
            UIDevice.current.setValue(orientationTarget, forKey: "orientation")
        case .horizontal:
            orientation = .landscapeRight
            let orientationTarget = NSNumber(integerLiteral: UIInterfaceOrientation.landscapeRight.rawValue)
            UIDevice.current.setValue(orientationTarget, forKey: "orientation")
        }
    }
    // 切换皮肤
    func switchTheme() {
        theme.black.toggle()
        ThemeManager.shared.currentTheme = theme
        setCache(key: "appTheme", value: theme.black as NSObject)
    }
    
    func setTheme() {
        if let black = getCache(key: "appTheme")?.value as? Bool {
            theme.black = black
            ThemeManager.shared.currentTheme = theme
        }
    }
    // 选择相册图片
    func selectImage(type: YPPickerScreen, complete: @escaping (UIImage) -> Void) {
        imagePickerConfig.screens = [type]
        let picker = YPImagePicker(configuration: imagePickerConfig)
        picker.didFinishPicking {  [unowned picker] items, cancelled in
            if cancelled {
                picker.dismiss(animated: true, completion: nil)
                return
            }
            if let firstItem = items.first {
                switch firstItem {
                case .photo(let photo):
                    complete(photo.image)
                    picker.dismiss(animated: true, completion: nil)
                default: ()
                }
            }
        }
        ts.global.nav.present(picker, animated: true, completion: nil)
    }
    
    func addAppReview() {
        let alertVC = UIAlertController(title: "喜欢APP 么?给个五星好评吧亲!", message: nil, preferredStyle: .alert)
        let review = UIAlertAction(title: "我要吐槽", style: .default) { (_) in
            if let url = URL(string: self.reviewLink) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        alertVC.addAction(review)
        let noReview = UIAlertAction(title: "用用再说", style: .default, handler: nil)
        alertVC.addAction(noReview)
        if #available(iOS 10.3, *) {
            let fiveStar = UIAlertAction(title: "五星好评", style: .default) { (_) in
                SKStoreReviewController.requestReview()
            }
            alertVC.addAction(fiveStar)
        } 
        DispatchQueue.main.async {
            ts.global.nav.present(alertVC, animated: true, completion: nil)
        }
    }

    let messageView: MessageView
    var imagePickerConfig = YPImagePickerConfiguration()
    
    init() {
        messageView = MessageView.viewFromNib(layout: .statusLine)
        messageView.button?.isHidden = true
        messageView.iconImageView?.isHidden = true
        messageView.iconLabel?.isHidden = true
        messageView.titleLabel?.isHidden = true
        messageView.configureTheme(backgroundColor: R.color.nav, foregroundColor: ts.color.item)
        SwiftMessages.defaultConfig.presentationContext = .window(windowLevel: .statusBar)
        
        imagePickerConfig.library.mediaType = .photo
        imagePickerConfig.showsCrop = .rectangle(ratio: 1)
        imagePickerConfig.hidesStatusBar = false
        imagePickerConfig.library.maxNumberOfItems = 1
        
    }

    // 提示信息
    func showMessage(_ msg: String) {
        messageView.configureContent(body: msg.local)
        SwiftMessages.show(view: messageView)
    }
    // 设置缓存
    func setCache(key: String, value: NSObject) {
        if let cache: AppCache = getCache(key: key) {
            cache.value = value
            cache.time = Date()
        } else {
            let cache: AppCache = ts.database.insert()
            cache.key = key
            cache.value = value
            cache.time = Date()
        }
        ts.database.save()
    }
    // 获取缓存
    func getCache(key: String) -> AppCache? {
        if let cache: AppCache = ts.database.searchOne(condition: "key = '\(key)'") {
            return cache
        }
        return nil
    }
    
    func first(key: String) -> Bool {
        if let _ = getCache(key: key) {
            return false
        }
        setCache(key: key, value: "1" as NSObject)
        return true
    }
    
    func cleanCache() {
        if let allCache: [AppCache] = ts.database.searchAll() {
            for cache in allCache {
                ts.database.delete(object: cache)
            }
        }
    }
    
    // 这里可以添加全局方法
}

struct TSGlobal {
    var nav: UINavigationController!
    var tab: TSTabBarController!
    var window: UIWindow!
    
    // 这里可以添加全局变量
}

struct TSApp {
    let appStoreId = ""
    
    // 这里可以应用版本信息
}
