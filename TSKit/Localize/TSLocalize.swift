//
//  TSLocalize.swift
//  JunxinSecurity
//
//  Created by mc on 2018/11/2.
//  Copyright © 2018 张玉飞. All rights reserved.
//

protocol TSLocalize {
    func setLocalizeText()
}

extension String {
    var local: String {
        return localized(using: nil, in: .main)
    }
    
    var supLocal: String {
        return localized(using: "Supplement")
    }
}
