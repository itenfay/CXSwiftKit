//
//  CXWebSocket.swift
//  CXSwiftKit
//
//  Created by chenxing on 2022/11/18.
//

#if canImport(Foundation) && canImport(Starscream)
import Foundation
import Starscream

@objc public protocol CXWebSocketDelegate: AnyObject {
    @objc func cxWebSocketDidReceiveMessage(_ message: String)
    @objc func cxWebSocketDidReceiveData(_ data: Data)
    @objc func cxWebSocketDidFailWithError(_ error: Error?)
    @objc func cxWebSocketDidDisconnect(_ code: UInt16, reason: String)
}

public class CXWebSocket: NSObject {
    
    private var socket: WebSocket?
    private var autoReconnect: Bool = false
    private var reconnectTime: TimeInterval = 0
    private var heartbeatTimer: Timer?
    
    @objc public private(set) var isConnected = false
    @objc public private(set) var urlString: String
    
    @objc public var timeoutInterval: TimeInterval = 10
    @objc public var reconnectMaxTime: TimeInterval = 30
    @objc public var heartbeatDuration: TimeInterval = 10
    @objc public var heartbeatWork: (() -> Void)?
    
    @objc public private(set) var networkReachable: Bool = true
    @objc public weak var delegate: CXWebSocketDelegate?
    
    @objc public init(urlString: String) {
        self.urlString = urlString
        super.init()
    }
    
    @objc public func open() {
        autoReconnect = true
        connect()
    }
    
    @objc public func close() {
        autoReconnect = false
        disconnect()
    }
    
    /// The exterior notifies network status has changed.
    @objc public func notifyNetworkStatusChanged(_ reachable: Bool) {
        networkReachable = reachable
        if !reachable {
            disconnect()
        } else {
            connect()
        }
    }
    
    private func connect() {
        if isConnected { return }
        if let request = customURLRequest() {
            socket = WebSocket(request: request)
        } else {
            guard let url = URL(string: urlString) else {
                CXLogger.log(level: .error, message: "[WS] Occurs an error: the url is null.")
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
    
    /// Override
    @objc public func customURLRequest() -> URLRequest? {
        return nil
    }
    
    private func disconnect() {
        destroyHeartbeat()
        socket?.disconnect()
        resetConnectTime()
        isConnected = false
    }
    
    @objc public func sendMessage(_ message: String) {
        // Disconnected, unable to send message.
        if !isConnected {
            CXLogger.log(level: .warning, message: "WS is disconnected, unable to send message.")
            return
        }
        socket?.write(string: message)
    }
    
    @objc public func sendData(_ data: Data) {
        // Disconnected, unable to send data.
        if !isConnected {
            CXLogger.log(level: .warning, message: "WS is disconnected, unable to send data.")
            return
        }
        socket?.write(data: data)
    }
    
    /// Start the heartbeat packets.
    @objc public func startHeartbeat() {
        if heartbeatDuration <= 0 { return }
        if heartbeatTimer != nil { return }
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
    private func destroyHeartbeat() {
        heartbeatTimer?.invalidate()
        heartbeatTimer = nil
    }
    
    @objc public func reconnect() {
        if !autoReconnect { return }
        // The reconnection interval can be adjusted according to the business.
        if reconnectTime > reconnectMaxTime {
            reconnectTime = reconnectMaxTime
        }
        
        DispatchQueue.cx.mainAsyncAfter(reconnectTime) {
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
        CXLogger.log(level: .info, message: "[WS] \(type(of: self)) deinit.")
    }
    
}

extension CXWebSocket: WebSocketDelegate {
    
    public func didReceive(event: Starscream.WebSocketEvent, client: Starscream.WebSocket) {
        switch event {
        case .connected(let headers):
            CXLogger.log(level: .info, message: "[WS] Websocket is connected: \(headers)")
            isConnected = true
            resetConnectTime()
            startHeartbeat()
        case .disconnected(let reason, let code):
            CXLogger.log(level: .info, message: "[WS] Websocket is disconnected: \(reason) with code: \(code)")
            isConnected = false
            self.delegate?.cxWebSocketDidDisconnect(code, reason: reason)
        case .text(let text):
            CXLogger.log(level: .info, message: "[WS] Received text: \(text)")
            self.delegate?.cxWebSocketDidReceiveMessage(text)
        case .binary(let data):
            CXLogger.log(level: .info, message: "[WS] Received data: \(data.count)")
            self.delegate?.cxWebSocketDidReceiveData(data)
        case .ping(_):
            CXLogger.log(level: .info, message: "[WS] Ping")
            break
        case .pong(_):
            CXLogger.log(level: .info, message: "[WS] Pong")
            break
        case .viabilityChanged(_):
            CXLogger.log(level: .info, message: "[WS] ViabilityChanged")
            break
        case .reconnectSuggested(_):
            CXLogger.log(level: .info, message: "[WS] ReconnectSuggested")
            break
        case .cancelled:
            isConnected = false
            CXLogger.log(level: .info, message: "[WS] ReconnectSuggested")
        case .error(let error):
            isConnected = false
            handleError(error)
        }
    }
    
    private func handleError(_ error: Error?) {
        if let e = error as? WSError {
            CXLogger.log(level: .error, message: "[WS] websocket encountered an error: \(e.message)")
        } else if let e = error {
            CXLogger.log(level: .error, message: "[WS] websocket encountered an error: \(e.localizedDescription)")
        } else {
            CXLogger.log(level: .error, message: "[WS] websocket encountered an error")
        }
        self.delegate?.cxWebSocketDidFailWithError(error)
    }
    
}

#endif
