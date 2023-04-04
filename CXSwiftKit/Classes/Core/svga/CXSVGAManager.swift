//
//  CXSVGAManager.swift
//  CXSwiftKit
//
//  Created by chenxing on 2022/5/14.
//

#if os(iOS) && canImport(SVGAPlayer)
import SVGAPlayer

@objc public protocol CXSVGAPlayPresentable: NSObjectProtocol {
    @objc var svgaPlayer: SVGAPlayer? { get set }
}

public class CXSVGAManager: NSObject, CXSVGAPlayPresentable {
    
    @objc public static let shared = CXSVGAManager()
    
    @objc public private(set) var svgaParser: SVGAParser!
    
    @objc public weak var svgaPlayer: SVGAPlayer? {
        didSet {
            svgaPlayer?.delegate = self
        }
    }
    
    private override init() {
        svgaParser = SVGAParser()
    }
    
    private var currentOperation: CXSVGAOperation?
    private var retryCount: Int8 = 3
    @objc public var svgaAnimatedToPercentageHandler: ((_ percentage: CGFloat) -> Void)?
    
    private lazy var queue: OperationQueue = {
        let queue = OperationQueue.init()
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
    
    @objc public func playWithUrl(_ url: String?, loops: Int = 1, clearsAfterStop: Bool = true) {
        svgaPlayer?.loops = Int32(loops)
        svgaPlayer?.clearsAfterStop = clearsAfterStop
        let operation = CXSVGAOperation.create(withUrl: url) { [weak self] op in
            self?.currentOperation = op
            self?.play(withOperation: op)
        }
        queue.addOperation(operation)
    }
    
    @objc public func playWithName(_ name: String?, inBundle bundle: Bundle? = nil, loops: Int = 1, clearsAfterStop: Bool = true) {
        svgaPlayer?.loops = Int32(loops)
        svgaPlayer?.clearsAfterStop = clearsAfterStop
        let operation = CXSVGAOperation.create(withName: name, inBundle: bundle) { [weak self] op in
            self?.currentOperation = op
            self?.play(withOperation: op)
        }
        queue.addOperation(operation)
    }
    
    private func play(withOperation op: CXSVGAOperation) {
        if let url = op.svgaUrl, !url.isEmpty {
            svgaParser.parse(with: URL.init(string: url)!) { videoItem in
                let manager = CXSVGAManager.shared
                manager.svgaPlayer?.isHidden = false
                manager.svgaPlayer?.videoItem = videoItem
                manager.svgaPlayer?.startAnimation()
            } failureBlock: { error in
                let manager = CXSVGAManager.shared
                if error != nil {
                    CXLogger.log(level: .error, message: "error=\(error!)")
                }
                manager.retryToPlayWithOperation(op)
            }
        } else if let name = op.svgaName, !name.isEmpty {
            svgaParser.parse(withNamed: name, in: op.inBundle) { videoItem in
                let manager = CXSVGAManager.shared
                if videoItem != nil {
                    manager.svgaPlayer?.isHidden = false
                    manager.svgaPlayer?.videoItem = videoItem
                    manager.svgaPlayer?.startAnimation()
                } else {
                    manager.finish()
                }
            } failureBlock: { error in
                let manager = CXSVGAManager.shared
                if error != nil {
                    CXLogger.log(level: .error, message: "error=\(error!)")
                }
                manager.retryToPlayWithOperation(op)
            }
        } else {
            finish()
        }
    }
    
    private func retryToPlayWithOperation(_ op: CXSVGAOperation) {
        if retryCount == 0 {
            finish()
        } else {
            retryCount -= 1
            play(withOperation: op)
        }
    }
    
    @objc public func finish() {
        retryCount = 3
        currentOperation?.finish()
        currentOperation = nil
        svgaPlayer?.isHidden = true
    }
    
}

extension CXSVGAManager: SVGAPlayerDelegate {
    
    func svgaPlayerDidFinishedAnimation(_ player: SVGAPlayer!) {
        finish()
    }
    
    func svgaPlayer(_ player: SVGAPlayer!, didAnimatedToPercentage percentage: CGFloat) {
        svgaAnimatedToPercentageHandler?(percentage)
    }
    
}

extension SVGAPlayer {
    
    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        if hitView == self {
            return nil
        }
        return hitView
    }
    
}

#endif
