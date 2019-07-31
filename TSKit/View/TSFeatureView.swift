//
//  TSFeatureView.swift
//  JunxinSecurity
//
//  Created by mc on 2019/5/29.
//  Copyright © 2019 张玉飞. All rights reserved.
//

import UIKit

class TSFeatureView: UIView, UIScrollViewDelegate {
    let skipBtn = TSButton()
    let startBtn = TSButton()
    var imageCount: CGFloat = 0
    
    convenience init(images: [TSAssets]) {
        self.init(frame: UIScreen.main.bounds)
        imageCount = images.count.cgfloat
        
        let scrollView = UIScrollView()
        addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        scrollView.contentSize = CGSize(width: .width * (imageCount + 1), height: .height)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.bounces = false
        scrollView.delegate = self
        
        for (i, image) in images.enumerated() {
            let imageView = UIImageView(image: image.image)
            imageView.frame = CGRect(x: CGFloat(i) * .width, y: 0, width: .width, height: .height)
            imageView.contentMode = .scaleAspectFit
            imageView.backgroundColor = ts.color.view
            scrollView.addSubview(imageView)
        }
        
        addSubviews(skipBtn, startBtn)
        
        startBtn.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(-48.em - .safeBottom)
            $0.width.equalTo(112.em)
            $0.height.equalTo(32.em)
        }
        startBtn.corner = 16.em
        startBtn.font = 13.light
        startBtn.title = "立即体验"
        startBtn.color = ts.color.main
        startBtn.border(color: ts.color.main, width: 0.5)
        startBtn.isHidden = true
        startBtn.addTarget(self, action: #selector(endGuide), for: .touchUpInside)
        
        skipBtn.backgroundColor = ts.color.main.alpha(0.7)
        skipBtn.corner = 11.em
        skipBtn.title = "跳过"
        skipBtn.font = 12.light
        skipBtn.snp.makeConstraints {
            $0.right.equalTo(-30.em)
            $0.top.equalTo(60.em)
            $0.width.equalTo(50.em)
            $0.height.equalTo(22.em)
        }
        skipBtn.addTarget(self, action: #selector(endGuide), for: .touchUpInside)
        skipBtn.isHidden = true
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.x
        let total = (imageCount - 1) * .width
        let lastOffset = (imageCount - 2) * .width
        if offset <= lastOffset {
//            skipBtn.isHidden = false
            startBtn.isHidden = true
        } else if offset <= total {
//            skipBtn.isHidden = true
            startBtn.isHidden = false
        } else if offset >= imageCount * .width {
            endGuide()
        } else {
//            skipBtn.isHidden = true
            startBtn.isHidden = true
        }
    }
    @objc
    func endGuide() {
        let key = "AppVersion"
        let curVersion = Bundle.main.version
        ts.helper.setCache(key: key, value: curVersion as NSObject)
        UIView.animate(withDuration: 0.3, animations: {
            self.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }) { (_) in
            self.removeFromSuperview()
        }
    }
}
