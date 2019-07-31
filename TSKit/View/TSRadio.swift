//
//  TSRadio.swift
//  TSKit
//
//  Created by mc on 2018/8/20.
//  Copyright © 2018年 张玉飞. All rights reserved.
//
/**
 *                    _ooOoo_
 *                   o8888888o
 *                   88" . "88
 *                   (| -_- |)
 *                    O\ = /O
 *                ____/`---'\____
 *              .   ' \\| |// `.
 *               / \\||| : |||// \
 *             / _||||| -:- |||||- \
 *               | | \\\ - /// | |
 *             | \_| ''\---/'' | |
 *              \ .-\__ `-` ___/-. /
 *           ___`. .' /--.--\ `. . __
 *        ."" '< `.___\_<|>_/___.' >'"".
 *       | | : `- \`.;`\ _ /`;.`/ - ` : | |
 *         \ \ `-. \_ __\ /__ _/ .-` / /
 * ======`-.____`-.___\_____/___.-`____.-'======
 *                    `=---='
 *
 * .............................................
 *          佛祖保佑             永无BUG
 */
/**
 * _ooOoo_
 * o8888888o
 * 88" . "88
 * (| -_- |)
 *  O\ = /O
 * ___/`---'\____
 * .   ' \\| |// `.
 * / \\||| : |||// \
 * / _||||| -:- |||||- \
 * | | \\\ - /// | |
 * | \_| ''\---/'' | |
 * \ .-\__ `-` ___/-. /
 * ___`. .' /--.--\ `. . __
 * ."" '< `.___\_<|>_/___.' >'"".
 * | | : `- \`.;`\ _ /`;.`/ - ` : | |
 * \ \ `-. \_ __\ /__ _/ .-` / /
 * ======`-.____`-.___\_____/___.-`____.-'======
 * `=---='
 *          .............................................
 *           佛曰：bug泛滥，我已瘫痪！
 */

import UIKit

protocol TSRadioDelegate: NSObjectProtocol {
    func shouldSelect(radio: UIButton, at index: Int) -> Bool
    func didSelected(radio: UIButton, index: Int)
    func didDeselected(radio: UIButton, index: Int)
}
extension TSRadioDelegate {
    func shouldSelect(radio: UIButton, at index: Int) -> Bool {
        return true
    }
    func didSelected(radio: UIButton, index: Int) {}
    func didDeselected(radio: UIButton, index: Int) {}
}
class TSRadio: UIStackView {

    weak var delegate: TSRadioDelegate?
    var checkedIndex = 0 {
        didSet {
            guard checkedIndex < radios.count else {
                return
            }
            delegate?.didDeselected(radio: radios[oldValue], index: oldValue)
            delegate?.didSelected(radio: radios[checkedIndex], index: checkedIndex)
        }
    }

    convenience init() {
        self.init(frame: .zero)
        distribution = .fillEqually
    }
    
    convenience init(radios: [UIButton]) {
        self.init(arrangedSubviews: radios)
        distribution = .fillEqually
        self.radios = radios
    }
    
    func clearRadios() {
        for arrangedSubview in arrangedSubviews {
            arrangedSubview.removeFromSuperview()
        }
    }
    
    var radios = [UIButton]() {
        didSet {
            removeSubviews()
            for button in radios {
                button.addTarget(self, action: #selector(changeChecked(sender:)), for: .touchUpInside)
                addArrangedSubview(button)
            }
            reloadData()
        }
    }
    
    func reloadData() {
        for index in 0..<radios.count {
            if index == checkedIndex {
                delegate?.didSelected(radio: radios[index], index: index)
            } else {
                delegate?.didDeselected(radio: radios[index], index: index)
            }
        }
    }
    
    @objc
    func changeChecked(sender: UIButton) {
        if let index = radios.index(of: sender) {
            if let delegate = delegate,
                !delegate.shouldSelect(radio: sender, at: index) {
                return
            }
            if checkedIndex == index {
                return
            } else {
                checkedIndex = index
            }
        }
    }

}


class TSGridRadio: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private var spacing: CGFloat = 0
    private var lineCount = 0
    
    weak var radioDelegate: TSRadioDelegate?
    var selectedIndex = 0 {
        willSet {
            if let cell = (cellForItem(at: IndexPath(row: selectedIndex, section: 0)) as? TSRadioCell) {
                radioDelegate?.didDeselected(radio: cell.radio, index: selectedIndex)
            }
        }
        didSet {
            if let cell = (cellForItem(at: IndexPath(row: selectedIndex, section: 0)) as? TSRadioCell) {
                radioDelegate?.didSelected(radio: cell.radio, index: selectedIndex)
            }
        }
    }
    
    var titles = [String]() {
        didSet {
            reloadData()
        }
    }
    convenience init(spacing: CGFloat, lineCount: Int) {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = spacing
        flowLayout.minimumInteritemSpacing = spacing
        self.init(frame: .zero, collectionViewLayout: flowLayout)
        delegate = self
        dataSource = self
        clearColor()
        register(class: TSRadioCell.self)
        isScrollEnabled = false
        
        self.spacing = spacing
        self.lineCount = lineCount
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: TSRadioCell = collectionView.reusable(indexPath: indexPath)
        cell.radio.title = titles[indexPath.row]
        if indexPath.row == selectedIndex {
            radioDelegate?.didSelected(radio: cell.radio, index: selectedIndex)
        } else {
            radioDelegate?.didDeselected(radio: cell.radio, index: selectedIndex)
        }
        return cell
    }
    

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row != selectedIndex {
            selectedIndex = indexPath.row
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = (width - (lineCount - 1).cgfloat * spacing) / lineCount.cgfloat
        let lines = titles.count / lineCount + ((titles.count % lineCount) > 0 ? 1 : 0)
        let itemHeight = (height - (lines - 1).cgfloat * spacing) / lines.cgfloat
        return CGSize(width: itemWidth, height: itemHeight)
    }
}

class TSRadioCell: UICollectionViewCell {
    var radio = TSButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clearColor()
        
        addSubview(radio)
        radio.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        radio.isUserInteractionEnabled = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
