//
//  TSScoket.swift
//  JunxinStock
//
//  Created by mc on 2018/11/30.
//  Copyright © 2018 张玉飞. All rights reserved.
//

import Foundation
import CocoaAsyncSocket


protocol TSSocketDelegate: NSObjectProtocol {
    func didConnect()
    func didDisconnent()
    func didReceive(message: String)
}

class TSSocket: NSObject, GCDAsyncSocketDelegate {
    /// 主机地址
    let host: String
    /// 端口号
    let port: UInt16
    /// 异步socket
    var socket: GCDAsyncSocket!
    
    weak var delegate: TSSocketDelegate? = nil
    
    /// 初始化
    init(host: String, port: UInt16) {
        self.host = host
        self.port = port
        super.init()
        socket = GCDAsyncSocket(delegate: self, delegateQueue: DispatchQueue.main)
    }
    
    
    /// 发送消息
    func send(message: String) {
        connect()
        socket.write(message.data(using: .utf8)!, withTimeout: -1, tag: 0)
    }
    
    func connect() {
        if !socket.isConnected {
            try? socket.connect(toHost: host, onPort: port)
        }
    }
    
    /// 断开socket
    func disconnect() {
        if socket.isConnected {
            socket.disconnect()
        }
    }
    
    /// 代理函数
    func socket(_ sock: GCDAsyncSocket, didConnectToHost host: String, port: UInt16) {
        delegate?.didConnect()
        sock.readData(withTimeout: -1, tag: 0)
    }
    
    func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) {
        if let message = String(data: data, encoding: .utf8) {
            delegate?.didReceive(message: message)
        }
        sock.readData(withTimeout: -1, tag: 0)
    }
    func socketDidDisconnect(_ sock: GCDAsyncSocket, withError err: Error?) {
        delegate?.didDisconnent()
    }
}
