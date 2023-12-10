//
//  RxKafkaRefresh+Cx.swift
//  CXSwiftKit
//
//  Created by chenxing on 2022/11/14.
//

#if os(iOS)
import UIKit
#if canImport(RxCocoa) && canImport(RxSwift) && canImport(KafkaRefresh)
import RxCocoa
import RxSwift
import KafkaRefresh

extension Reactive where Base: KafkaRefreshControl {
    
    public var cx_isAnimating: Binder<Bool> {
        return Binder(self.base) { refreshControl, active in
            if active {
                refreshControl.beginRefreshing()
            } else {
                refreshControl.endRefreshing(withAlertText: "") { () in }
            }
        }
    }
    
}

#endif
#endif
