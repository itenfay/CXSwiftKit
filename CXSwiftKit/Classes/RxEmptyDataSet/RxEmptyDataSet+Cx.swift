//
//  RxEmptyDataSet+Cx.swift
//  CXSwiftKit
//
//  Created by chenxing on 2022/8/17.
//

#if os(iOS) || os(tvOS)
import UIKit
#if canImport(RxSwift) && canImport(RxCocoa) && canImport(DZNEmptyDataSet)
import RxSwift
import RxCocoa
import DZNEmptyDataSet

public enum CXEmptyDataSetType {
    // Customize title decription, use the default title if nil.
    case emptyData(desc: String?)
    // Customize error title decription, use the default title if nil.
    case networkError(desc: String?)
}

extension Reactive where Base: CXEmptyDataSetDecorator {
    
    public var cx_empty: Binder<CXEmptyDataSetType> {
        return Binder(base) { (target, type) in
            let style = target.style
            switch type {
            case .emptyData(let desc):
                if let description = desc, !description.isEmpty {
                    style.title = description
                } else {
                    style.title = CXEmptyDataSetStyle.emptyTitle
                }
                target.style = style
            case .networkError(let desc):
                if let description = desc, !description.isEmpty {
                    style.title = description
                } else {
                    style.title = CXEmptyDataSetStyle.networkErrorTitle
                }
                target.style = style
            }
            target.bindEmptyDataSet()
            target.forceRefreshEmptyData()
        }
    }
    
}

#endif
#endif
