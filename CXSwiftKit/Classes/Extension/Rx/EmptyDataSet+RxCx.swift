//
//  EmptyDataSet+RxCx.swift
//  CXSwiftKit
//
//  Created by chenxing on 2022/8/17.
//

#if canImport(Foundation)
import Foundation
#if canImport(RxSwift) && canImport(RxCocoa)
import RxSwift
import RxCocoa

public enum CXEmptyDataSetType {
    // Customize title decription, use the default title if nil.
    case emptyData(desc: String?)
    // Customize error title decription, use the default title if nil.
    case networkError(desc: String?)
}

extension Reactive where Base: CXEmptyDataSetMediator {
    
    public var empty: Binder<CXEmptyDataSetType> {
        return Binder(base) { (target, type) in
            let style = target.style
            switch type {
            case .emptyData(let desc):
                if let description = desc, description.cx.isNotEmpty() {
                    style.title = description
                } else {
                    style.title = CXEmptyDataSetStyle.emptyTitle
                }
                target.style = style
            case .networkError(let desc):
                if let description = desc, description.cx.isNotEmpty() {
                    style.title = description
                } else {
                    style.title = CXEmptyDataSetStyle.networkErrorTitle
                }
                target.style = style
            }
            target.bindEmptyDataSet()
            target.reloadEmptyDataSet()
        }
    }
    
}

#endif

#endif
