//
//  TSRightItemOption.swift
//  JunxinSecurity
//
//  Created by mc on 2018/11/28.
//  Copyright © 2018 张玉飞. All rights reserved.
//

import UIKit

struct TSItemOption {
    let image: TSAssets
    let title: String
}
class TSRightItemOption: TSCoverView, UITableViewDelegate {
    private let flowView = TSFlowView()

    weak var delegate: TSActionDelegate?
    var options = [TSItemOption]()
    convenience init(options: [TSItemOption]) {
        self.init()
        dismissBtn.clearColor()
        
        self.options = options
        
        addSubview(flowView)
        flowView.isScrollEnabled = false
        flowView.delegate = self
        flowView.rowHeight = 46.em
        flowView.snp.makeConstraints {
            $0.top.equalTo(ts.height.navBar + .statusBar)
            $0.right.equalTo(-12.em)
            $0.width.equalTo(155.em)
            $0.height.equalTo((46 * options.count).em)
        }
        flowView.shadow(color: ts.color.text)
        flowView.alpha = 0
        
        for option in options {
            let flow = JSItemOptionFlow()
            flow.title.words = option.title
            flow.icon.setShape(option.image)
            flowView.views.append(flow)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelect(action: options[indexPath.row].title, index: indexPath.row)
        dismiss()
    }
    
    override func moveDown() {
        super.moveDown()
        flowView.alpha = 0
    }
    
    override func moveUp() {
        super.moveUp()
        flowView.alpha = 1
    }
}

class JSItemOptionFlow: TSFlow {
    let icon = TSImageView()
    let title = TSLabel()
    
    override func onInit() {
        addSubviews(icon, title)
        
        icon.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.width.height.equalTo(15.em)
        }
        icon.color = R.color.darkText
        
        title.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(icon.snp.right).offset(10.em)
        }
        title.color = R.color.darkText
    }
}
