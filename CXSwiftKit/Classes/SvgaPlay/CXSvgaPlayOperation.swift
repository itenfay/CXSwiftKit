//
//  CXSvgaPlayOperation.swift
//  CXSwiftKit
//
//  Created by chenxing on 2022/5/14.
//

#if os(iOS)
import Foundation

public class CXSvgaPlayOperation: Operation {
    
    /// The url for the svga.
    public private(set) var svgaUrl: String?
    /// The name for the svga.
    public private(set) var svgaName: String?
    /// Which bundle is the svga in.
    public private(set) var inBundle: Bundle?
    
    /// The closure for the operation starting.
    private var startInvocation: ((CXSvgaPlayOperation) -> Void)? = nil
    
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
    public class func create(
        withUrl url: String?,
        invocation: @escaping (CXSvgaPlayOperation) -> Void) -> CXSvgaPlayOperation
    {
        let op = CXSvgaPlayOperation()
        op.svgaUrl = url
        op.startInvocation = invocation
        return op
    }
    
    /// Creates an operation for the svga.
    public class func create(
        withName name: String?,
        inBundle bundle: Bundle?,
        invocation: @escaping (CXSvgaPlayOperation) -> Void) -> CXSvgaPlayOperation
    {
        let op = CXSvgaPlayOperation()
        op.svgaName = name
        op.inBundle = bundle
        op.startInvocation = invocation
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
            self.startInvocation?(self)
        }
    }
    
    public func finish() {
        _isFinished = true
    }
    
}

#endif
