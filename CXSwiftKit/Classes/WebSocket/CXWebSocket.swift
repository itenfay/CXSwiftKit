//
//  CXWebSocket.swift
//  CXSwiftKit
//
//  Created by chenxing on 2022/11/18.
//

import Foundation
#if canImport(Starscream)
import Starscream

@objc public protocol CXWebSocketDelegate: AnyObject {
    func cxWebSocketDidConnect(_ headers: [String : String])
    func cxWebSocketDidDisconnect(_ code: UInt16, reason: String)
    func cxWebSocketDidReceiveMessage(_ message: String)
    func cxWebSocketDidReceiveData(_ data: Data)
    func cxWebSocketDidCancel()
    func cxWebSocketDidFailWithError(_ error: Error?)
}

@objc public protocol ISKWebSocket: AnyObject {
    static var networkStatusDidChangeNotification: Notification.Name { get }
    init(urlString: String)
    var urlString: String { get }
    var timeoutInterval: TimeInterval { get set }
    var reconnectMaxTime: TimeInterval { get set }
    var heartbeatDuration: TimeInterval { get set }
    var isConnected: Bool { get }
    var networkReachable: Bool { get }
    var heartbeatWork: (() -> Void)? { get set }
    func configureRequest(handler: @escaping () -> URLRequest)
    func open()
    func close()
    func reconnect()
    func startHeartbeat()
    func destroyHeartbeat()
    func sendMessage(_ message: String)
    func sendData(_ data: Data)
}

public class CXWebSocket: NSObject, ISKWebSocket {
    
    private var socket: WebSocket?
    private var customRequest: URLRequest?
    
    private var autoReconnect: Bool = false
    private var reconnectTime: TimeInterval = 0
    private var heartbeatTimer: Timer?
    
    public private(set) var isConnected = false
    public private(set) var urlString: String
    
    public var timeoutInterval: TimeInterval = 10
    public var reconnectMaxTime: TimeInterval = 30
    public var heartbeatDuration: TimeInterval = 10
    public var heartbeatWork: (() -> Void)?
    
    public private(set) var networkReachable: Bool = true
    public weak var delegate: CXWebSocketDelegate?
    
    public static var networkStatusDidChangeNotification: Notification.Name {
        return Notification.Name("CXNetworkStatusDidChangeNotification")
    }
    
    public required init(urlString: String) {
        self.urlString = urlString
        super.init()
        self.addNotification()
    }
    
    public func open() {
        autoReconnect = true
        connect()
    }
    
    public func close() {
        autoReconnect = false
        disconnect()
    }
    
    private func addNotification() {
        NotificationCenter.default
            .addObserver(self,
                         selector: #selector(notifyNetworkStatusChanged(_:)),
                         name: Self.networkStatusDidChangeNotification,
                         object: nil)
    }
    
    /// The exterior notifies network status has changed.
    @objc private func notifyNetworkStatusChanged(_ noti: Notification) {
        let notiObject = noti.object
        if let nsNumber = notiObject as? NSNumber {
            networkReachable = nsNumber.boolValue
            executeChange()
        } else if let bValue = notiObject as? Bool {
            networkReachable = bValue
            executeChange()
        }
    }
    
    private func executeChange() {
        if !networkReachable {
            disconnect()
        } else {
            reconnect()
        }
    }
    
    /// Connect the web socket.
    private func connect() {
        if isConnected { return }
        if let request = customRequest {
            socket = WebSocket(request: request)
        } else {
            guard let url = URL(string: urlString) else {
                debugPrint("[E] " + "[WS] WS occurs an error: the url is null.")
                delegate?.cxWebSocketDidFailWithError(nil)
                return
            }
            var request = URLRequest(url: url)
            request.timeoutInterval = timeoutInterval
            request.cachePolicy = .useProtocolCachePolicy
            socket = WebSocket(request: request)
        }
        socket?.delegate = self
        socket?.connect()
    }
    
    /// Configure the custom request.
    public func configureRequest(handler: @escaping () -> URLRequest) {
        customRequest = handler()
    }
    
    /// Disconnect the web socket.
    private func disconnect() {
        destroyHeartbeat()
        socket?.disconnect()
        resetConnectTime()
        isConnected = false
    }
    
    public func sendMessage(_ message: String) {
        // Disconnected, unable to send message.
        if !isConnected {
            debugPrint("[I] " + "[WS] WS is disconnected, unable to send message.")
            return
        }
        socket?.write(string: message)
    }
    
    public func sendData(_ data: Data) {
        // Disconnected, unable to send data.
        if !isConnected {
            debugPrint("[I] " + "[WS] WS is disconnected, unable to send data.")
            return
        }
        socket?.write(data: data)
    }
    
    /// Start the heartbeat packets.
    public func startHeartbeat() {
        if heartbeatDuration <= 0 {
            return
        }
        if heartbeatTimer != nil {
            return
        }
        heartbeatTimer = Timer(timeInterval: heartbeatDuration,
                               target: self,
                               selector: #selector(sendHeartbeatAction),
                               userInfo: nil,
                               repeats: true)
        heartbeatTimer?.fireDate = Date.distantPast
        RunLoop.current.add(heartbeatTimer!, forMode: .common)
    }
    
    /// The action is used to send the heartbeat packets.
    @objc private func sendHeartbeatAction() {
        heartbeatWork?()
    }
    
    /// Destroy the heartbeat when disconnected.
    public func destroyHeartbeat() {
        if heartbeatTimer == nil {
            return
        }
        heartbeatTimer?.invalidate()
        heartbeatTimer = nil
    }
    
    /// Reconnect the web socket.
    public func reconnect() {
        if !autoReconnect { return }
        // The reconnection interval can be adjusted according to the business.
        if reconnectTime > reconnectMaxTime {
            reconnectTime = reconnectMaxTime
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + reconnectTime) {
            self.socket = nil
            self.connect()
        }
        
        if reconnectTime == 0 {
            reconnectTime = 2
        } else {
            reconnectTime *= 2
        }
    }
    
    private func resetConnectTime() {
        reconnectTime = 0
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        debugPrint("[I] " + "[WS] \(type(of: self)) deinit.")
    }
    
}

extension CXWebSocket: WebSocketDelegate {
    
    public func didReceive(event: Starscream.WebSocketEvent, client: Starscream.WebSocket) {
        switch event {
        case .connected(let headers):
            debugPrint("[I] " + "[WS] Websocket is connected: \(headers)")
            isConnected = true
            resetConnectTime()
            startHeartbeat()
            delegate?.cxWebSocketDidConnect(headers)
        case .disconnected(let reason, let code):
            debugPrint("[I] " + "[WS] Websocket is disconnected: \(reason) with code: \(code)")
            isConnected = false
            delegate?.cxWebSocketDidDisconnect(code, reason: reason)
        case .text(let text):
            debugPrint("[I] " + "[WS] Received text: \(text)")
            delegate?.cxWebSocketDidReceiveMessage(text)
        case .binary(let data):
            debugPrint("[I] " + "[WS] Received data: \(data.count)")
            delegate?.cxWebSocketDidReceiveData(data)
        case .ping(_):
            debugPrint("[I] " + "[WS] Ping")
        case .pong(_):
            debugPrint("[I] " + "[WS] Pong")
        case .viabilityChanged(_):
            debugPrint("[I] " + "[WS] ViabilityChanged")
        case .reconnectSuggested(_):
            debugPrint("[I] " + "[WS] ReconnectSuggested")
        case .cancelled:
            debugPrint("[I] " + "[WS] Cancelled")
            isConnected = false
            delegate?.cxWebSocketDidCancel()
        case .error(let error):
            isConnected = false
            handleError(error)
        }
    }
    
    private func handleError(_ error: Error?) {
        if let e = error as? WSError {
            debugPrint("[E] " + "[WS] websocket encountered an error: \(e.message)")
        } else if let e = error {
            debugPrint("[E] " + "[WS] websocket encountered an error: \(e.localizedDescription)")
        } else {
            debugPrint("[E] " + "[WS] websocket encountered an error")
        }
        delegate?.cxWebSocketDidFailWithError(error)
    }
    
}

#endif
