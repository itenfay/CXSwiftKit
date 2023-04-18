//
//  CXScalePresentAnimation.swift
//  CXSwiftKit
//
//  Created by chenxing on 2022/8/11.
//

#if canImport(UIKit)
import UIKit

public class CXScalePresentAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    
    @objc public private(set) var touchRect: CGRect = .zero
    
    @objc public override init() {
        super.init()
    }
    
    @objc public func updateTouchRect(_ rect: CGRect) {
        touchRect = rect
    }
    
    @objc public func convertRect(_ listView: UIScrollView, at indexPath: IndexPath) -> Bool {
        return convertRect(listView, atIndexPath: indexPath, toView: UIApplication.shared.cx_currentController?.view)
    }
    
    @objc public func convertRect(_ listView: UIScrollView, atIndexPath indexPath: IndexPath, toView view: UIView?) -> Bool {
        if let tv = listView as? UITableView {
            if let cell = tv.cellForRow(at: indexPath) {
                updateTouchRect(tv.convert(cell.frame, to: view))
                return true
            }
        } else if let cv = listView as? UICollectionView {
            if let cell = cv.cellForItem(at: indexPath) {
                updateTouchRect(cv.convert(cell.frame, to: view))
                return true
            }
        }
        updateTouchRect(.zero)
        return false
    }
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toVC = transitionContext.viewController(forKey: .to)
        else { return }
        
        let containerView = transitionContext.containerView
        containerView.addSubview(toVC.view)
        
        let rectW: CGFloat = 100
        let centerFrame = CGRect(x: (cxScreenWidth - rectW)/2, y: (cxScreenHeight  - rectW)/2, width: rectW, height: rectW)
        let initialFrame = touchRect != .zero ? touchRect : centerFrame
        let finalFrame = transitionContext.finalFrame(for: toVC)
        let duration: TimeInterval = transitionDuration(using: transitionContext)
        
        toVC.view.center = CGPoint.init(x: initialFrame.origin.x + initialFrame.size.width/2, y: initialFrame.origin.y + initialFrame.size.height/2)
        toVC.view.transform = CGAffineTransform.init(scaleX: initialFrame.size.width/finalFrame.size.width, y: initialFrame.size.height/finalFrame.size.height)
        
        //UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1.0, options: .layoutSubviews, animations: {
        //    toVC.view.center = CGPoint.init(x: finalFrame.origin.x + finalFrame.size.width/2, y: finalFrame.origin.y + finalFrame.size.height/2)
        //    toVC.view.transform = CGAffineTransform.init(scaleX: 1.0, y: 1.0)
        //}) { finished in
        //    transitionContext.completeTransition(true)
        //}
        UIView.animate(withDuration: duration, delay: 0.0, options: .layoutSubviews) {
            toVC.view.center = CGPoint.init(x: finalFrame.origin.x + finalFrame.size.width/2, y: finalFrame.origin.y + finalFrame.size.height/2)
            toVC.view.transform = CGAffineTransform.init(scaleX: 1.0, y: 1.0)
        } completion: { finished in
            transitionContext.completeTransition(true)
        }
    }
    
}

#endif
