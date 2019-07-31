//
//  TSCustomer.swift
//  JunxinStock
//
//  Created by mc on 2018/12/4.
//  Copyright © 2018 张玉飞. All rights reserved.
//

import Foundation

protocol TSCustomerDelegate: NSObjectProtocol {
    // 这里添加刷新用户信息成功的回调
}
class TSCustomer {
    var token = ""
    weak var delegate: TSCustomerDelegate?
    
    init() {
        get()
    }
    
    func save() {
        let customer: AppCustomer = ts.database.insert()
        // 这里设置需要保存的用户信息（记得到AppDatabase.xcdatamodeld配置字段）
        customer.token = token
        ts.database.save()
    }
    
    func get() {
        let results: [AppCustomer]? = ts.database.searchAll()
        if let customer = results?.first {
            token = customer.token ?? ""
        }
    }
    
    func delete() {
        let results: [AppCustomer]? = ts.database.searchAll()
        if let results = results {
            for customer in results {
                ts.database.delete(object: customer)
            }
            ts.database.save()
        }
        token = ""
        // 这里清除记录的用户信息
    }
    
    func update() {
        if token.isEmpty {
            delete()
            return
        }
        // 这里执行刷新用户信息
    }
    
}
