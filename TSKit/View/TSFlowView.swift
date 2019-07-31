//
//  TSPushViewController.swift
//  TSKit
//
//  Created by mc on 2018/8/20.
//  Copyright © 2018年 张玉飞. All rights reserved.
//
/**
 *               ii.                                         ;9ABH,
 *              SA391,                                    .r9GG35&G
 *              &#ii13Gh;                               i3X31i;:,rB1
 *              iMs,:,i5895,                         .5G91:,:;:s1:8A
 *               33::::,,;5G5,                     ,58Si,,:::,sHX;iH1
 *                Sr.,:;rs13BBX35hh11511h5Shhh5S3GAXS:.,,::,,1AG3i,GG
 *                .G51S511sr;;iiiishS8G89Shsrrsh59S;.,,,,,..5A85Si,h8
 *               :SB9s:,............................,,,.,,,SASh53h,1G.
 *            .r18S;..,,,,,,,,,,,,,,,,,,,,,,,,,,,,,....,,.1H315199,rX,
 *          ;S89s,..,,,,,,,,,,,,,,,,,,,,,,,....,,.......,,,;r1ShS8,;Xi
 *        i55s:.........,,,,,,,,,,,,,,,,.,,,......,.....,,....r9&5.:X1
 *       59;.....,.     .,,,,,,,,,,,...        .............,..:1;.:&s
 *      s8,..;53S5S3s.   .,,,,,,,.,..      i15S5h1:.........,,,..,,:99
 *      93.:39s:rSGB@A;  ..,,,,.....    .SG3hhh9G&BGi..,,,,,,,,,,,,.,83
 *      G5.G8  9#@@@@@X. .,,,,,,.....  iA9,.S&B###@@Mr...,,,,,,,,..,.;Xh
 *      Gs.X8 S@@@@@@@B:..,,,,,,,,,,. rA1 ,A@@@@@@@@@H:........,,,,,,.iX:
 *     ;9. ,8A#@@@@@@#5,.,,,,,,,,,... 9A. 8@@@@@@@@@@M;    ....,,,,,,,,S8
 *     X3    iS8XAHH8s.,,,,,,,,,,...,..58hH@@@@@@@@@Hs       ...,,,,,,,:Gs
 *    r8,        ,,,...,,,,,,,,,,.....  ,h8XABMMHX3r.          .,,,,,,,.rX:
 *   :9, .    .:,..,:;;;::,.,,,,,..          .,,.               ..,,,,,,.59
 *  .Si      ,:.i8HBMMMMMB&5,....                    .            .,,,,,.sMr
 *  SS       :: h@@@@@@@@@@#; .                     ...  .         ..,,,,iM5
 *  91  .    ;:.,1&@@@@@@MXs.                            .          .,,:,:&S
 *  hS ....  .:;,,,i3MMS1;..,..... .  .     ...                     ..,:,.99
 *  ,8; ..... .,:,..,8Ms:;,,,...                                     .,::.83
 *   s&: ....  .sS553B@@HX3s;,.    .,;13h.                            .:::&1
 *    SXr  .  ...;s3G99XA&X88Shss11155hi.                             ,;:h&,
 *     iH8:  . ..   ,;iiii;,::,,,,,.                                 .;irHA
 *      ,8X5;   .     .......                                       ,;iihS8Gi
 *         1831,                                                 .,;irrrrrs&@
 *           ;5A8r.                                            .:;iiiiirrss1H
 *             :X@H3s.......                                .,:;iii;iiiiirsrh
 *              r#h:;,...,,.. .,,:;;;;;:::,...              .:;;;;;;iiiirrss1
 *             ,M8 ..,....,.....,,::::::,,...         .     .,;;;iiiiiirss11h
 *             8B;.,,,,,,,.,.....          .           ..   .:;;;;iirrsss111h
 *            i@5,:::,,,,,,,,.... .                   . .:::;;;;;irrrss111111
 *            9Bi,:,,,,......                        ..r91;;;;;iirrsss1ss1111
 */

import UIKit

class TSFlowView: TSTableView, UITableViewDelegate, UITableViewDataSource {
    convenience init() {
        self.init(style: .grouped)
        delegate = self
        dataSource = self
        showsVerticalScrollIndicator = false
        separatorStyle = .none
        
        use(TSTheme.self) { (ref, _) in
            if ref.isShowSeparator {
                ref.separatorColor = ts.color.separator
            }
        }
    }
    
    var isShowSeparator = false {
        didSet {
            if isShowSeparator {
                separatorStyle = .singleLine
                separatorColor = ts.color.separator
            } else {
                separatorStyle = .none
            }
        }
    }
    
    var views = [TSFlow]()
    
    func setViews(_ views: [TSFlow]) {
        self.views = views
        reloadData()
//        setContentOffset(.zero, animated: true)
        selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .top)
    }
    
    func insertView(_ view: TSFlow, at index: Int) {
        if contain(flow: view) {
            return
        }
        views.insert(view, at: index)
        let indexPath = IndexPath(row: index, section: 0)
        insertRows(at: [indexPath], with: .top)
    }
    
    func deleteView(_ view: TSFlow) {
        if let row = row(for: view) {
            deleteView(at: row)
        }
    }
    
    func deleteView(at index: Int) {
        views.remove(at: index)
        let indexPath = IndexPath(row: index, section: 0)
        deleteRows(at: [indexPath], with: .top)
    }
    
    func insertViews(_ flows: [TSFlow], at index: Int) {
        views.insert(contentsOf: flows, at: index)
        var indexPaths = [IndexPath]()
        for i in 0..<flows.count {
            indexPaths.append(IndexPath(row: index + i, section: 0))
        }
        insertRows(at: indexPaths, with: .top)
    }
    
    func delete(in range: Range<Int>) {
        views[range] = []
        var indexPaths = [IndexPath]()
        for i in range {
            indexPaths.append(IndexPath(row: i, section: 0))
        }
        deleteRows(at: indexPaths, with: .top)
    }
    
    func contain(flow: TSFlow) -> Bool {
        return row(for: flow) != nil
    }
    
    func row(for flow: TSFlow) -> Int? {
        return indexPath(for: flow)?.row
    }
    
    func refresh() {
        beginUpdates()
        endUpdates()
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return views.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return views[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        views[indexPath.row].didSelected()
    }
}

class TSFlow: TSTableViewCell {
    class var space: TSFlow {
        return TSSpaceFlow(height: 7.em)
    }
    
    class var line: TSFlow {
        return TSLineFlow()
    }
}

class TSSpaceFlow: TSFlow {
    let space = TSView()
    
    convenience init(height: CGFloat) {
        self.init()
        
        space.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(height).priority(750)
        }
    }
    
    override func onInit() {
        clearColor()
        
        addSubview(space)
        space.clearColor()
    }
}

class TSLineFlow: TSFlow {
    let line = TSView()
    
    override func onInit() {
        clearColor()
        
        addSubview(line)
        line.snp.makeConstraints {
            $0.top.equalTo(3.em)
            $0.center.equalToSuperview()
            $0.width.equalToSuperview().inset(15.em)
            $0.height.equalTo(0.6).priority(750)
        }
        line.color = ts.color.separator
    }
}

class TSTextFlow: TSFlow {
    let attributeLabel = TSAttributeLabel()
    
    var content: String = "" {
        didSet {
            attributeLabel.attributeText = content
        }
    }
    
    override func onInit() {
        clearColor()
        
        addSubview(attributeLabel)
        
        attributeLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().inset(16.em)
            $0.top.equalTo(7.em)
            $0.bottom.equalTo(-3.em)
        }
        
        attributeLabel.lineSpacing = 4
        attributeLabel.font = 14.light
        attributeLabel.textColor = ts.color.darkText
    }
}
