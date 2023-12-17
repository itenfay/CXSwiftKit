//
//  CXSwipeInteractor.swift
//  CXSwiftKit
//
//  Created by chenxing on 2022/8/12.
//

#if os(iOS) || os(tvOS)
import UIKit

public class CXSwipeInteractor: NSObject {
    
    private var beginPoint: CGPoint = .zero
    private var onCompletionHandler: ((UISwipeGestureRecognizer.Direction, Bool) -> Void)?
    /// The value represents the action can be triggered.
    @objc public var triggeredValue: CGFloat = 80
    
    @objc public override init() {
        super.init()
    }
    
    @objc public func observe(completionHandler: @escaping (_ direction: UISwipeGestureRecognizer.Direction, _ dismiss: Bool) -> Void) {
        onCompletionHandler = completionHandler
    }
    
    @objc public func addSwipeGesture(for view: UIView, direction: UISwipeGestureRecognizer.Direction = .down) {
        let swipeGesture = UISwipeGestureRecognizer.init(target: self, action: #selector(onSwipeAction(_:)))
        swipeGesture.direction = direction
        view.addGestureRecognizer(swipeGesture)
        view.isUserInteractionEnabled = true
    }
    
    @objc private func onSwipeAction(_ gestureRecognizer: UISwipeGestureRecognizer) {
        guard let attachedView = gestureRecognizer.view else {
            return
        }
        let direction = gestureRecognizer.direction
        switch gestureRecognizer.state {
        case .began:
            beginPoint = gestureRecognizer.location(in: attachedView)
            break
        case .changed: break
        case .cancelled: break
        case .ended:
            if attachedView is UIScrollView {
                if let sv = attachedView as? UIScrollView, sv.zoomScale != 1 {
                    return
                } else if let tv = attachedView as? UITableView, tv.zoomScale != 1 {
                    return
                } else if let cv = attachedView as? UICollectionView, cv.zoomScale != 1 {
                    return
                }
            }
            let endPoint = gestureRecognizer.location(in: attachedView)
            if direction == .down {
                if abs(endPoint.y - attachedView.cx.centerY) < triggeredValue {
                    onCompletionHandler?(direction, true)
                }
            } else if direction == .right {
                if abs(endPoint.x - attachedView.cx.left) > triggeredValue {
                    onCompletionHandler?(direction, true)
                }
            }
            break
        default: break
        }
    }
    
}

#endif
