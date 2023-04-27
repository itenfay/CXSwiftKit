//
//  Kingfisher+RxCx.swift
//  CXSwiftKit
//
//  Created by chenxing on 2022/11/14.
//

#if canImport(UIKit)
import UIKit
#if canImport(RxCocoa) && canImport(RxSwift) && canImport(Kingfisher)
import RxCocoa
import RxSwift
import Kingfisher

extension Reactive where Base: UIImageView {
    
    public var cx_imageURL: Binder<URL?> {
        return self.cx_imageURL(withPlaceholder: UIColor.lightGray.cx.drawImage())
    }
    
    public func cx_imageURL(
        withPlaceholder placeholder: UIImage?,
        options: KingfisherOptionsInfo? = [],
        completionHandler: ((Swift.Result<RetrieveImageResult, KingfisherError>) -> Void)? = nil
    ) -> Binder<URL?> {
        return Binder(self.base, binding: { (imageView, url) in
            imageView.kf.setImage(with: url,
                                  placeholder: placeholder,
                                  options: options,
                                  progressBlock: nil,
                                  completionHandler: { (result) in
                completionHandler?(result)
            })
        })
    }
    
}

extension ImageCache: ReactiveCompatible {}

extension Reactive where Base: ImageCache {
    
    public func cx_retrieveCacheSize() -> Observable<Int> {
        return Single.create { single in
            self.base.calculateDiskStorageSize { (result) in
                do {
                    single(.success(Int(try result.get())))
                } catch {
                    single(.error(error))
                }
            }
            return Disposables.create {}
        }.asObservable()
    }
    
    public func cx_clearCache() -> Observable<Void> {
        return Single.create { single in
            self.base.clearMemoryCache()
            self.base.clearDiskCache(completion: {
                single(.success(()))
            })
            return Disposables.create {}
        }.asObservable()
    }
}

#endif

#endif
