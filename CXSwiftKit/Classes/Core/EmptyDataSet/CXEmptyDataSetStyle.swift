//
//  CXEmptyDataSetStyle.swift
//  CXSwiftKit
//
//  Created by chenxing on 2022/10/19.
//

#if os(iOS) || os(tvOS)
import UIKit

//MARK: - EmptyDataSetStyle

public class CXEmptyDataSetStyle: NSObject {
    
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
    
    @objc public static var emptyTitle: String = "暂无数据"
    @objc public static var networkErrorTitle: String = "服务异常，网络断开或飞行模式"
    
}

#endif
