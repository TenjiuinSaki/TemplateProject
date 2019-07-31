//
//  TSScrollView.swift
//  JunxinSecurity
//
//  Created by mc on 2019/3/8.
//  Copyright © 2019 张玉飞. All rights reserved.
//

import UIKit

protocol TSScrollViewDelegate: NSObjectProtocol {
    func didChange(to view: UIView, isNext: Bool)
}
class TSScrollView: TSView, UIScrollViewDelegate {

    let scrollView = UIScrollView()
    var isDecelerate = false
    let stackView = UIStackView()
    weak var delegate: TSScrollViewDelegate?
    override func onInit() {
        clearColor()
        
        addSubview(scrollView)
        scrollView.full()
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        }
        stackView.distribution = .fillEqually
        scrollView.addSubviews(stackView)
        stackView.snp.makeConstraints {
            $0.top.left.height.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(3)
        }
    }
    
    override func layoutSubviews() {
        scrollView.contentSize = CGSize(width: width * 3, height: height)
        scrollView.contentOffset = CGPoint(x: width, y: 0)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if isDecelerate {
            didEndScroll()
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        isDecelerate = decelerate
        if !isDecelerate {
            didEndScroll()
        }
    }
    
    func didEndScroll() {
        if scrollView.contentOffset.x > width {
            delegate?.didChange(to: stackView.arrangedSubviews[2], isNext: true)
        } else if scrollView.contentOffset.x < width {
            delegate?.didChange(to: stackView.arrangedSubviews[0], isNext: false)
        } else {
            return
        }
        scrollView.contentOffset = CGPoint(x: width, y: 0)
    }
}
