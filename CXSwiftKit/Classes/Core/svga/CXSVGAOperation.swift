//
//  CXSVGAOperation.swift
//  CXSwiftKit
//
//  Created by chenxing on 2022/5/14.
//

#if os(iOS) && canImport(Foundation)
import Foundation

public class CXSVGAOperation: Operation {
    
    /// The url for the svga.
    public private(set) var svgaUrl: String?
    /// The name for the svga.
    public private(set) var svgaName: String?
    /// Which bundle is the svga in.
    public private(set) var inBundle: Bundle?
    
    /// The callback for the operation starting.
    private var onStartCallback: ((_ op: CXSVGAOperation) -> Void)? = nil
    
    /// Whether the operation is executing.
    override public var isExecuting: Bool {
        return _isExecuting
    }
    
    /// Whether the operation is finished.
    override public var isFinished: Bool {
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
    
    /// Creates an operation for the svga.
    public class func create(withUrl url: String?, callback: @escaping (CXSVGAOperation) -> Void) -> CXSVGAOperation {
        let op = CXSVGAOperation()
        op.svgaUrl = url
        op.onStartCallback = callback
        return op
    }
    
    /// Creates an operation for the svga.
    public class func create(withName name: String?, inBundle bundle: Bundle?, callback: @escaping (CXSVGAOperation) -> Void) -> CXSVGAOperation {
        let op = CXSVGAOperation()
        op.svgaName = name
        op.inBundle = bundle
        op.onStartCallback = callback
        return op
    }
    
    override public init() {
        _isExecuting = false
        _isFinished = false
    }
    
    override public func start() {
        if isCancelled {
            finish()
            return
        }
        _isExecuting = true
        OperationQueue.main.addOperation {
            self.onStartCallback?(self)
        }
    }
    
    public func finish() {
        _isFinished = true
    }
    
}

#endif
