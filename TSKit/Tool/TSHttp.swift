//
//  TSHttp.swift
//  TSKit
//
//  Created by mc on 2018/9/3.
//  Copyright © 2018年 张玉飞. All rights reserved.
//

import Foundation
import Alamofire
import PromiseKit


enum TSError: Error {
//    case url
    case connect
    case notfound
    case parse
}

enum TSParse {
    case JSON
    case utf8
    case int
    case gbk
    case data
}

class TSHttp {
    // 网络状态监测器
    let reachMgr: NetworkReachabilityManager?
    // 任务管理器
    let sessionMgr: SessionManager
    
    init() {
        URLCache.shared.removeAllCachedResponses()
        
        reachMgr = NetworkReachabilityManager()
        reachMgr?.startListening()
        
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        sessionMgr = Alamofire.SessionManager(configuration: configuration)
    }
    
    func request<T>(_ req: URLRequest, res: TSParse = .JSON) -> Promise<T> {
        if let mgr = reachMgr, mgr.isReachable {
            return Promise<T> { e in
                sessionMgr.request(req).responseData() { (response) in
                    switch response.result {
                    case .success(let value):
                        // 如果接收到数据进行类型匹配，成功返回结果，否则失败
                        let result: Any?
                        switch res {
                        case .JSON:
                            result = try? JSONSerialization.jsonObject(with: value, options: .mutableContainers)
                        case .gbk:
                            result = value.gbkString
                        case .utf8:
                            result = value.string
                        case .int:
                            result = value.string?.int
                        case .data:
                            result = value
                        }
                        if let result = result as? T {
                            e.fulfill(result)
                        } else {
                            e.reject(TSError.parse)
                            debugPrint("数据有误:", response.request?.url?.absoluteString ?? "")
                        }
                    case .failure:
                        // 如果接收不到数据检测网络是否畅通，有网连接失败，否则为断网
                        e.reject(TSError.notfound)
//                        ts.helper.showMessage("网络连接失败")
                    }
                }
            }
        } else {
            return Promise<T> { e in
                e.reject(TSError.connect)
//                ts.helper.showMessage("请检查网络连接")
            }
        }
    }
}
