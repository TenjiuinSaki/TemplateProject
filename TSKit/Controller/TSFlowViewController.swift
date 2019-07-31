//
//  TSFlowViewController.swift
//  JunxinSecurity
//
//  Created by mc on 2018/11/27.
//  Copyright © 2018 张玉飞. All rights reserved.
//

import UIKit

class TSFlowViewController: TSViewController {

    let flowView = TSFlowView()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addTableView(flowView)
        setFlowViews()
    }

    func setFlowViews() {}
}
