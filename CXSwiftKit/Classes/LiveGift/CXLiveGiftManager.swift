//
//  CXLiveGiftManager.swift
//  CXSwiftKit
//
//  Created by chenxing on 2023/3/16.
//

#if os(iOS)
import UIKit
import Foundation

public class CXLiveGiftManager: NSObject {
    
    let giftMaxCount: Int = 99
    
    lazy var giftQueue1: OperationQueue = {
        let op = OperationQueue()
        op.maxConcurrentOperationCount = 1
        return op
    }()
    
    lazy var giftQueue2: OperationQueue = {
        let op = OperationQueue()
        op.maxConcurrentOperationCount = 1
        return op
    }()
    
    @objc public lazy var topAnimationView: CXLiveGiftView = {
        let view = CXLiveGiftView(frame: CGRect(x: -220, y: cxScreenHeight - 500, width: 240, height: 80))
        view.giftKeyCallBack = { [weak self] model in
            guard let `self` = self else { return }
            self.giftKeys.append(model.giftKey)
        }
        return view
    }()
    
    @objc public lazy var bottomAnimationView: CXLiveGiftView = {
        let view = CXLiveGiftView(frame: CGRect(x: -220, y: cxScreenHeight - 420, width: 240, height: 80))
        view.giftKeyCallBack = { [weak self] model in
            guard let `self` = self else { return }
            self.giftKeys.append(model.giftKey)
        }
        return view
    }()
    
    var operationCache: NSCache<NSString, Operation> = NSCache<NSString, Operation>.init()
    
    lazy var giftKeys: [String] = [String]()
    
    var finishedCallBack: completeBlock? = nil
    
    @objc public static let shared = CXLiveGiftManager()
    
    private override init() {} // super.init()
    
    @objc public func showGiftView(atView: UIView, info: CXLiveGiftModel, completion: @escaping (Bool) -> Void) {
        self.finishedCallBack = completion
        let key = info.giftKey
        let nsKey = NSString(string: info.giftKey)
        // If exists
        if self.giftKeys.count > 0 && self.giftKeys.contains(key)
        {
            if self.operationCache.object(forKey: nsKey) != nil {
                let op: CXLiveGiftOperation = self.operationCache.object(forKey: nsKey) as! CXLiveGiftOperation
                
                if op.giftView?.currentGiftCount ?? 0 >= giftMaxCount {
                    self.operationCache.removeObject(forKey: nsKey)
                    for item in 0 ..< self.giftKeys.count {
                        guard item < self.giftKeys.count else { return }
                        if giftKeys[item].elementsEqual(key) {
                            self.giftKeys.remove(at: item)
                        }
                    }
                } else {
                    op.giftView?.giftCount = info.sendCount
                }
            } else {
                let queue: OperationQueue
                let animationView: CXLiveGiftView
                if self.giftQueue1.operations.count <= self.giftQueue2.operations.count {
                    queue = self.giftQueue1
                    animationView = self.topAnimationView
                } else {
                    queue = self.giftQueue2
                    animationView = self.bottomAnimationView
                }
                
                let operation = CXLiveGiftOperation.addOperation(giftView: animationView, atView: atView, data: info) { [weak self] (finished, giftKey) in
                    guard let `self` = self else { return }
                    
                    if let callBack = self.finishedCallBack {
                        callBack(finished)
                    }
                    self.operationCache.removeObject(forKey: nsKey)
                    guard self.giftKeys.count > 0 else { return }
                    for item in 0 ..< self.giftKeys.count {
                        guard item < self.giftKeys.count else { return }
                        if self.giftKeys[item] == key {
                            self.giftKeys.remove(at: item)
                        }
                    }
                }
                operation.dataSource?.defaultCount += info.sendCount
                self.operationCache.setObject(operation, forKey: nsKey)
                queue.addOperation(operation)
            }
        } else {
            if self.operationCache.object(forKey: nsKey) != nil {
                let op: CXLiveGiftOperation = self.operationCache.object(forKey: nsKey) as! CXLiveGiftOperation
                if op.giftView?.currentGiftCount ?? 0 >= giftMaxCount {
                    self.operationCache.removeObject(forKey: nsKey)
                    guard self.giftKeys.count > 0 else { return }
                    for item in 0 ..< self.giftKeys.count {
                        guard item < self.giftKeys.count else { return }
                        if giftKeys[item].elementsEqual(key) {
                            self.giftKeys.remove(at: item)
                        }
                    }
                } else {
                    op.dataSource?.defaultCount += info.sendCount
                }
            } else {
                let queue: OperationQueue
                let animationView: CXLiveGiftView
                if self.giftQueue1.operations.count <= self.giftQueue2.operations.count {
                    queue = self.giftQueue1
                    animationView = self.topAnimationView
                } else {
                    queue = self.giftQueue2
                    animationView = self.bottomAnimationView
                }
                
                let operation = CXLiveGiftOperation.addOperation(giftView: animationView, atView: atView, data: info) { [weak self] (finished, giftKey) in
                    guard let `self` = self else { return }
                    
                    if let callBack = self.finishedCallBack {
                        callBack(finished)
                    }
                    if self.topAnimationView.giftModel.giftKey.isEqual(self.bottomAnimationView.giftModel.giftKey) {
                        return
                    }
                    
                    self.operationCache.removeObject(forKey: nsKey)
                    guard self.giftKeys.count > 0 else { return }
                    for item in 0 ..< self.giftKeys.count {
                        guard self.giftKeys.count <= item else { return }
                        if self.giftKeys[item] == key {
                            self.giftKeys.remove(at: item)
                        }
                    }
                }
                operation.dataSource?.defaultCount += info.sendCount
                self.operationCache.setObject(operation, forKey: nsKey)
                queue.addOperation(operation)
            }
        }
    }
    
}

#endif
