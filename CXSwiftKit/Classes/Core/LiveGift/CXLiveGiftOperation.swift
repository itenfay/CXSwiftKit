//
//  CXLiveGiftOperation.swift
//  CXSwiftKit
//
//  Created by Teng Fei on 2023/3/16.
//

#if os(iOS)
import UIKit

class CXLiveGiftOperation: Operation {
    
    var dataSource: CXLiveGiftModel?
    var giftView: CXLiveGiftView?
    var atView: UIView?
    
    var operationEndCallBack: ((Bool, String) -> Void)? = nil
    
    override var isExecuting: Bool {
        return _isExecuting
    }
    
    override var isFinished: Bool {
        return _isFinished
    }
    
    private var _isExecuting: Bool {
        willSet { willChangeValue(forKey: "isExecuting") }
        didSet { didChangeValue(forKey: "isExecuting") }
    }
    
    private var _isFinished: Bool {
        willSet { willChangeValue(forKey: "isFinished") }
        didSet { didChangeValue(forKey: "isFinished") }
    }
    
    override init() {
        _isExecuting = false
        _isFinished = false
    }
    
    class func addOperation(giftView: CXLiveGiftView, atView: UIView, data: CXLiveGiftModel, completion: @escaping (Bool, String) -> Void) -> CXLiveGiftOperation {
        let op = CXLiveGiftOperation()
        op.giftView = giftView
        op.dataSource = data
        op.atView = atView
        op.operationEndCallBack = completion
        return op
    }
    
    override func start() {
        if isCancelled {
            finish()
            return
        }
        _isExecuting = true
        OperationQueue.main.addOperation {
            if self.atView == nil || self.giftView == nil {
                self.finish()
                return
            }
            self.atView?.addSubview(self.giftView!)
            self.giftView?.show(giftModel: self.dataSource!, isfinished: { [weak self] (value, key) in
                guard let `self` = self else { return }
                self._isFinished = value
                if let callBack = self.operationEndCallBack {
                    callBack(value, key)
                }
            })
        }
    }
    
    func finish() {
        _isFinished = true
    }
    
}

#endif
