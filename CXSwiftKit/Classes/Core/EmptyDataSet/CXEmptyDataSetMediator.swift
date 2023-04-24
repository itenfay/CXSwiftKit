//
//  CXEmptyDataSetMediator.swift
//  CXSwiftKit
//
//  Created by chenxing on 2022/5/9.
//

#if canImport(UIKit) && canImport(QuartzCore) && canImport(DZNEmptyDataSet)
import UIKit
import QuartzCore
import DZNEmptyDataSet

@objc public protocol CXEmptyDataSetPresentable: AnyObject {
    @objc var listView: UIScrollView? { get set }
}

public class CXEmptyDataSetMediator: NSObject, CXEmptyDataSetPresentable {
    
    /// The current list view.
    @objc public weak var listView: UIScrollView?
    
    /// The background color for empty data set.
    @objc public var backgroundColor: UIColor = UIColor.cx.color(withHexString: "#FFFFFF")!
    /// The title for empty data set.
    @objc public var title: String?
    /// The title color for empty data set.
    @objc public var titleColor: UIColor = UIColor.cx.color(withHexString: "#333333")!
    /// The title font for empty data set.
    @objc public var titleFont: UIFont = UIFont.cx.regularPingFang(ofSize: 13)
    
    /// The description for empty data set.
    @objc public var descriptionString: String?
    /// The description color for empty data set.
    @objc public var descriptionColor: UIColor = UIColor.cx.color(withHexString: "#333333")!
    /// The description font for empty data set.
    @objc public var descriptionFont: UIFont = UIFont.cx.regularPingFang(ofSize: 13)
    
    /// The image font for empty data set.
    @objc public var image: UIImage?
    /// The loading animated image for empty data set.
    @objc public var loadingAnimatedImage: UIImage?
    
    /// The button title for empty data set.
    @objc public var buttonTitle: String?
    /// The button color for empty data set.
    @objc public var buttonColor: UIColor = UIColor.cx.color(withHexString: "#9D1420")!
    /// The button font for empty data set.
    @objc public var buttonFont: UIFont = UIFont.cx.regularPingFang(ofSize: 13)
    /// The button normal image font for empty data set.
    @objc public var buttonNormalImage: UIImage?
    /// The button highlighted image font for empty data set.
    @objc public var buttonHighlightedImage: UIImage?
    
    /// The vertical offset for empty data set.
    @objc public var verticalOffset: CGFloat = 0
    /// The vertical distance for empty data set.
    @objc public var verticalSpace: CGFloat = 20
    /// The reload is default enabled.
    @objc public var reloadEnabled: Bool = true
    
    /// The boolean value for empty data set.
    @objc public var shouldDisplay: Bool = true
    /// The boolean value for empty data set.
    @objc public var shouldAllowTouch: Bool = true
    /// The boolean value for empty data set.
    @objc public var shouldAllowScroll: Bool = true
    
    /// The style controls the title, title color, image of empty data set.
    @objc public var style: CXEmptyDataSetStyle? {
        didSet {
            title = style?.title
            if let tColor = style?.titleColor {
                titleColor = tColor
            }
            if let tImage = style?.image {
                image = tImage
            }
            forceToRefreshLayout()
        }
    }
    
    @objc public var isLoading: Bool = false {
        didSet {
            forceToRefreshLayout()
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
    
    /// Force to refresh layout of the target list view.
    @objc public func forceToRefreshLayout() {
        listView?.reloadEmptyDataSet()
    }
    
}

extension CXEmptyDataSetMediator: DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    
    //MARK: - DZNEmptyDataSetSource
    
    public func backgroundColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
        return backgroundColor
    }
    
    public func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        if let title = title, !title.isEmpty {
            let attrs = [
                NSAttributedString.Key.font: titleFont,
                NSAttributedString.Key.foregroundColor: titleColor
            ]
            return NSAttributedString.init(string: title, attributes: attrs)
        }
        return nil
    }
    
    public func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        if let description = descriptionString, !description.isEmpty {
            let attrs = [
                NSAttributedString.Key.font: descriptionFont,
                NSAttributedString.Key.foregroundColor: descriptionColor
            ]
            return NSAttributedString(string: description, attributes: attrs)
        }
        return nil
    }
    
    public func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        if reloadEnabled && isLoading {
            return loadingAnimatedImage ?? UIImage()
        }
        return image
    }
    
    public func imageAnimation(forEmptyDataSet scrollView: UIScrollView!) -> CAAnimation! {
        let animation = CABasicAnimation(keyPath: "transform")
        animation.fromValue = NSValue(caTransform3D: CATransform3DIdentity)
        animation.toValue = NSValue(caTransform3D: CATransform3DMakeRotation(CGFloat.pi/2, 0, 0, 1))
        animation.duration = 0.25
        animation.isCumulative = true
        animation.repeatCount = Float.greatestFiniteMagnitude
        return animation
    }
    
    public func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControl.State) -> NSAttributedString! {
        if let title = buttonTitle, !title.isEmpty {
            let attrs = [
                NSAttributedString.Key.font: buttonFont,
                NSAttributedString.Key.foregroundColor: buttonColor
            ]
            return NSAttributedString.init(string: title, attributes: attrs)
        }
        return nil
    }
    
    public func buttonImage(forEmptyDataSet scrollView: UIScrollView!, for state: UIControl.State) -> UIImage! {
        if state == .normal {
            return buttonNormalImage
        } else if state == .highlighted {
            return buttonHighlightedImage
        }
        return nil
    }
    
    /// Additionally, you can also adjust the vertical alignment of the content view (ie: useful when there is tableHeaderView visible)
    public func verticalOffset(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        guard let listView = listView else {
            return verticalOffset
        }
        if listView.isKind(of: UITableView.self) {
            if verticalOffset != 0 {
                return verticalOffset
            } else {
                if let tableView = listView as? UITableView, let headerView = tableView.tableHeaderView {
                    return headerView.frame.size.height/2
                }
            }
        }
        return verticalOffset
    }
    
    public func spaceHeight(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        return verticalSpace
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
