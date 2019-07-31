//
//  UIWebViewController.swift
//  JunxinSecurity
//
//  Created by mc on 2019/6/6.
//  Copyright © 2019 张玉飞. All rights reserved.
//

import UIKit

class UIWebViewController: TSViewController {

    let webView = UIWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addSubviews(webView)
        webView.snp.makeConstraints {
            $0.top.equalTo(nav.snp.bottom)
            $0.left.bottom.right.equalToSuperview()
        }
        webView.backgroundColor = UIColor.clear
        webView.isOpaque = false
        
        rightItem.title = "关闭"
    }
    
    override func pop() {
        if webView.canGoBack {
            webView.goBack()
        } else {
            super.pop()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if webView.isLoading {
            webView.stopLoading()
        }
    }
    
    func loadWeb(path: String) {
        if let url = URL(string: path) {
            let request = URLRequest(url: url)
            webView.loadRequest(request)
        }
    }

    override func rightItemAction(sender: UIButton) {
        ts.global.nav.popViewController(animated: true)
    }
}
