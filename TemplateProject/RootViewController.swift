//
//  RootViewController.swift
//  TemplateProject
//
//  Created by TenjiuinSaki on 2019/7/31.
//  Copyright © 2019 张玉飞. All rights reserved.
//

import UIKit

class RootViewController: TSTabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewControllers = [
            ViewController1(),
            ViewController2(),
            ViewController3(),
            ViewController4(),
            ViewController5()
        ]
        
        items = [
            TSTabBarItem(image: TSAssets.star.image, text: "tab1"),
            TSTabBarItem(image: TSAssets.star.image, text: "tab2"),
            TSTabBarItem(image: TSAssets.star.image, text: "tab3"),
            TSTabBarItem(image: TSAssets.star.image, text: "tab4"),
            TSTabBarItem(image: TSAssets.star.image, text: "tab5")
        ]
    }

}
