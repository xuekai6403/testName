//
//  TcpHelper.swift
//  HiBulb
//
//  Created by qinzhe on 2018/4/4.
//  Copyright © 2018年 qinzhe. All rights reserved.
//
import Foundation
import CocoaAsyncSocket

protocol TcpClientDelegate {
    func tcpReceivedRawData(devId: String, data: Data)
    func tcpReceivedData(devId: String, recvData: String)
    func tcpDidConnected(devId: String)
    func tcpDidDisconnected(devId: String)
    func tcpSendHook(id: String, content: String)
}

class TcpHelper: NSObject {
    var serverPort: UInt16 = 5555
    var clientSocket: GCDAsyncSocket?
    var device_id: String
    var ip: String
    var connDelegate: TcpClientDelegate?
    var writeFailedCount = 0
    var isReconnect = true
    var reconnectMaxCount = 0
        
    init(device_id: String, ip: String, port: UInt16 = Constants.UDP_PORT) {
        self.device_id = device_id
        self.ip = ip
        self.serverPort = port
        super.init()
        self.tcpConnect()
    }

    func tcpConnect() {
        if clientSocket != nil  {
            clientSocket!.delegate = nil
            clientSocket!.disconnect()
            clientSocket = nil
        }
        clientSocket = GCDAsyncSocket.init(delegate: self, delegateQueue: DispatchQueue.global())
        do {
            try clientSocket?.connect(toHost: ip, onPort: serverPort)
        } catch {
            //print("connect error: \(error)")
            //tcpConnect()
        }
    }
    

    
    // 发送消息按钮事件 {"cmd":4}\r\n
    func tcpSend(cmd: String) {
//        if(clientSocket.isConnected) {
//            clientSocket.write(cmd.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!, withTimeout: -1, tag: 0)
//        }
        //print("======\(device_id) sendData: \(cmd)")
        sendData(data: cmd.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!)
        self.connDelegate?.tcpSendHook(id: device_id, content: cmd)
    }
    
    func sendData(data: Data) {
        //print("====== sendData: <\(data)>, port: \(serverPort)")
        clientSocket?.write(data, withTimeout: -1, tag: 0)
        clientSocket?.readData(withTimeout: -1, tag: 0)
    }
    
    func tcpSend(buff: [UInt8]) {
        let data = Data(buff)
        //Debug.shared.println("send buff count: \(buff.count)")
        //Debug.shared.printHex(data: buff)
        sendData(data: data)
    }
    
    func isConnected() -> Bool {
        return clientSocket?.isConnected ?? false
    }
    
    func disconnect() {
        self.isReconnect = false
        clientSocket?.disconnect()
    }
    
    func reconnect() {
        
//        //重连之前先断开连接
//        if self.clientSocket != nil {
//            self.clientSocket!.delegate = nil
//            self.clientSocket!.disconnect()
//            self.clientSocket = nil
//        }
//
//        //控制连接最大连接次数
//        guard reconnectMaxCount < 5 else {
//            reconnectMaxCount = 0
//            return
//        }
//
//        self.tcpConnect()
//
//        reconnectMaxCount += 1
    }
}
//MARK:- GCDAsyncSocketDelegate
extension TcpHelper: GCDAsyncSocketDelegate{
    ///TCP连接成功
    func socket(_ sock: GCDAsyncSocket, didConnectToHost host: String, port: UInt16) -> Void {
        sock.readData(withTimeout: -1, tag: 0)
        connDelegate?.tcpDidConnected(devId: device_id)
        reconnectMaxCount = 0
    }
    ///TCP断开连接
    func socketDidDisconnect(_ sock: GCDAsyncSocket, withError err: Error?) -> Void {
        print("socket 断开连接")
        connDelegate?.tcpDidDisconnected(devId: device_id)
        if !isReconnect {   //如果主动断开，就不重连
            return
        }
        //重连
        reconnect()
        print("TCPHELPER\(String(describing: clientSocket?.isConnected))\r\n reconnect 3 seconds later")

    }
    
    //read timeout
    func socket(_ sock: GCDAsyncSocket, shouldTimeoutReadWithTag tag: Int, elapsed: TimeInterval, bytesDone length: UInt) -> TimeInterval {
        return elapsed
    }
    // write timeout
    func socket(_ sock: GCDAsyncSocket, shouldTimeoutWriteWithTag tag: Int, elapsed: TimeInterval, bytesDone length: UInt) -> TimeInterval {
        return elapsed
    }

    func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) -> Void {
        // 1、获取客户端发来的数据，把 NSData 转 NSString
        if let readClientDataString = String(data: data as Data, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue)) {
            //print("Data Recv: ", data, " port: ", serverPort)
            self.connDelegate?.tcpReceivedData(devId: device_id, recvData: readClientDataString)
        }
        self.connDelegate?.tcpReceivedRawData(devId: device_id, data: data)
        
        // 3、处理请求，返回数据给客户端OK
        //        let serviceStr: NSMutableString = NSMutableString()
        //        serviceStr.append("OK")
        //        serviceStr.append("\r\n")
        //        clientSocket.write(serviceStr.data(using: String.Encoding.utf8.rawValue)!, withTimeout: -1, tag: 0)
        
        // 4、每次读完数据后，都要调用一次监听数据的方法
        sock.readData(withTimeout: -1, tag: 0)
    }
    
    func socket(_ sock: GCDAsyncSocket, didWriteDataWithTag tag: Int) {
        Debug.shared.println("didWriteDataWithTag ...")
        sock.readData(withTimeout: -1, tag: 0)
    }
}
