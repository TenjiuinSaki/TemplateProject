//
//  TSTabBarController.swift
//  TSKit
//
//  Created by mc on 2018/8/20.
//  Copyright © 2018年 张玉飞. All rights reserved.
//
/**
 *          .,:,,,                                        .::,,,::.
 *        .::::,,;;,                                  .,;;:,,....:i:
 *        :i,.::::,;i:.      ....,,:::::::::,....   .;i:,.  ......;i.
 *        :;..:::;::::i;,,:::;:,,,,,,,,,,..,.,,:::iri:. .,:irsr:,.;i.
 *        ;;..,::::;;;;ri,,,.                    ..,,:;s1s1ssrr;,.;r,
 *        :;. ,::;ii;:,     . ...................     .;iirri;;;,,;i,
 *        ,i. .;ri:.   ... ............................  .,,:;:,,,;i:
 *        :s,.;r:... ....................................... .::;::s;
 *        ,1r::. .............,,,.,,:,,........................,;iir;
 *        ,s;...........     ..::.,;:,,.          ...............,;1s
 *       :i,..,.              .,:,,::,.          .......... .......;1,
 *      ir,....:rrssr;:,       ,,.,::.     .r5S9989398G95hr;. ....,.:s,
 *     ;r,..,s9855513XHAG3i   .,,,,,,,.  ,S931,.,,.;s;s&BHHA8s.,..,..:r:
 *    :r;..rGGh,  :SAG;;G@BS:.,,,,,,,,,.r83:      hHH1sXMBHHHM3..,,,,.ir.
 *   ,si,.1GS,   sBMAAX&MBMB5,,,,,,:,,.:&8       3@HXHBMBHBBH#X,.,,,,,,rr
 *   ;1:,,SH:   .A@&&B#&8H#BS,,,,,,,,,.,5XS,     3@MHABM&59M#As..,,,,:,is,
 *  .rr,,,;9&1   hBHHBB&8AMGr,,,,,,,,,,,:h&&9s;   r9&BMHBHMB9:  . .,,,,;ri.
 *  :1:....:5&XSi;r8BMBHHA9r:,......,,,,:ii19GG88899XHHH&GSr.      ...,:rs.
 *  ;s.     .:sS8G8GG889hi.        ....,,:;:,.:irssrriii:,.        ...,,i1,
 *  ;1,         ..,....,,isssi;,        .,,.                      ....,.i1,
 *  ;h:               i9HHBMBBHAX9:         .                     ...,,,rs,
 *  ,1i..            :A#MBBBBMHB##s                             ....,,,;si.
 *  .r1,..        ,..;3BMBBBHBB#Bh.     ..                    ....,,,,,i1;
 *   :h;..       .,..;,1XBMMMMBXs,.,, .. :: ,.               ....,,,,,,ss.
 *    ih: ..    .;;;, ;;:s58A3i,..    ,. ,.:,,.             ...,,,,,:,s1,
 *    .s1,....   .,;sh,  ,iSAXs;.    ,.  ,,.i85            ...,,,,,,:i1;
 *     .rh: ...     rXG9XBBM#M#MHAX3hss13&&HHXr         .....,,,,,,,ih;
 *      .s5: .....    i598X&&A&AAAAAA&XG851r:       ........,,,,:,,sh;
 *      . ihr, ...  .         ..                    ........,,,,,;11:.
 *         ,s1i. ...  ..,,,..,,,.,,.,,.,..       ........,,.,,.;s5i.
 *          .:s1r,......................       ..............;shs,
 *          . .:shr:.  ....                 ..............,ishs.
 *              .,issr;,... ...........................,is1s;.
 *                 .,is1si;:,....................,:;ir1sr;,
 *                    ..:isssssrrii;::::::;;iirsssssr;:..
 *                         .,::iiirsssssssssrri;;:.
 */

import UIKit
import SnapKit

class TSTabBarItem: UIButton {
    
    let barImageView = TSImageView()
    let textLabel = TSLabel()
    var unselectImage: UIImage?
    var selectImage: UIImage?
    
    var isTemplate = true
    
    convenience init(image: UIImage, text: String) {
        self.init(type: .custom)
        
        isTemplate = true
        
        addViews()
        
        barImageView.image = image.withRenderingMode(.alwaysTemplate)
        textLabel.words = text
    }
    
    convenience init(image: UIImage, selectImage: UIImage, text: String) {
        self.init(type: .custom)
        
        isTemplate = false
        
        unselectImage = image
        self.selectImage = selectImage
        
        addViews()
        
        barImageView.image = image
        textLabel.words = text
    }
 
    func addViews() {
        addSubviews(barImageView, textLabel)

        barImageView.snp.makeConstraints {
            $0.width.height.equalTo(20.em)
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-8.em)
        }
        
        textLabel.snp.makeConstraints {
            $0.centerX.bottom.equalToSuperview()
            $0.height.equalTo(20.em)
        }
        textLabel.font = 11.regular
    }
}

class TSTabBar: TSView {
    
    let tabBar = TSRadio()
    let tabShadow = TSView()
    
    func setItems(_ items: [TSTabBarItem]) {
        tabBar.radios = items
    }
    
    override func onInit() {
        color = ts.color.view
        
        addSubviews(tabBar, tabShadow)
        
        tabBar.snp.makeConstraints {
            $0.left.top.right.equalToSuperview()
            $0.height.equalTo(ts.height.tabBar)
        }
        
        tabShadow.snp.makeConstraints {
            $0.left.top.right.equalToSuperview()
            $0.height.equalTo(0.3)
        }
        tabShadow.color = ts.color.separator
        
        use(TSTheme.self) { (ref, _) in
            ref.color = ts.color.view
            ref.tabShadow.color = ts.color.separator
        }
    }
}

class TSTabBarController: UITabBarController, TSRadioDelegate {
    var selectColor = ts.color.main
    var unselectColor = ts.color.lightText
    
    let tab = TSTabBar()
    
    var items = [TSTabBarItem]() {
        didSet {
            tab.setItems(items)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        tabBar.isHidden = true
        
        addSubviews(tab)
        tab.snp.makeConstraints {
            $0.left.bottom.right.equalToSuperview()
            $0.height.equalTo(ts.height.tabBar + .safeBottom)
        }
        tab.tabBar.delegate = self

        
        use(TSTheme.self) { (ref, _) in
            ref.unselectColor = ts.color.lightText
        }
    }
    
    func setIndex(_ index: Int) {
        tab.tabBar.checkedIndex = index
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return selectedViewController?.preferredStatusBarStyle ?? .default
    }
    
    func shouldSelect(radio: UIButton, at index: Int) -> Bool {
        // 如果有代理判断是否可以跳转，不可跳转退出
        if let delegate = delegate,
            let controllers = viewControllers,
            let shouldSelect = delegate.tabBarController?(self, shouldSelect: controllers[index]) {
            return shouldSelect
        }
        return true
    }
    
    func didSelected(radio: UIButton, index: Int) {
        if let item = radio as? TSTabBarItem {
            if item.isTemplate {
                item.barImageView.color = selectColor
            } else {
                item.barImageView.image = item.selectImage
            }
            item.textLabel.color = selectColor
        }
        
        selectedIndex = index
    }
    
    func didDeselected(radio: UIButton, index: Int) {
        if let item = radio as? TSTabBarItem {
            if item.isTemplate {
                item.barImageView.color = unselectColor
            } else {
                item.barImageView.image = item.unselectImage
            }
            item.textLabel.color = unselectColor
        }
    }
    
    
}


