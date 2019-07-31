//
//  TSSearchBar.swift
//  JunxinSecurity
//
//  Created by mc on 2018/11/22.
//  Copyright © 2018 张玉飞. All rights reserved.
//

import UIKit

protocol TSSearchDelegate: NSObjectProtocol {
    func updateSearch(key: String)
}
class TSSearchBar: TSView, UITextFieldDelegate {
    
    let textField = TSTextField()
    private let icon = TSImageView()
    private let place = TSLabel()
    weak var delegate: TSSearchDelegate?
    
    var font: UIFont? {
        didSet {
            textField.font = font
            place.font = font
        }
    }
    var placeholder: String? {
        didSet {
            place.words = placeholder
        }
    }
    
    override func onInit() {
        corner = 15.em
        addSubviews(textField, icon, place)
        
        textField.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        textField.font = 14.light
        textField.returnKeyType = .search
        textField.delegate = self
        textField.inset = 30.em
        
        place.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.centerX.equalToSuperview().offset(5.em)
        }
        place.color = R.color.lightText
        place.font = 14.light
        
        icon.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalTo(place.snp.left).offset(-6.em)
            $0.width.height.equalTo(17.em)
        }
        icon.setShape(.image_search)
        icon.color = R.color.lightText
        
        textField.addObserver(self, forKeyPath: #keyPath(UITextField.text), options: [.new, .old], context: nil)
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        UIView.animate(withDuration: 0.2, animations: beginEdit)
        
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        UIView.animate(withDuration: 0.2, animations: endEditing)
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var text = textField.text ?? ""
        if string.isEmpty {
            if text.isEmpty {
               return true
            } else {
                text.removeLast()
            }
        } else {
            text += string
        }
        place.isHidden = !text.isEmpty
        
        delegate?.updateSearch(key: text)
        
        return true
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        let text = textField.text ?? ""
        place.isHidden = text.count > 0
        
        delegate?.updateSearch(key: text)
    }
    
    func beginEdit() {
        if let text = textField.text, text.count > 0  {
            return
        }
        
        icon.snp.remakeConstraints {
            $0.left.equalTo(8.em)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(17.em)
        }
        
        place.snp.remakeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(icon.snp.right).offset(6.em)
        }
        
        layoutIfNeeded()
    }
    
    func endEditing() {
        if let text = textField.text, text.count > 0  {
            return
        }
        
        place.snp.remakeConstraints {
            $0.centerY.equalToSuperview()
            $0.centerX.equalToSuperview().offset(5.em)
        }
        
        icon.snp.remakeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalTo(place.snp.left).offset(-6.em)
            $0.width.height.equalTo(17.em)
        }
        
        layoutIfNeeded()
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 300.em, height: 30.em)
    }
}



