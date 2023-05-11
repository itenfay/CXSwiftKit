//
//  CXSwipeLeftInteractiveTransition.swift
//  CXSwiftKit
//
//  Created by chenxing on 2022/8/11.
//

#if canImport(UIKit)
import UIKit

public class CXSwipeLeftInteractiveTransition: UIPercentDrivenInteractiveTransition, UIGestureRecognizerDelegate {
    
    @objc public private(set) var interacting: Bool = false
    @objc public var classWhiteList: [AnyClass] = []
    
    @objc public private(set) weak var presentingVC: UIViewController?
    private var viewControllerCenter: CGPoint = .zero
    private var panGesture: UIPanGestureRecognizer?
    
    @objc public override init() {
        super.init()
    }
    
    @objc public func wireTo(viewController: UIViewController) {
        presentingVC = viewController
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        pan.delegate = self
        presentingVC?.view.addGestureRecognizer(pan)
        panGesture = pan
        viewControllerCenter = presentingVC?.view.center ?? CGPoint(x: CGFloat.cx.screenWidth/2, y: CGFloat.cx.screenHeight/2)
    }
    
    @objc public func enablePanGesture(_ isEnabled: Bool) {
        panGesture?.isEnabled = isEnabled
    }
    
    public override var completionSpeed: CGFloat {
        set {}
        get {
            return 1 - percentComplete
        }
    }
    
    @objc private func handlePanGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
        let translation = gestureRecognizer.translation(in: gestureRecognizer.view?.superview)
        if !interacting && (translation.x < 0 || translation.y < 0 || translation.x < translation.y) {
            return
        }
        switch gestureRecognizer.state {
        case .began:
            interacting = true
            break
        case .changed:
            var progress: CGFloat = translation.x / CGFloat.cx.screenWidth
            progress = CGFloat(fminf(fmaxf(Float(progress), 0.0), 1.0))
            let ratio: CGFloat = 1.0 - (progress * 0.5)
            presentingVC?.view.center = CGPoint.init(x: viewControllerCenter.x + translation.x * ratio, y: viewControllerCenter.y + translation.y * ratio)
            presentingVC?.view.transform = CGAffineTransform.init(scaleX: ratio, y: ratio)
            update(progress)
            break
        case .cancelled, .ended:
            var progress: CGFloat = translation.x / CGFloat.cx.screenWidth
            progress = CGFloat(fminf(fmaxf(Float(progress), 0.0), 1.0))
            if progress < 0.2 {
                UIView.animate(withDuration: TimeInterval(progress), delay: 0.0, options: .curveEaseOut, animations: {
                    self.presentingVC?.view.center = CGPoint.init(x:  CGFloat.cx.screenWidth / 2, y: CGFloat.cx.screenHeight / 2)
                    self.presentingVC?.view.transform = CGAffineTransform.init(scaleX: 1.0, y: 1.0)
                }) { finished in
                    self.interacting = false
                    self.cancel()
                }
            } else {
                interacting = false
                finish()
                presentingVC?.dismiss(animated: true, completion: nil)
            }
            break
        default:
            break
        }
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard let touchView = touch.view else {
            return false
        }
        if touchView is UIControl {
            return false
        }
        if let cls = NSClassFromString("UITableViewCellContentView") {
            if touchView.isKind(of: cls)  {
                return false
            }
            if touchView.superview?.isKind(of: cls) == true {
                return false
            }
        }
        for cls in classWhiteList {
            if touchView.superview?.isKind(of: cls) == true {
                return false
            }
        }
        return true
    }
    
}

#endif
