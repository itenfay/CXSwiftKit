//
//  Button+RxCx.swift
//  CXSwiftKit
//
//  Created by chenxing on 2022/8/17.
//

#if os(iOS) || os(tvOS)
import UIKit
#if canImport(RxSwift) && canImport(RxCocoa)
import RxSwift
import RxCocoa

extension Reactive where Base: UIButton {
    
    #if os(iOS) || os(tvOS)
    public var cx_isShowIndicator: Binder<Bool> {
        return Binder(self.base, binding: { button, active in
            if active {
                objc_setAssociatedObject(button, &CXAssociatedKey.buttonCurrentText, button.currentTitle, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                button.setTitle("", for: .normal)
                button.cx.whiteIndicator.startAnimating()
                button.isUserInteractionEnabled = false
            }
            else{
                button.cx.whiteIndicator.stopAnimating()
                if let title = objc_getAssociatedObject(button, &CXAssociatedKey.buttonCurrentText) as? String {
                    button.setTitle(title, for: .normal)
                }
                button.isUserInteractionEnabled = true
            }
        })
    }
    #endif
}

#endif
#endif
