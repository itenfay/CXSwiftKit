//
//  CXEmptyDataSetMediator.swift
//  CXSwiftKit
//
//  Created by chenxing on 2022/5/9.
//

#if canImport(UIKit)
import UIKit
#if canImport(QuartzCore)
import QuartzCore
#endif
#if canImport(DZNEmptyDataSet)
import DZNEmptyDataSet

@objc public protocol CXEmptyDataSetPresentable: AnyObject {
    @objc var listView: UIScrollView? { get set }
}

public class CXEmptyDataSetMediator: NSObject, CXEmptyDataSetPresentable {
    
    /// The current list view.
    @objc public weak var listView: UIScrollView?
    
    /// The style controls the title, title color, image of empty data set, etc.
    @objc public var style: CXEmptyDataSetStyle = CXEmptyDataSetStyle()
    
    /// The boolean value for empty data set.
    @objc public var shouldDisplay: Bool = true
    /// The boolean value for empty data set.
    @objc public var shouldAllowTouch: Bool = true
    /// The boolean value for empty data set.
    @objc public var shouldAllowScroll: Bool = true
    
    /// The reload is default enabled.
    @objc public var reloadEnabled: Bool = true
    
    /// The boolean value controls the refresh of empty data set.
    private var isLoading: Bool = false {
        didSet {
            reloadEmptyDataSet()
        }
    }
    
    /// The closure for reloading data.
    @objc public var onReload: (() -> Void)?
    
    /// Bind the target list view.
    @objc public func bindTarget(_ view: UIScrollView?) {
        listView = view
    }
    
    /// Bind empty data set.
    @objc public func bindEmptyDataSet() {
        listView?.emptyDataSetSource = self
        listView?.emptyDataSetDelegate = self
    }
    
    /// Refresh layout of the target list view.
    @objc public func refreshLayout() {
        guard let view = listView else { return }
        if view.isKind(of: UITableView.self) {
            if let tableView = view as? UITableView {
                tableView.reloadData()
            }
        } else if view.isKind(of: UICollectionView.self) {
            if let collectionView = view as? UICollectionView {
                collectionView.reloadData()
            }
        }
    }
    
    /// Reload the empty data set.
    @objc public func reloadEmptyDataSet() {
        listView?.reloadEmptyDataSet()
    }
    
}

extension CXEmptyDataSetMediator: DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    
    //MARK: - DZNEmptyDataSetSource
    
    public func backgroundColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
        return style.backgroundColor
    }
    
    public func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        if let title = style.title, !title.isEmpty {
            let attrs = [
                NSAttributedString.Key.font : style.titleFont,
                NSAttributedString.Key.foregroundColor : style.titleColor
            ]
            return NSAttributedString.init(string: title, attributes: attrs)
        }
        return nil
    }
    
    public func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        if let description = style.descriptionString, !description.isEmpty {
            let attrs = [
                NSAttributedString.Key.font : style.descriptionFont,
                NSAttributedString.Key.foregroundColor : style.descriptionColor
            ]
            return NSAttributedString(string: description, attributes: attrs)
        }
        return nil
    }
    
    public func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        if reloadEnabled && isLoading {
            return style.loadingAnimatedImage ?? UIImage()
        }
        return style.image
    }
    
    public func imageAnimation(forEmptyDataSet scrollView: UIScrollView!) -> CAAnimation! {
        #if canImport(QuartzCore)
        let animation = CABasicAnimation(keyPath: "transform")
        animation.fromValue = NSValue(caTransform3D: CATransform3DIdentity)
        animation.toValue = NSValue(caTransform3D: CATransform3DMakeRotation(CGFloat.pi/2, 0, 0, 1))
        animation.duration = 0.25
        animation.isCumulative = true
        animation.repeatCount = Float.greatestFiniteMagnitude
        return animation
        #else
        return nil
        #endif
    }
    
    public func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControl.State) -> NSAttributedString! {
        if let title = style.buttonTitle, !title.isEmpty {
            let attrs = [
                NSAttributedString.Key.font : style.buttonFont,
                NSAttributedString.Key.foregroundColor : style.buttonColor
            ]
            return NSAttributedString.init(string: title, attributes: attrs)
        }
        return nil
    }
    
    public func buttonImage(forEmptyDataSet scrollView: UIScrollView!, for state: UIControl.State) -> UIImage! {
        if state == .normal {
            return style.buttonNormalImage
        } else if state == .highlighted {
            return style.buttonHighlightedImage
        }
        return nil
    }
    
    /// Additionally, you can also adjust the vertical alignment of the content view (ie: useful when there is tableHeaderView visible)
    public func verticalOffset(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        guard let tListView = listView else {
            return style.verticalOffset
        }
        if tListView.isKind(of: UITableView.self) {
            if style.verticalOffset != 0 {
                return style.verticalOffset
            } else {
                if let tableView = tListView as? UITableView, let headerView = tableView.tableHeaderView {
                    return headerView.frame.size.height/2
                }
            }
        }
        return style.verticalOffset
    }
    
    public func spaceHeight(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        return style.verticalSpace
    }
    
    //MARK: - DZNEmptyDataSetDelegate
    
    public func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return shouldDisplay
    }
    
    public func emptyDataSetShouldAllowTouch(_ scrollView: UIScrollView!) -> Bool {
        return shouldAllowTouch
    }
    
    public func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return shouldAllowScroll
    }
    
    public func emptyDataSetShouldAnimateImageView(_ scrollView: UIScrollView!) -> Bool {
        return reloadEnabled && isLoading
    }
    
    public func emptyDataSet(_ scrollView: UIScrollView!, didTap view: UIView!) {
        if isLoading { return }
        isLoading = true
        onReload?()
        cxDelayToDispatch(1.5) {
            self.isLoading = false
        }
    }
    
    public func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!) {
        if isLoading { return }
        isLoading = true
        onReload?()
        cxDelayToDispatch(1.5) {
            self.isLoading = false
        }
    }
    
}

#endif

#endif
