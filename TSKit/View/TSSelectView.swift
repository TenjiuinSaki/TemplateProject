//
//  TSSelectView.swift
//  JunxinSecurity
//
//  Created by mc on 2018/11/7.
//  Copyright © 2018 张玉飞. All rights reserved.
//

import UIKit

protocol TSSelectViewDelegate: NSObjectProtocol {
    func didSelect(view: TSSelectView, item: String)
}

class TSSelectView: TSView, TSPickerViewDelegate {

    let item = TSLabel()
    let arrow = TSImageView()
    let picker = TSPickerView(size: CGSize(width: 300.em, height: 300.em))
    weak var delegate: TSSelectViewDelegate?
    var items = [String]() {
        didSet {
            selectedItem = items.first ?? ""
            picker.items = items
        }
    }
    var selectedItem = "" {
        didSet {
            item.text = selectedItem
            item.textColor = R.color.darkText
        }
    }
    
    var placeholder = "" {
        didSet {
            selectedItem = ""
            item.text = placeholder
            item.textColor = R.color.lightText
        }
    }
    
    let selectView = TSView()
    
    var isSelecting = false {
        didSet {
            if isSelecting {
                openSelectItems()
            } else {
                closeSelectItems()
            }
        }
    }
    override func onInit() {
        border(color: ts.color.lightText, width: 0.5)
        corner = 2
        
        addSubviews(item, arrow)
        item.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(12.em)
            $0.right.equalTo(arrow.snp.left)
        }
        item.font = 14.light
        item.leftAlignment()
        
        arrow.snp.makeConstraints {
            $0.right.equalTo(-12.em)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(12.em)
        }
        arrow.setImage(.angle_down)
        arrow.contentMode = .center
    
        picker.delegate = self
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapAction)))
    }
    
    func didSelected(item: String, at row: Int) {
        selectedItem = item
        isSelecting = false
        delegate?.didSelect(view: self, item: item)
    }
    
    @objc func tapAction() {
        isSelecting.toggle()
    }

    func openSelectItems() {
        picker.present()
    }
    
    func closeSelectItems() {
        picker.dismiss()
    }
}

class TSItemListCell: TSListCell {
    let item = TSLabel()
    
    override func onSetData() {
        if let text = list.data as? String {
            item.text = text
        }
    }
    override func onInit() {
        addSubview(item)
        
        item.snp.makeConstraints {
            $0.centerY.top.equalToSuperview()
            $0.height.equalTo(44.em)
            $0.left.equalTo(15.em)
        }
        item.textColor = ts.color.darkText
    }
}
