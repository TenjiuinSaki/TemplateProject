//
//  MainWindow.swift
//  TemplateProject
//
//  Created by TenjiuinSaki on 2019/7/31.
//  Copyright © 2019 张玉飞. All rights reserved.
//

import UIKit

class MainWindow: UIWindow {

    convenience init() {
        self.init(frame: UIScreen.main.bounds)
        // 设置为之前的主题
        ts.helper.setTheme()
        backgroundColor = ts.color.view
        makeKeyAndVisible()
        
        use(TSTheme.self) { (ref, _) in
            ref.backgroundColor = ts.color.view
        }
        
        ts.helper.currentLanguage = .Chinese

        let tab = RootViewController()
        let nav = TSNavigationController(rootViewController: tab)
        
        rootViewController = nav
        // 记录主window
        ts.global.window = self
        // 记录根视图
        ts.global.nav = nav
        ts.global.tab = tab
        
        // 这里可以设置启动项
    }
}
