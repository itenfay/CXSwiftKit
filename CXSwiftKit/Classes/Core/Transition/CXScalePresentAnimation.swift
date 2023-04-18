//
//  CXScalePresentAnimation.swift
//  CXSwiftKit
//
//  Created by chenxing on 2022/8/11.
//

#if canImport(UIKit)
import UIKit

//MARK: - Begin of example

//public class CXBaseController: UIViewController {}

//public class CXBaseTransitionController: CXBaseController {
//    let scalePresentAnimation = CXScalePresentAnimation()
//    let scaleDismissAnimation = CXScaleDismissAnimation()
//    let swipeLeftInteractiveTransition = CXSwipeLeftInteractiveTransition()
//}

//extension CXBaseTransitionController: UIViewControllerTransitioningDelegate {
//
//    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        return scalePresentAnimation
//    }
//
//    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        scaleDismissAnimation.updateFinalRect(scalePresentAnimation.touchRect)
//        return scaleDismissAnimation
//    }
//
//    public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
//        return swipeLeftInteractiveTransition.interacting ? swipeLeftInteractiveTransition : nil
//    }
//}

//public class CXVideosController: CXBaseTransitionController, UITableViewDelegate, UITableViewDataSource {
//
//    private lazy var tableView: UITableView = {
//        let tableView = UITableView(frame: CGRect.zero)
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.separatorStyle = .none
//        tableView.backgroundColor = .clear
//        if #available(iOS 11.0, *) {
//            tableView.contentInsetAdjustmentBehavior = .never
//        }
//        tableView.rowHeight = UITableView.automaticDimension
//        tableView.estimatedRowHeight = 50
//        return tableView
//    }()
//
//    public func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//
//    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 10
//    }
//
//    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        return UITableViewCell()
//    }
//
//    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        _ = scalePresentAnimation.updateRect(with: tableView, indexPath: indexPath, inView: view)
//        let vc = CXBaseController()
//        self.present(vc, animated: true, completion: nil)
//    }
//
//}

//MARK: - End of example

public class CXScalePresentAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    
    @objc public private(set) var touchRect: CGRect = .zero
    
    @objc public override init() {
        super.init()
    }
    
    @objc public func updateTouchRect(_ rect: CGRect) {
        touchRect = rect
    }
    
    @objc public func updateRect(with listView: UIScrollView, indexPath: IndexPath) -> Bool {
        return updateRect(with: listView, indexPath: indexPath, inView: UIApplication.shared.cx_currentController?.view)
    }
    
    @objc public func updateRect(with listView: UIScrollView, indexPath: IndexPath, inView view: UIView?) -> Bool {
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
        } else {
            updateTouchRect(.zero)
        }
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
