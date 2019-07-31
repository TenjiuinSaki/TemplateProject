//
//  TSGroupView.swift
//  TSKit
//
//  Created by mc on 2018/9/5.
//  Copyright © 2018年 张玉飞. All rights reserved.
//

import UIKit

struct TSGroup {
    var header: TSGroupHeader
    var lists: [TSList]
}

class TSGroupView: UITableView, UITableViewDelegate, UITableViewDataSource, TSGroupHeaderViewDelegate {

    var groups = [TSGroup]()
    
    convenience init() {
        self.init(frame: .zero, style: .plain)
        delegate = self
        dataSource = self
        clearColor()
        separatorInset = .zero
        separatorColor = ts.color.separator
        tableFooterView = UIView()
        
        use(TSTheme.self) { (ref, _) in
            ref.separatorColor = ts.color.separator
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return groups.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard section < groups.count else {
            return 0
        }
        
        let group = groups[section]
        return group.header.open ? group.lists.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let list = groups[indexPath.section].lists[indexPath.row]
        list.indexPath = indexPath
        list.listView = self
        let cell = tableView.dequeueReusableCell(withIdentifier: list.identifier, for: indexPath) as! TSListCell
        cell.list = list
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        (tableView.cellForRow(at: indexPath) as? TSListCell)?.didSelected()
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = groups[section].header
        header.section = section
        
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: header.identifier) as! TSGroupHeaderView
        view.delegate = self
        view.header = header
        if header.open {
            view.openGroup()
        } else {
            view.closeGroup()
        }
        return view
    }
    
    func headerView(_ headerView: TSGroupHeaderView, didSelectAt section: Int) {
        var indexPaths = [IndexPath]()
        for i in 0..<groups[section].lists.count {
            indexPaths.append(IndexPath(row: i, section: section))
        }
        
        if headerView.header.open {
            insertRows(at: indexPaths, with: .fade)
        } else {
            deleteRows(at: indexPaths, with: .fade)
        }
    }
}

class TSGroupHeader: TSAdapter {
    var section: Int!
    var open: Bool
    init(data: AnyObject, identifier: String, open: Bool) {
        self.open = open
        super.init(data: data, identifier: identifier)
    }
}

protocol TSGroupHeaderViewDelegate: NSObjectProtocol {
    func headerView(_ headerView: TSGroupHeaderView, didSelectAt section: Int)
}
class TSGroupHeaderView: UITableViewHeaderFooterView {
    weak var delegate: TSGroupHeaderViewDelegate?
    var header: TSGroupHeader! {
        didSet {
            onSetData()
        }
    }
    
    func onSetData() {}
    func onInit() {}
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapAction)))
        onInit()
    }
    
    @objc
    func tapAction() {
        header.open.toggle()
        let animations = header.open ? openGroup : closeGroup
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .allowUserInteraction, animations: animations, completion: nil)
        delegate?.headerView(self, didSelectAt: header.section)
    }
    
    func openGroup() {}
    
    func closeGroup() {}
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


