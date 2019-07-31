//
//  ViewController.swift
//  TemplateProject
//
//  Created by TenjiuinSaki on 2019/7/31.
//  Copyright © 2019 张玉飞. All rights reserved.
//

import UIKit

class ViewController1: TSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navColor = UIColor.red
        title = "tab1"
        
        rightItem.title = "下一页"
    }
    
    override func rightItemAction(sender: UIButton) {
        SubViewController.go()
    }
}

class ViewController2: TSViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navColor = UIColor.orange
        title = "tab2"
    }
}

class ViewController3: TSViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navColor = UIColor.green
        title = "tab3"
    }
}

class ViewController4: TSViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navColor = UIColor.cyan
        title = "tab4"
    }
}


class ViewController5: TSViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navColor = UIColor.purple
        title = "tab5"
    }
}

class SubViewController: TSViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navColor = UIColor.magenta
        title = "子页面"
    }
}
