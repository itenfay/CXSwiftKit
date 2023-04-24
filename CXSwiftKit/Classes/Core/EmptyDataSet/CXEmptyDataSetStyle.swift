//
//  CXEmptyDataSetStyle.swift
//  CXSwiftKit
//
//  Created by chenxing on 2022/10/19.
//

#if canImport(Foundation)
import Foundation

//MARK: - EmptyDataSetStyle

public class CXEmptyDataSetStyle: NSObject {
    @objc public var title: String?
    @objc public var titleColor: UIColor?
    @objc public var image: UIImage?
    
    @objc public static var emptyStyle: CXEmptyDataSetStyle {
        let style = CXEmptyDataSetStyle()
        style.title = "暂无数据"
        return style
    }
    
    @objc public static var networkErrorStyle: CXEmptyDataSetStyle {
        let style = CXEmptyDataSetStyle()
        style.title = "服务异常，网络断开或飞行模式"
        return style
    }
    
}

#endif
