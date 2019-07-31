//
//  TSAssets.swift
//  TSKit
//
//  Created by mc on 2018/10/16.
//  Copyright © 2018 张玉飞. All rights reserved.
//

import UIKit

enum TSAssets: String {
    
    var image: UIImage {
        if let image = UIImage(named: rawValue) {
            return image
        } else {
            debugPrint("缺少图片: " + rawValue)
            assert(false)
            return UIImage()
        }
    }
    
    case btn_back
    case image_search
    case angle_down
    case mark_circle
    case bottom_arrow
    case top_arrow
    case btn_skip
    
    // 这里添加需要用的图片name
    case star
}

protocol TSImageable: NSObjectProtocol {
    var image: UIImage? { set get }
}

extension TSImageable {
    func setImage(_ asset: TSAssets) {
        image = asset.image
    }
    
    func setShape(_ asset: TSAssets) {
        image = asset.image.shape
    }
}


