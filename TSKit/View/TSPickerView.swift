//
//  TSPickerView.swift
//  JunxinSecurity
//
//  Created by mc on 2018/11/15.
//  Copyright © 2018 张玉飞. All rights reserved.
//

import UIKit
protocol TSPickerViewDelegate: NSObjectProtocol {
    func didSelected(item: String, at row: Int)
}

class TSPickerView: TSAlertView, UIPickerViewDelegate, UIPickerViewDataSource {
    let pickerView = UIPickerView()
    
    weak var delegate: TSPickerViewDelegate?
    var items = [String]() {
        didSet {
            pickerView.reloadAllComponents()
            pickerView.selectRow(0, inComponent: 0, animated: false)
        }
    }
    
    override func viewDidLoad() {
        let cancelBtn = TSButton()
        let confirmBtn = TSButton()
        let btnStack = [cancelBtn, confirmBtn].stack()
        let view = TSView()
        
        contentView.addSubviews(view, btnStack)
        
        btnStack.snp.makeConstraints {
            $0.height.equalTo(50.em)
            $0.bottom.centerX.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.55)
        }
        
        view.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(10.em)
            $0.bottom.equalTo(btnStack.snp.top).offset(-8.em)
        }
        view.addSubview(pickerView)
        view.clipsToBounds = true
        
        pickerView.snp.makeConstraints {
            $0.center.width.equalToSuperview()
            $0.height.equalTo(1000)
        }
        pickerView.dataSource = self
        pickerView.delegate = self
        
        cancelBtn.title = "取消"
        cancelBtn.color = R.color.darkText
        cancelBtn.font = 17.light
        cancelBtn.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        
        confirmBtn.title = "确定"
        confirmBtn.color = R.color.main
        confirmBtn.font = 17.light
        confirmBtn.addTarget(self, action: #selector(confirmAction), for: .touchUpInside)
    }
    
    @objc func confirmAction() {
        let row = pickerView.selectedRow(inComponent: 0)
        if items.count > row {
            delegate?.didSelected(item: items[row], at: row)
        }
        dismiss()
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return items.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40.em
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        // 设置分割线的颜色
        for subview in pickerView.subviews {
            if subview.height < 1 {
                subview.backgroundColor = ts.color.separator
            }
        }
        
        // 设置文字的属性
        let label = TSLabel(text: items[row])
        label.font = 18.light
        label.color = ts.color.text
        return label
    }
}
