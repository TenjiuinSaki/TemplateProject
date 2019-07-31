//
//  TSViewController.swift
//  TSKit
//
//  Created by mc on 2018/8/20.
//  Copyright © 2018年 张玉飞. All rights reserved.
//
/**
 *            .,,       .,:;;iiiiiiiii;;:,,.     .,,
 *          rGB##HS,.;iirrrrriiiiiiiiiirrrrri;,s&##MAS,
 *         r5s;:r3AH5iiiii;;;;;;;;;;;;;;;;iiirXHGSsiih1,
 *            .;i;;s91;;;;;;::::::::::::;;;;iS5;;;ii:
 *          :rsriii;;r::::::::::::::::::::::;;,;;iiirsi,
 *       .,iri;;::::;;;;;;::,,,,,,,,,,,,,..,,;;;;;;;;iiri,,.
 *    ,9BM&,            .,:;;:,,,,,,,,,,,hXA8:            ..,,,.
 *   ,;&@@#r:;;;;;::::,,.   ,r,,,,,,,,,,iA@@@s,,:::;;;::,,.   .;.
 *    :ih1iii;;;;;::::;;;;;;;:,,,,,,,,,,;i55r;;;;;;;;;iiirrrr,..
 *   .ir;;iiiiiiiiii;;;;::::::,,,,,,,:::::,,:;;;iiiiiiiiiiiiri
 *   iriiiiiiiiiiiiiiii;;;::::::::::::::::;;;iiiiiiiiiiiiiiiir;
 *  ,riii;;;;;;;;;;;;;:::::::::::::::::::::::;;;;;;;;;;;;;;iiir.
 *  iri;;;::::,,,,,,,,,,:::::::::::::::::::::::::,::,,::::;;iir:
 * .rii;;::::,,,,,,,,,,,,:::::::::::::::::,,,,,,,,,,,,,::::;;iri
 * ,rii;;;::,,,,,,,,,,,,,:::::::::::,:::::,,,,,,,,,,,,,:::;;;iir.
 * ,rii;;i::,,,,,,,,,,,,,:::::::::::::::::,,,,,,,,,,,,,,::i;;iir.
 * ,rii;;r::,,,,,,,,,,,,,:,:::::,:,:::::::,,,,,,,,,,,,,::;r;;iir.
 * .rii;;rr,:,,,,,,,,,,,,,,:::::::::::::::,,,,,,,,,,,,,:,si;;iri
 *  ;rii;:1i,,,,,,,,,,,,,,,,,,:::::::::,,,,,,,,,,,,,,,:,ss:;iir:
 *  .rii;;;5r,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,sh:;;iri
 *   ;rii;:;51,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,.:hh:;;iir,
 *    irii;::hSr,.,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,.,sSs:;;iir:
 *     irii;;:iSSs:.,,,,,,,,,,,,,,,,,,,,,,,,,,,..:135;:;;iir:
 *      ;rii;;:,r535r:...,,,,,,,,,,,,,,,,,,..,;sS35i,;;iirr:
 *       :rrii;;:,;1S3Shs;:,............,:is533Ss:,;;;iiri,
 *        .;rrii;;;:,;rhS393S55hh11hh5S3393Shr:,:;;;iirr:
 *          .;rriii;;;::,:;is1h555555h1si;:,::;;;iirri:.
 *            .:irrrii;;;;;:::,,,,,,,,:::;;;;iiirrr;,
 *               .:irrrriiiiii;;;;;;;;iiiiiirrrr;,.
 *                  .,:;iirrrrrrrrrrrrrrrrri;:.
 *                        ..,:::;;;;:::,,.
 */

import UIKit

class TSViewController: UIViewController {
    
    let nav = TSNavBar()
    
    lazy var leftItem: TSButtonItem = {
        let item = TSButtonItem()
        nav.addLeftItems(item)
        item.addTarget(self, action: #selector(leftItemAction(sender:)), for: .touchUpInside)
        return item
    }()
    
    lazy var rightItem: TSButtonItem = {
        let item = TSButtonItem()
        nav.addRightItems(item)
        item.addTarget(self, action: #selector(rightItemAction(sender:)), for: .touchUpInside)
        return item
    }()
    
    lazy var backItem: TSButtonItem = {
        let item = TSButtonItem()
        nav.addLeftItems(item)
        item.setShape(.btn_back)
        item.addTarget(self, action: #selector(pop), for: .touchUpInside)
        return item
    }()
    
    override var title: String? {
        didSet {
            nav.titleLabel.words = title
        }
    }
    
    var navColor: UIColor {
        set {
            nav.color = newValue
            setNeedsStatusBarAppearanceUpdate()
        }
        get {
            return nav.color
        }
    }
    
    var isTransparentNav = false {
        didSet {
            if isTransparentNav {
                navColor = UIColor.clear
            }
        }
    }
    
    var isContainer = true {
        didSet {
            setBackgroundColor()
        }
    }
    
    func setBackgroundColor() {
        if isContainer {
            color = ts.color.container
        } else {
            color = ts.color.view
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.clipsToBounds = true
        setBackgroundColor()
        
        addSubviews(nav)
        nav.snp.makeConstraints {
            $0.left.top.right.equalToSuperview()
            $0.height.equalTo(ts.height.navBar + .statusBar)
        }
        navColor = ts.color.nav
        
        // 主题颜色改变
        use(TSTheme.self) { (ref, _) in
            ref.setBackgroundColor()
            if !ref.isTransparentNav {
                ref.navColor = ts.color.nav
            }
            ref.setThemeColor()
        }
        setThemeColor()
    }
    
    @objc func setThemeColor() {}
    
    func makeNavUp() {
        view.bringSubviewToFront(nav)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return navColor.isDark ? .lightContent : .default
    }
    
    func addTableView(_ tableView: UITableView) {
        addSubviews(tableView)
        tableView.snp.makeConstraints {
            $0.left.bottom.right.equalToSuperview()
            $0.top.equalTo(nav.snp.bottom)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if ts.global.nav.viewControllers.count > 1 {
            backItem.isHidden = false
        }
    }
    
    @objc
    func leftItemAction(sender: UIButton) {}
    @objc
    func rightItemAction(sender: UIButton) {}
    
    @objc
    func pop() {
        ts.global.nav.popViewController(animated: true)
    }
    
    /// 进入
    func push() {
        if let nav = ts.global.nav {
            nav.pushViewController(self, animated: true)
        }
    }
    
    deinit {
        debugPrint("\(title ?? "\(type(of: self))")释放了")
    }
    
    
    class func go() {
        let vc = self.init()
        vc.push()
    }
}


class TSNavBar: TSView {
    let bar = UIView()
    
    let leftItems = TSStackView()
    let rightItems = TSStackView()
    
    func addLeftItems(_ views: UIView ...) {
        for view in views {
            leftItems.insertArrangedSubview(view, at: 0)
        }
    }
    
    func addRightItems(_ views: UIView ...) {
        for view in views {
            rightItems.addArrangedSubview(view)
        }
    }
    
    lazy var titleLabel: TSLabel = {
        let label = TSLabel()
        bar.addSubview(label)
        label.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.lessThanOrEqualTo(.width * 0.8)
        }
        label.font = 19.regular
        label.color = ts.color.item
        return label
    }()
    
    override func onInit() {
        addSubview(bar)
        bar.snp.makeConstraints {
            $0.left.bottom.right.equalToSuperview()
            $0.height.equalTo(ts.height.navBar)
        }
        
        bar.addSubviews(leftItems, rightItems)
        leftItems.snp.makeConstraints {
            $0.left.top.bottom.equalToSuperview()
        }
        
        rightItems.snp.makeConstraints {
            $0.right.top.bottom.equalToSuperview()
        }
    }
}





