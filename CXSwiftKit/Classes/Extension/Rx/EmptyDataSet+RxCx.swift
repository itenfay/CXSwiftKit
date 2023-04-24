//
//  EmptyDataSet+RxCx.swift
//  CaogenApp
//
//  Created by Jack on 2022/8/17.
//

#if canImport(Foundation) && canImport(RxSwift) && canImport(RxCocoa)
import Foundation
import RxSwift
import RxCocoa

public enum CXEmptyDataSetType {
    // You can customize title decription, use the default title if nil.
    case emptyData(desc: String?)
    // You can customize error title decription, use the default title if nil.
    case networkError(desc: String?)
}

extension Reactive where Base: CXEmptyDataSetMediator {
    
    public var empty: Binder<CXEmptyDataSetType> {
        return Binder(base) { (target, type) in
            switch type {
            case .emptyData(let desc):
                let style = CXEmptyDataSetStyle.emptyStyle
                if let description = desc, description.cx.isNotEmpty() {
                    style.title = description
                }
                target.style = style
            case .networkError(let desc):
                let style = CXEmptyDataSetStyle.networkErrorStyle
                if let description = desc, description.cx.isNotEmpty() {
                    style.title = description
                }
                target.style = style
            }
            target.bindEmptyDataSet()
        }
    }
    
}

#endif
