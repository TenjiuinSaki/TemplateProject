//
//  TSWebViewController.swift
//  JunxinStock
//
//  Created by mc on 2018/12/13.
//  Copyright © 2018 张玉飞. All rights reserved.
//

import UIKit
import WebKit

protocol TSWebViewDelgate: NSObjectProtocol {
    func shouldChange(url: URL) -> Bool
    func shouldOpen(url: URL) -> Bool
    func didFinishLoad()
}
class TSWebViewController: TSViewController {
    let webView = WKWebView()
    weak var delegate: TSWebViewDelgate?
    var link: CADisplayLink?
    let progressLayer = CAGradientLayer()
    var progress: CGFloat = 1 {
        didSet {
            if progress >= 1 {
                progressLayer.isHidden = true
            } else {
                progressLayer.isHidden = false
                progressLayer.frame = CGRect(x: 0, y: nav.height - 5, width: .width * progress, height: 3)
            }
        }
    }
    
    override func pop() {
        if webView.canGoBack {
            webView.goBack()
        } else {
            super.pop()
        }
    }
    
//    @objc func closeAction() {
//        ts.global.nav.popViewController(animated: true)
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        WKWebsiteDataStore.default().removeData(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(), modifiedSince: Date(timeIntervalSince1970: 0)) {
            print("清除成功")
        }
        
        addSubviews(webView)
        webView.snp.makeConstraints {
            $0.top.equalTo(nav.snp.bottom)
            $0.left.bottom.right.equalToSuperview()
        }
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        webView.backgroundColor = UIColor.clear
        webView.isOpaque = false
        
        progressLayer.colors = [R.color.main.cgColor, R.color.view.cgColor]
        progressLayer.startPoint = CGPoint.zero
        progressLayer.endPoint = CGPoint(x: 1, y: 0)
        progressLayer.cornerRadius = 1.5
        progressLayer.masksToBounds = true
        nav.layer.addSublayer(progressLayer)
        
//        let closeItem = TSButtonItem()
//        nav.addLeftItems(closeItem)
//        closeItem.setShape(.btn_close)
//        closeItem.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        
        rightItem.title = "关闭"
    }
    
    override func rightItemAction(sender: UIButton) {
        ts.global.nav.popViewController(animated: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        finishProgress()
        
        if webView.isLoading {
            webView.stopLoading()
        }
    }
    
    func beginProgress() {
        link = CADisplayLink(target: self, selector: #selector(updateProgress))
        link?.add(to: .current, forMode: .common)
    }
    @objc
    func updateProgress() {
        progress = CGFloat(webView.estimatedProgress)
    }
    func finishProgress() {
        link?.invalidate()
        link = nil
        progress = 1
    }
    func loadLocalWeb(path: String) {
        if let path = Bundle.main.path(forResource: path, ofType: "html") {
            let url = URL(fileURLWithPath: path)
            webView.load(URLRequest(url: url))
            
            beginProgress()
        }
    }
    
    func loadWeb(path: String) {
        if let url = URL(string: path) {
            let request = URLRequest(url: url)
            webView.load(request)
            
            beginProgress()
        }
    }
}

extension TSWebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        finishProgress()
        if title == nil {
            title = webView.title
        }
        
        delegate?.didFinishLoad()
    }
    //    跳转链接 在当前窗口打开
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url {
            if let delegate = delegate,
                !delegate.shouldChange(url: url) {
                decisionHandler(.cancel)
                return
            }
        }
        decisionHandler(.allow)
    }
    
    //跳转链接 在新窗口打开
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if let url = navigationAction.request.url {
            if let delegate = delegate,
                !delegate.shouldOpen(url: url) {
                return nil
            }
            let web = TSWebViewController()
            web.loadWeb(path: url.absoluteString)
            web.push()
        }
        return nil
    }
}
extension TSWebViewController: WKUIDelegate {
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alertCtrl = UIAlertController(title: "提示", message: message, preferredStyle: .alert)
        alertCtrl.addAction(UIAlertAction(title: "确定", style: .default, handler: { (_) in
            completionHandler()
        }))
        present(alertCtrl, animated: true, completion: nil)
    }
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        let alertCtrl = UIAlertController(title: "提示", message: message, preferredStyle: .alert)
        alertCtrl.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { (_) in
            completionHandler(false)
        }))
        alertCtrl.addAction(UIAlertAction(title: "确定", style: .default, handler: { (_) in
            completionHandler(true)
        }))
        present(alertCtrl, animated: true, completion: nil)
    }
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        let alertCtrl = UIAlertController(title: prompt, message: nil, preferredStyle: .alert)
        alertCtrl.addTextField { (textField) in
            textField.text = defaultText
        }
        alertCtrl.addAction(UIAlertAction(title: "确定", style: .default, handler: { (_) in
            completionHandler(alertCtrl.textFields![0].text)
        }))
        present(alertCtrl, animated: true, completion: nil)
    }
}
