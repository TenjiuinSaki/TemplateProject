//
//  TSPageViewController.swift
//  JunxinSecurity
//
//  Created by mc on 2018/10/16.
//  Copyright © 2018 张玉飞. All rights reserved.
//

import UIKit
import PagingKit

protocol TSPageProtocal {
    func pageDidAppear()
    func pageDidDisappear()
}

extension TSPageProtocal {
    func pageDidAppear() {}
    func pageDidDisappear() {}
}

class TSPageViewController: TSViewController, PagingMenuViewControllerDataSource, PagingMenuViewControllerDelegate {

    let menuController = PagingMenuViewController()
    let pageController = PagingContentViewController()
    
    var viewControllers = [UIViewController & TSPageProtocal]() {
        didSet {
            menuController.reloadData()
            pageController.reloadData()
        }
    }
    let menuIdentifier = "menuCell"
    
    var currentPageIndex = 0 {
        didSet {
            didChangePage()
            guard
                viewControllers.count > oldValue,
                viewControllers.count > currentPageIndex
            else {
                return
            }
            if currentPageIndex != oldValue {
                viewControllers[oldValue].pageDidDisappear()
                viewControllers[currentPageIndex].pageDidAppear()
            }
        }
    }
    // 设置当前显示页
    func showPage(at index: Int, animated: Bool) {
        menuController.cellForItem(at: currentPageIndex)?.isSelected = false
        menuController.cellForItem(at: index)?.isSelected = true
        menuController.scroll(index: index)
        pageController.scroll(to: index, animated: animated) { (_) in
            self.currentPageIndex = index
        }
    }
    
    var isPageScrollEnable = true {
        didSet {
            pageController.scrollView.isScrollEnabled = isPageScrollEnable
        }
    }
    
    var menuView: UIView {
        return menuController.view
    }
    
    var pageView: UIView {
        return pageController.view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        addChild(menuController)
        addChild(pageController)
        
        menuController.delegate = self
        menuController.dataSource = self
        
        pageController.delegate = self
        pageController.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if viewControllers.count > currentPageIndex {
            viewControllers[currentPageIndex].pageDidAppear()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if viewControllers.count > currentPageIndex {
            viewControllers[currentPageIndex].pageDidDisappear()
        }
    }
    
    func didChangePage() {
        
    }
    
    func setupMenuCell(_ cell: TSPageMenuCell, with index: Int) {
        
    }
    
    func numberOfItemsForMenuViewController(viewController: PagingMenuViewController) -> Int {
        return viewControllers.count
    }
    
    // 创建menuCell
    func menuViewController(viewController: PagingMenuViewController, cellForItemAt index: Int) -> PagingMenuViewCell {
        let cell = viewController.dequeueReusableCell(withReuseIdentifier: menuIdentifier, for: index)
        cell.isSelected = currentPageIndex == index
        if let cell = cell as? TSPageMenuCell {
            setupMenuCell(cell, with: index)
        }
        return cell
    }
    // 设置menuWidth
    func menuViewController(viewController: PagingMenuViewController, widthForItemAt index: Int) -> CGFloat {
        return viewController.view.width / CGFloat(viewControllers.count)
    }
    
    func menuViewController(viewController: PagingMenuViewController, didSelect page: Int, previousPage: Int) {
        showPage(at: page, animated: true)
    }
}



extension TSPageViewController: PagingContentViewControllerDataSource, PagingContentViewControllerDelegate {
    //    控制器个数
    func numberOfItemsForContentViewController(viewController: PagingContentViewController) -> Int {
        return viewControllers.count
    }
    //    第几个控制器
    func contentViewController(viewController: PagingContentViewController, viewControllerAt index: Int) -> UIViewController {
        return viewControllers[index]
    }
    //    滑动控制器
    func contentViewController(viewController: PagingContentViewController, didManualScrollOn index: Int, percent: CGFloat) {
        let isRightCellSelected = percent > 0.5
        menuController.cellForItem(at: index)?.isSelected = !isRightCellSelected
        menuController.cellForItem(at: index + 1)?.isSelected = isRightCellSelected
        menuController.scroll(index: index, percent: percent, animated: false)
    }
    //    结束滑动
    func contentViewController(viewController: PagingContentViewController, didEndManualScrollOn index: Int) {
        currentPageIndex = index
    }
}


class TSPageMenuCell: PagingMenuViewCell {
    
    func onInit() {}
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        onInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
