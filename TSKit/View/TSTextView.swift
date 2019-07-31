//
//  CSTextView.swift
//  NewJunXinSecurities
//
//  Created by mc on 2018/7/23.
//  Copyright © 2018年 celjy.com. All rights reserved.
//

import UIKit

class TSTextView: TSView, UITextViewDelegate {
    var placeholder = "" {
        didSet {
            place.words = placeholder
        }
    }
    var maxLength = -1 {
        didSet {
            length.text = maxLength.string
        }
    }
    
    private let place = TSLabel()
    private let length = TSLabel()
    private let textView = UITextView()
    
    var text: String {
        return textView.text
    }
    
    var font: UIFont? {
        didSet {
            textView.font = font
            place.font = font
            length.font = font
        }
    }
    
    var inset: (left: CGFloat, top: CGFloat) = (0, 0) {
        didSet {
            textView.snp.remakeConstraints {
                $0.center.equalToSuperview()
                $0.width.equalToSuperview().inset(inset.left)
                $0.height.equalToSuperview().inset(inset.top)
            }
            
            place.snp.remakeConstraints {
                $0.top.equalTo(8 + inset.top)
                $0.left.equalTo(5 + inset.left)
            }
        }
    }
    
    override func onInit() {
        addSubviews(textView, place, length)
        textView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        textView.delegate = self
        textView.textColor = R.color.text
        textView.tintColor = R.color.text
        textView.returnKeyType = .done
        textView.clearColor()
        
        place.snp.makeConstraints {
            $0.top.equalTo(8)
            $0.left.equalTo(5)
        }
        place.text = placeholder
        place.textColor = R.color.lightText
        
        length.snp.makeConstraints {
            $0.bottom.right.equalTo(-8.em)
        }
    }

    func textViewDidChange(_ textView: UITextView) {
        place.isHidden = !textView.text.isEmpty
        if maxLength >= 0 {
            length.text = "\(textView.text.count)/\(maxLength)"
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text.isEmpty {
            return true
        }
        if text == "\n" {
            textView.resignFirstResponder()
        }
        if maxLength < 0 {
            return true
        } else if textView.text.count >= maxLength {
            length.text = "已达到输入上限"
            return false
        }
        return true
    }
    
}
