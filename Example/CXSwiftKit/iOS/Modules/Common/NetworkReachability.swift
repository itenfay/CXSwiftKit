//
//  NetworkReachability.swift
//  CXSwiftKit_Example
//
//  Created by Teng Fei on 2023/7/26.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire
import CXSwiftKit

// An observable that completes when the app gets online (possibly completes immediately).
func connectedToInternet() -> Observable<Bool> {
    return ReachabilityManager.shared.reach
}

public class ReachabilityManager: NSObject {
    
    private override init() {
        super.init()
    }
    
    static let shared = ReachabilityManager()
    
    private let reachSubject = ReplaySubject<Bool>.create(bufferSize: 1)
    
    var reach: Observable<Bool> {
        return reachSubject.asObservable()
    }
    
    var isReachable: Bool {
        return NetworkReachabilityManager.default?.isReachable ?? false
    }
    
    var isWiFi: Bool {
        return NetworkReachabilityManager.default?.isReachableOnEthernetOrWiFi ?? false
    }
    
    func startListening() {
        NetworkReachabilityManager.default?.startListening(onUpdatePerforming: { (status) in
            var reachable = false
            switch status {
            case .notReachable:
                self.reachSubject.onNext(false)
            case .reachable(_):
                reachable = true
                self.reachSubject.onNext(true)
            case .unknown:
                self.reachSubject.onNext(false)
            }
            //self.cx.postNotification(withName: CXWebSocket.networkStatusDidChangeNotification, object: NSNumber(value: reachable))
        })
    }
    
    func stopListening() {
        NetworkReachabilityManager.default?.stopListening()
    }
    
}

