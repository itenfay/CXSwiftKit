//
//  DefaultURLSession.swift
//  CXSwiftKit
//
//  Created by Teng Fei on 2023/7/7.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation

class DefaultURLSession: NSObject, URLSessionProtocol {
    
    typealias URLSessionCompletionHandler = (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void
    
    private var urlSessionConfiguration: URLSessionConfiguration!
    private var urlSession: URLSession!
    private var dataTask: URLSessionDataTask?
    private var queue: OperationQueue!
    private var _completionHandler: URLSessionCompletionHandler?
    private var urlResponse: URLResponse?
    private var recvData: Data?
    
    init(urlSessionConfiguration: URLSessionConfiguration, queue: OperationQueue) {
        self.urlSessionConfiguration = urlSessionConfiguration
        self.queue = queue
        super.init()
        self.initializeURLSession()
        self.updataMaxConcurrentCount(5)
    }
    
    convenience override init() {
        self.init(urlSessionConfiguration: .default, queue: OperationQueue())
    }
    
    private func initializeURLSession() {
        urlSession = URLSession(configuration: urlSessionConfiguration, delegate: self, delegateQueue: queue)
    }
    
    func updataMaxConcurrentCount(_ count: Int) {
        queue.maxConcurrentOperationCount = count
    }
    
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        _completionHandler = completionHandler
        dataTask = urlSession.dataTask(with: request)
        return dataTask!
    }
    
}

extension DefaultURLSession: URLSessionDataDelegate {
    
    private func trustServer(_ challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        let protectionSpace = challenge.protectionSpace
        let secTrust = protectionSpace.serverTrust
        
        assert(secTrust != nil)
        
        if let trust = secTrust {
            let urlCredential = URLCredential(trust: trust)
            challenge.sender?.use(urlCredential, for: challenge)
            completionHandler(.useCredential, urlCredential)
        } else {
            completionHandler(.cancelAuthenticationChallenge, nil)
        }
    }
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        let method = challenge.protectionSpace.authenticationMethod
        switch method {
        case NSURLAuthenticationMethodServerTrust: // Perform server trust authentication (certificate validation) for this protection space.
            trustServer(challenge, completionHandler: completionHandler)
        case NSURLAuthenticationMethodClientCertificate: // Use client certificate authentication for this protection space.
            completionHandler(.performDefaultHandling, nil)
        default:
            completionHandler(.performDefaultHandling, nil)
        }
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        urlResponse = response
        completionHandler(.allow)
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        recvData = data
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if error != nil {
            _completionHandler?(nil, nil, error)
            return
        }
        _completionHandler?(recvData, urlResponse, nil)
    }
    
    func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        _completionHandler?(nil, nil, error)
    }
    
}
