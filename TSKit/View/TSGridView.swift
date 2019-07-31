//
//  TSGridView.swift
//  TSKit
//
//  Created by mc on 2018/9/3.
//  Copyright © 2018年 张玉飞. All rights reserved.
//

import UIKit

class TSGrid: TSAdapter {
    let width: CGFloat
    var indexPath: IndexPath!
    
    init(data: AnyObject,
         identifier: String,
         width: CGFloat) {
        self.width = width
        super.init(data: data, identifier: identifier)
    }
}

class TSLeftAlignmentFlowLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        if let attributes = super.layoutAttributesForElements(in: rect) {
            guard attributes.count > 1 else {
                return attributes
            }
            for i in 0..<attributes.count - 1 {
                let current = attributes[i]
                let next = attributes[i + 1]
                
                let origin = current.frame.maxX
                if origin + minimumInteritemSpacing + next.frame.width < collectionViewContentSize.width {
                    var frame = next.frame
                    frame.origin.x = origin + minimumInteritemSpacing
                    next.frame = frame
                }
            }
            return attributes
        }
        return nil
    }
}

class TSGridView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    let flowLayout = TSLeftAlignmentFlowLayout()
    
    init() {
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        super.init(frame: .zero, collectionViewLayout: flowLayout)
        delegate = self
        dataSource = self
        clearColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var grids = [TSGrid]()
    
    var itemHeight: CGFloat = 0
    var spacing: CGFloat = 0 {
        didSet {
            flowLayout.minimumLineSpacing = spacing
            flowLayout.minimumInteritemSpacing = spacing
        }
    }
    var inset: CGFloat = 0 {
        didSet {
            contentInset = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        }
    }
    var scrollDerection: UICollectionView.ScrollDirection = .vertical {
        didSet {
            flowLayout.scrollDirection = scrollDerection
        }
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return grids.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let grid = grids[indexPath.row]
        grid.indexPath = indexPath
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: grid.identifier, for: indexPath) as! TSGridCell
        cell.grid = grid
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        (collectionView.cellForItem(at: indexPath) as? TSGridCell)?.didSelect()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = grids[indexPath.row].width
        return CGSize(width: itemWidth, height: itemHeight)
    }

}

class TSGridCell: UICollectionViewCell {
    var grid: TSGrid! {
        didSet {
            onSetData()
        }
    }
    func onSetData() {}
    func onInit() {}
    
    func didSelect() {}
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = R.color.view
        
        onInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
