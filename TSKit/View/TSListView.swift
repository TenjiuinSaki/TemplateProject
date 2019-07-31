//
//  TSListView.swift
//  TSKit
//
//  Created by mc on 2018/9/4.
//  Copyright © 2018年 张玉飞. All rights reserved.
//
/**
 *
 *   █████▒█    ██  ▄████▄   ██ ▄█▀       ██████╗ ██╗   ██╗ ██████╗
 * ▓██   ▒ ██  ▓██▒▒██▀ ▀█   ██▄█▒        ██╔══██╗██║   ██║██╔════╝
 * ▒████ ░▓██  ▒██░▒▓█    ▄ ▓███▄░        ██████╔╝██║   ██║██║  ███╗
 * ░▓█▒  ░▓▓█  ░██░▒▓▓▄ ▄██▒▓██ █▄        ██╔══██╗██║   ██║██║   ██║
 * ░▒█░   ▒▒█████▓ ▒ ▓███▀ ░▒██▒ █▄       ██████╔╝╚██████╔╝╚██████╔╝
 *  ▒ ░   ░▒▓▒ ▒ ▒ ░ ░▒ ▒  ░▒ ▒▒ ▓▒       ╚═════╝  ╚═════╝  ╚═════╝
 *  ░     ░░▒░ ░ ░   ░  ▒   ░ ░▒ ▒░
 *  ░ ░    ░░░ ░ ░ ░        ░ ░░ ░
 *           ░     ░ ░      ░  ░
 */
import UIKit
import PullToRefreshKit

class TSAdapter {
    let data: AnyObject
    let identifier: String
    init(data: AnyObject, identifier: String) {
        self.data = data
        self.identifier = identifier
    }
}

class TSList: TSAdapter {
    var indexPath: IndexPath!
    var listView: UITableView!
}
protocol TSListViewDelegate: NSObjectProtocol {
    func didEndScroll()
}
class TSListView: UITableView, UITableViewDelegate, UITableViewDataSource {
    convenience init() {
        self.init(frame: .zero, style: .plain)
        delegate = self
        dataSource = self
        clearColor()
        separatorInset = .zero
        separatorColor = ts.color.separator
        tableFooterView = UIView()
        onInit()
        
        use(TSTheme.self) { (ref, _) in
            ref.separatorColor = ts.color.separator
        }
    }
    
    func onInit() {}
    
    var lists = [TSList]()
    var isDecelerate = false
    weak var scrollDelegate: TSListViewDelegate?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let list = lists[indexPath.row]
        list.indexPath = indexPath
        list.listView = self
        let cell = tableView.dequeueReusableCell(withIdentifier: list.identifier, for: indexPath) as! TSListCell
        cell.list = list
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        (tableView.cellForRow(at: indexPath) as? TSListCell)?.didSelected()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if isDecelerate {
            scrollDelegate?.didEndScroll()
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        isDecelerate = decelerate
        if !isDecelerate {
            scrollDelegate?.didEndScroll()
        }
    }
}

protocol TSPageListViewDelegate: NSObjectProtocol {
    func getPageData(pageIdx: Int)
}

class TSPageListView: TSListView {
    weak var pageDelegate: TSPageListViewDelegate?
    var pageIdx = 1 {
        didSet {
            pageDelegate?.getPageData(pageIdx: pageIdx)
        }
    }
    
    let header = DefaultRefreshHeader.header()
    let footer = DefaultRefreshFooter.footer()
    
    override func onInit() {
        header.textLabel.color = ts.color.lightText
        header.tintColor = ts.color.lightText
        header.imageRenderingWithTintColor = true
        configRefreshHeader(with: header, container: self) { [unowned self] in
            self.pageIdx = 1
        }
        
        footer.textLabel.color = ts.color.lightText
        configRefreshFooter(with: footer, container: self) { [unowned self] in
            self.pageIdx += 1
        }
    }
    
    func setList(_ datas: [AnyObject], ident: String, noData: String) {
        if pageIdx == 1 {
            lists.removeAll()
            switchRefreshHeader(to: .normal(.success, 0.3))
            switch datas.count {
            case 0:
                footer.setText(noData.local, mode: .noMoreData)
                switchRefreshFooter(to: .noMoreData)
            case 1...9:
                footer.setText("没有更多了".local, mode: .noMoreData)
                switchRefreshFooter(to: .noMoreData)
            case 10:
                switchRefreshFooter(to: .normal)
            default:
                ()
            }
        } else {
            if datas.count < 10 {
                footer.setText("没有更多了".local, mode: .noMoreData)
                switchRefreshFooter(to: .noMoreData)
            } else {
                switchRefreshFooter(to: .normal)
            }
        }
        
        for data in datas {
            let list = TSList(data: data, identifier: ident)
            lists.append(list)
        }
        reloadData()
    }
}

class TSListCell: TSTableViewCell {
    var list: TSList! {
        didSet {
            onSetData()
        }
    }
    
    func onSetData() {}
}


