//
//  TSKeyBoardMonitor.swift
//  JunxinSecurity
//
//  Created by mc on 2018/10/26.
//  Copyright © 2018 张玉飞. All rights reserved.
//

import UIKit

protocol TSKeyboardDelegate: NSObjectProtocol {
    /// 当弹出键盘时
    func willShowKeyboard(keyboardHeight: CGFloat)
    
    /// 当收起键盘时
    func willHideKeyboard()
}

class TSKeyboardMonitor {
    weak var delegate: TSKeyboardDelegate?
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(willShowKeyboard(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(willHideKeyboard(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc
    func willShowKeyboard(notification: Notification) {
        
        guard let userInfo = notification.userInfo,
            let frame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
            let curve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt,
            let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else {
                return
        }
        
        func animations() {
            delegate?.willShowKeyboard(keyboardHeight: frame.cgRectValue.height)
        }
        
        UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions.init(rawValue: curve), animations: animations, completion: nil)
        
        
    }
    @objc
    func willHideKeyboard(notification: Notification) {
        guard let userInfo = notification.userInfo,
            let curve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt,
            let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else {
                return
        }
        
        func animations() {
            delegate?.willHideKeyboard()
        }
        UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions.init(rawValue: curve), animations: animations, completion: nil)
    }
}
