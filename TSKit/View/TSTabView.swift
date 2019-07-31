//
//  TSTabView.swift
//  StockFunding
//
//  Created by mc on 2018/11/2.
//  Copyright © 2018 张玉飞. All rights reserved.
//

import UIKit

class TSTabControl: UIControl, TSRadioDelegate {
    let radio = TSRadio()

    var selectedIndex: Int {
        return radio.checkedIndex
    }
    
    let focusLine = TSView()
    let separateLine = TSView()
    var lineWidth = 40.em
    var font = 14.light
    
    var selectColor = ts.color.main
    var deselectColor = ts.color.darkText
    
    convenience init() {
        self.init(frame: .zero)
        backgroundColor = ts.color.view
        
        addSubviews(radio, focusLine, separateLine)
        radio.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        radio.delegate = self

        focusLine.snp.makeConstraints {
            $0.left.bottom.equalToSuperview()
            $0.height.equalTo(1.2)
            $0.width.equalTo(lineWidth)
        }
        focusLine.color = R.color.main
        
        separateLine.snp.makeConstraints {
            $0.left.bottom.right.equalToSuperview()
            $0.height.equalTo(0.4)
        }
        separateLine.color = ts.color.separator
        
        use(TSTheme.self) { (ref, _) in
            ref.backgroundColor = ts.color.view
            ref.separateLine.color = ts.color.separator
            ref.deselectColor = ts.color.darkText
            for (i, btn) in ref.radio.radios.enumerated() {
                if i != ref.selectedIndex {
                    btn.color = ts.color.darkText
                }
            }
        }
        
        onInit()
    }
    
    func onInit() {}
    
    func setTitles(_ titles: [String]) {
        var buttons = [UIButton]()
        for title in titles {
            let btn = TSButton()
            btn.title = title
            btn.font = font
            buttons.append(btn)
        }
        radio.radios = buttons
    }
    
    func didSelected(radio: UIButton, index: Int) {
        sendActions(for: .valueChanged)
        moveUnderLine(index)
        
        radio.color = selectColor
    }
    
    func didDeselected(radio: UIButton, index: Int) {
        radio.color = deselectColor
    }
    
    func moveUnderLine(_ index: Int) {
        let animate = CABasicAnimation(type: .positionX)
        animate.toValue = width / radio.radios.count.cgfloat * (CGFloat(index) + 0.5)
        animate.timingFunction = CAMediaTimingFunction(controlPoints: 0.85, 0, 0.35, 1.3)
        focusLine.start(animate: animate)
    }
    
    override func layoutSubviews() {
        moveUnderLine(radio.checkedIndex)
    }
}

protocol TSTabDelegate: NSObjectProtocol {
    func didTab(to index: Int)
}
class TSTabView: TSView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    weak var delegate: TSTabDelegate?
    
    var currentIndex = 0
    
    var isScrollEnabled = true {
        didSet {
            collectionView.isScrollEnabled = isScrollEnabled
        }
    }
    
    var isHidePageControl = true {
        didSet {
            pageControl.isHidden = isHidePageControl
        }
    }
    
    var views = [UIView]() {
        didSet {
            pageControl.numberOfPages = views.count
            collectionView.reloadData()
        }
    }
    
    let pageControl = UIPageControl()

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame: bounds, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(class: UICollectionViewCell.self)
        collectionView.clearColor()
        return collectionView
    }()
    
    override func onInit() {
        addSubviews(collectionView, pageControl)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        pageControl.snp.makeConstraints { (make) in
            make.height.equalTo(5)
            make.left.bottom.right.equalToSuperview()
        }
        pageControl.isHidden = isHidePageControl
    }
    
    func set(index: Int, animated: Bool) {
        collectionView.scrollToItem(at: IndexPath(row: index, section: 0), at: .left, animated: animated)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: UICollectionViewCell = collectionView.reusable(indexPath: indexPath)
        cell.removeSubviews()
        let view = views[indexPath.row]
        cell.addSubview(view)
        view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return views.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return bounds.size
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if isHidePageControl {
            return
        }
        let total = scrollView.contentSize.width - scrollView.bounds.width
        let offset = scrollView.contentOffset.x
        pageControl.currentPage = Int(offset / total)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x / scrollView.width)
        if index != currentIndex {
            currentIndex = index
            delegate?.didTab(to: currentIndex)
        }
    }
}
