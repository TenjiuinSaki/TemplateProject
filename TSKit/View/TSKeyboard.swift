//
//  TSKeyboard.swift
//  JunxinSecurity
//
//  Created by mc on 2018/10/22.
//  Copyright © 2018 张玉飞. All rights reserved.
//

import UIKit

enum TSKey {
    case backspace
    case exit
    case clear
    case done
    case alphabet
    case num
    case input(String)
    case empty  // 空白占位键
    case half   // 半个空白占位键
    case space
}

class TSKeyGridCell: TSGridCell {
    let title = TSLabel()
    
    override func onSetData() {
        if let key = grid.data as? TSKey {
            switch key {
            case .backspace:
                title.words = "删除"
            case .exit:
                title.words = "隐藏"
            case .clear:
                title.words = "清除"
            case .done:
                title.words = "确定"
            case .alphabet:
                title.text = "ABC"
            case .num:
                title.text = "123"
            case .input(let text):
                title.text = text
            default:
                ()
            }
            
            switch key {
            case .input:
                ()
            case .half, .empty, .space:
                color = UIColor.clear
            default:
                color = ts.color.border
            }
        }
    }
    override func onInit() {
        addSubviews(title)
        
        title.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        corner = 3.em
    }
    
    override func didSelect() {
        if let key = grid.data as? TSKey {
            sendNotice(.keyboard, obj: key)
        }
    }
}
class TSKeyboard: TSView {

    weak var textField: UITextField?
    let numGrid = TSGridView()
    let alphabetGrid = TSGridView()
    let prefixGrid = TSGridView()
    
    override func onInit() {
        let keyboardHeight = 220.em
        frame = CGRect(x: 0, y: 0, width: .width, height: keyboardHeight + .safeBottom + 5.em)
        color = ts.color.container
        
        let boardView = UIView()
        boardView.addSubviews(numGrid, prefixGrid, alphabetGrid)
        
        addSubviews(boardView)
        
        boardView.snp.makeConstraints {
            $0.top.bottom.centerX.equalToSuperview()
            $0.width.equalTo(375.em)
        }
        
        prefixGrid.snp.makeConstraints {
            $0.left.top.equalTo(5.em)
            $0.width.equalTo(75.em)
            $0.height.equalTo(keyboardHeight)
        }
        
        numGrid.snp.makeConstraints {
            $0.right.equalToSuperview()
            $0.top.equalTo(5.em)
            $0.height.equalTo(keyboardHeight)
            $0.left.equalTo(prefixGrid.snp.right)
        }
        
        alphabetGrid.snp.makeConstraints {
            $0.right.equalToSuperview()
            $0.left.top.equalTo(5.em)
            $0.height.equalTo(keyboardHeight)
        }
        
        setNumKeyboard()
        setPrefixboard()
        setAlphabetKeyboard()
        switchToNum()
        
        receiveNotice(.keyboard, action: #selector(tapKey(not:)))
    }
    
    func apply(to textField: UITextField) {
        self.textField = textField
        textField.inputView = self
    }
    
    deinit {
        rejectNotice()
        debugPrint("键盘释放了")
    }
    
    @objc func tapKey(not: Notification) {
        guard let key = not.object as? TSKey,
            let textField = textField
        else {
            return
        }
        
        var currentText = textField.text ?? ""
        switch key {
        case .alphabet:
            switchToAlphabet()
        case .num:
            switchToNum()
        case .input(let text):
            textField.text = currentText + text
        case .backspace:
            if currentText.count > 0 {
                currentText.removeLast()
                textField.text = currentText
            }
        case .clear:
            textField.text = ""
        case .exit, .done:
            textField.resignFirstResponder()
        default:
            ()
        }
    }

    
    func switchToNum() {
        numGrid.isHidden = false
        prefixGrid.isHidden = false
        alphabetGrid.isHidden = true
    }
    
    func switchToAlphabet() {
        numGrid.isHidden = true
        prefixGrid.isHidden = true
        alphabetGrid.isHidden = false
    }
    
    func setNumKeyboard() {
        numGrid.color = UIColor.clear
        numGrid.itemHeight = 50.em
        numGrid.spacing = 5.em
        numGrid.register(TSKeyGridCell.self, forCellWithReuseIdentifier: "cell")
        
        let keys: [TSKey] = [
            .input("1"), .input("2"), .input("3"), .backspace,
            .input("4"), .input("5"), .input("6"), .exit,
            .input("7"), .input("8"), .input("9"), .clear,
            .alphabet, .input("0"), .empty, .done,
            ]
        for key in keys {
            let grid = TSGrid(data: key as AnyObject, identifier: "cell", width: 68.em)
            numGrid.grids.append(grid)
        }
        numGrid.reloadData()
    }
    
    func setPrefixboard() {
        prefixGrid.color = UIColor.clear
        prefixGrid.itemHeight = 40.em
        prefixGrid.spacing = 4.em
        prefixGrid.register(TSKeyGridCell.self, forCellWithReuseIdentifier: "cell")
        
        let keys: [TSKey] = [
            .input("600"), .input("601"), .input("000"),
            .input("300"), .input("002")
            ]
        for key in keys {
            let grid = TSGrid(data: key as AnyObject, identifier: "cell", width: 65.em)
            prefixGrid.grids.append(grid)
        }
        prefixGrid.reloadData()
    }
    
    func setAlphabetKeyboard() {
        alphabetGrid.color = UIColor.clear
        alphabetGrid.itemHeight = 50.em
        alphabetGrid.spacing = 5.em
        alphabetGrid.register(TSKeyGridCell.self, forCellWithReuseIdentifier: "cell")
        
        let keys: [TSKey] = [
            .input("Q"), .input("W"), .input("E"), .input("R"),
            .input("T"), .input("Y"), .input("U"), .input("I"),
            .input("O"), .input("P"), .half, .input("A"), .input("S"),
            .input("D"), .input("F"), .input("G"), .input("H"),
            .input("J"), .input("K"), .input("L"), .num,
            .input("Z"), .input("X"), .input("C"), .input("V"),
            .input("B"), .input("N"), .input("M"), .backspace,
            .clear, .space, .done
        ]
        for key in keys {
            var keyWidth = 32.em
            switch key {
            case .half:
                keyWidth = 16.em
            case .num:
                keyWidth = 44.em
            case  .backspace:
                keyWidth = 56.em
            case .done, .clear:
                keyWidth = 70.em
            case .space:
                keyWidth = 215.em
            default:
                ()
            }
            let grid = TSGrid(data: key as AnyObject, identifier: "cell", width: keyWidth)
            alphabetGrid.grids.append(grid)
        }
        alphabetGrid.reloadData()
    }
    
}
