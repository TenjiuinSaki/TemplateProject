//
//  TSTextField.swift
//  JunxinSecurity
//
//  Created by mc on 2018/10/22.
//  Copyright © 2018 张玉飞. All rights reserved.
//

import UIKit

enum TSInputType {
    case password
    case phone
    case num
    case none
}

class TSTextField: UITextField, UITextFieldDelegate {
    var type: TSInputType = .none {
        didSet {
            switch type {
            case .phone:
                keyboardType = .numberPad
            case .password:
                isSecureTextEntry = true
            case .num:
                keyboardType = .numbersAndPunctuation
            default:
                ()
            }
        }
    }
    
    override var textColor: UIColor? {
        didSet {
            tintColor = textColor
        }
    }
    
    var inset: CGFloat = 0 {
        didSet {
            leftView = UIView(frame: CGRect(x: 0, y: 0, width: inset, height: 1))
        }
    }
    
    func border(color: UIColor) {
        border(color: color, width: 0.5)
        corner = 2
        inset = 12
        font = 14.light
    }
    
    convenience init() {
        self.init(frame: .zero)
        textColor = R.color.text
        font = 15.light
        returnKeyType = .done
        delegate = self
        leftViewMode = .always
    }
    
    convenience init(placeholder: String) {
        self.init()
        setPlaceHolder(placeholder, with: ts.color.lightText)
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.isEmpty {
            return true
        } else {
            switch type {
            case .password:
//                return string.isMatch(to: "\\w")
                return true
            case .phone:
                return string.isMatch(to: "\\d")
            case .num:
                if let text = textField.text {
                    return !(text + string).double.isNaN
                }
                return !string.double.isNaN
            case .none:
                return true
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

