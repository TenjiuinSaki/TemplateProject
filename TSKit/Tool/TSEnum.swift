//
//  TSEnum.swift
//  TSKit
//
//  Created by mc on 2018/10/12.
//  Copyright © 2018 张玉飞. All rights reserved.
//

import UIKit

enum TSNotice: String {
    case everyTimer
    case language = "LCLLanguageChangeNotification"
    case keyboard
    case click
    case complete
    case fail
    case market
    case repay
    case order
    case revoke
    case share
    case gold
    case adjust
}

enum TSScreenDirection {
    case vertical
    case horizontal
}

enum TSLanguage: String, CaseIterable {
    case Chinese = "简体中文"
    case English = "English"
}

// 这里添加全局枚举
