//
//  TSAlertView.swift
//  JunxinSecurity
//
//  Created by mc on 2018/11/1.
//  Copyright © 2018 张玉飞. All rights reserved.
//

import UIKit

class TSAlertView: TSCoverView {

    let contentView = TSView()
    
    convenience init(size: CGSize) {
        self.init()
        
        addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-80.em)
            $0.size.equalTo(size)
        }
        contentView.corner = 4.em
        contentView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        
        viewDidLoad()
    }
    
    func viewDidLoad() {
        
    }
    
    override func moveDown() {
        super.moveDown()
        contentView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
    }
    
    override func moveUp() {
        super.moveUp()
        contentView.transform = .identity
    }
}
