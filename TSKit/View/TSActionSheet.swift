//
//  CSActionSheet.swift
//  NewJunXinSecurities
//
//  Created by mc on 2018/7/19.
//  Copyright © 2018年 celjy.com. All rights reserved.
//

import UIKit

class TSCoverView: TSView {
    let dismissBtn = TSButton()
    
    override func onInit() {
        color = UIColor.clear
        addSubview(dismissBtn)
        dismissBtn.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        dismissBtn.backgroundColor = UIColor.black.withAlphaComponent(0.25)
        dismissBtn.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        dismissBtn.alpha = 0
    }
    
    func present() {
        ts.global.window.addSubview(self)
        snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        UIView.animate(withDuration: 0.15, animations: moveUp)
    }
    
    @objc
    func dismiss() {
        UIView.animate(withDuration: 0.15, animations: moveDown) { (_) in
            self.removeFromSuperview()
        }
    }
    
    func moveDown() {
        dismissBtn.alpha = 0
    }
    
    func moveUp() {
        dismissBtn.alpha = 1
    }
}

protocol TSActionDelegate: NSObjectProtocol {
    func didSelect(action: String, index: Int)
}

class TSActionSheet: TSCoverView, UITableViewDelegate {
    
    private let sheetView = TSFlowView()
    
    weak var delegate: TSActionDelegate?
    var sheetHeight: CGFloat = 0
    var actions = [String]()
    convenience init(actions: [String]) {
        self.init()

        self.actions = actions
        addSubview(sheetView)
        
        sheetView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0.1))
        sheetView.isScrollEnabled = false
        sheetView.delegate = self
        sheetView.backgroundColor = ts.color.container

        for action in actions {
            let flow = TSActionSheetFlow()
            flow.title.words = action
            sheetView.views.append(flow)
        }
        
        sheetView.views.append(.space)
        
        let cancelView = TSActionSheetFlow()
        cancelView.title.words = "取消"
        sheetView.views.append(cancelView)
        
        sheetHeight = 50.em * (actions.count + 1).cgfloat + 7.em
        sheetHeight += .safeBottom
        sheetView.snp.makeConstraints {
            $0.left.bottom.right.equalToSuperview()
            $0.height.equalTo(sheetHeight)
        }
        sheetView.transform = CGAffineTransform(translationX: 0, y: sheetHeight)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < actions.count {
            delegate?.didSelect(action: actions[indexPath.row], index: indexPath.row)
        }
        dismiss()
    }
    
    override func moveDown() {
        super.moveDown()
        sheetView.transform = CGAffineTransform(translationX: 0, y: sheetHeight)
    }
    
    override func moveUp() {
        super.moveUp()
        sheetView.transform = .identity
    }
}

class TSActionSheetFlow: TSFlow {

    let title = TSLabel()
    
    override func onInit() {
        addSubview(title)
        title.snp.makeConstraints {
            $0.center.top.equalToSuperview()
            $0.height.equalTo(50.em)
        }
        title.font = 15.light
        title.textColor = R.color.darkText
    }

}
