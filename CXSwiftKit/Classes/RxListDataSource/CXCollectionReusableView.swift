//
//  CXCollectionReusableView.swift
//  CXSwiftKit
//
//  Created by chenxing on 2023/7/7.
//

import Foundation
#if os(iOS) || os(tvOS)
import UIKit
#if canImport(RxSwift) && canImport(RxCocoa)
import RxCocoa
import RxSwift

open class CXCollectionReusableView: UICollectionReusableView {
    
    public var disposeBag = DisposeBag()
    
    open func makeDisposeBag() {
        disposeBag = DisposeBag()
    }
    
    /// Override
    open func bind(to entity: CXHeaderFooterEntity) {
        makeDisposeBag()
    }
    
}

#endif
#endif
