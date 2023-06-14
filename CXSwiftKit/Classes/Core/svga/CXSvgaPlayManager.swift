//
//  CXSvgaPlayManager.swift
//  CXSwiftKit
//
//  Created by chenxing on 2022/5/14.
//

#if os(iOS)
import UIKit
#if canImport(SVGAPlayer)
import SVGAPlayer

@objc public protocol CXSvgaPlayPresentable: AnyObject {
    var svgaPlayer: SVGAPlayer? { get set }
}

public class CXSvgaPlayManager: NSObject, CXSvgaPlayPresentable {
    
    @objc public static let shared = CXSvgaPlayManager()
    
    @objc public private(set) var svgaParser: SVGAParser!
    
    @objc public weak var svgaPlayer: SVGAPlayer? {
        didSet {
            svgaPlayer?.delegate = self
        }
    }
    
    private override init() {
        svgaParser = SVGAParser()
    }
    
    @objc public var svgaAnimatedToPercentageHandler: ((_ percentage: CGFloat) -> Void)?
    
    private var currentOp: CXSvgaPlayOperation?
    private var retryCount: Int8 = 3
    private var animationFinished: Bool = false
    private let mutex = DispatchSemaphore(value: 1)
    
    private lazy var queue: OperationQueue = {
        let queue = OperationQueue.init()
        queue.maxConcurrentOpCount = 1
        return queue
    }()
    
    @objc public func playWithUrl(_ url: String?, loops: Int = 1, clearsAfterStop: Bool = true) {
        svgaPlayer?.loops = Int32(loops)
        svgaPlayer?.clearsAfterStop = clearsAfterStop
        let operation = CXSvgaPlayOperation.create(withUrl: url) { [unowned self] op in
            self.currentOp = op
            self.play(with: op)
        }
        queue.addOperation(operation)
    }
    
    @objc public func playWithName(_ name: String?, inBundle bundle: Bundle? = nil, loops: Int = 1, clearsAfterStop: Bool = true) {
        svgaPlayer?.loops = Int32(loops)
        svgaPlayer?.clearsAfterStop = clearsAfterStop
        let operation = CXSvgaPlayOperation.create(withName: name, inBundle: bundle) { [unowned self] op in
            self.currentOp = op
            self.play(with: op)
        }
        queue.addOperation(operation)
    }
    
    private func play(with op: CXSvgaPlayOperation) {
        if let url = op.svgaUrl, !url.isEmpty {
            svgaParser.parse(with: URL.init(string: url)!) { [unowned self] videoItem in
                self.displaySvga(withHidden: false)
                self.svgaPlayer?.videoItem = videoItem
                self.svgaPlayer?.startAnimation()
            } failureBlock: { [unowned self] error in
                if error != nil {
                    CXLogger.log(level: .error, message: "error=\(error!)")
                }
                self.retryToplay(with: op)
            }
        } else if let name = op.svgaName, !name.isEmpty {
            svgaParser.parse(withNamed: name, in: op.inBundle) { [unowned self] videoItem in
                if videoItem != nil {
                    self.displaySvga(withHidden: false)
                    self.svgaPlayer?.videoItem = videoItem
                    self.svgaPlayer?.startAnimation()
                } else {
                    self.finishAnimating()
                }
            } failureBlock: { [unowned self] error in
                if error != nil {
                    CXLogger.log(level: .error, message: "error=\(error!)")
                }
                self.retryToplay(with: op)
            }
        } else {
            finishAnimating()
        }
    }
    
    private func retryToplay(with op: CXSvgaPlayOperation) {
        if retryCount == 0 {
            finishAnimating()
        } else {
            retryCount -= 1
            play(with: op)
        }
    }
    
    @objc public func finishAnimating() {
        mutex.wait()
        retryCount = 3
        currentOp?.finish()
        currentOp = nil
        if animationFinished {
            animationFinished = false
        } else {
            DispatchQueue.main.async {
                self.clearSvga()
            }
        }
        DispatchQueue.main.async {
            self.displaySvga(withHidden: true)
        }
        mutex.signal()
    }
    
    private func clearSvga() {
        svgaPlayer?.stopAnimation()
        if svgaPlayer?.clearsAfterStop == false {
            svgaPlayer?.clear()
        }
    }
    
    private func displaySvga(withHidden hidden: Bool) {
        svgaPlayer?.isHidden = hidden
    }
    
}

extension CXSvgaPlayManager: SVGAPlayerDelegate {
    
    func svgaPlayerDidFinishedAnimation(_ player: SVGAPlayer!) {
        animationFinished = true
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
#endif
