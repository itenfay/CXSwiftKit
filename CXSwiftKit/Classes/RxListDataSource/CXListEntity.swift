//
//  CXListEntity.swift
//  CXSwiftKit
//
//  Created by chenxing on 2023/7/7.
//

import Foundation
#if canImport(RxSwift) && canImport(RxCocoa) && canImport(RxDataSources)
import RxCocoa
import RxSwift
import RxDataSources

public protocol CXEntityType {}

open class CXCellEntity: NSObject, CXEntityType, IdentifiableType {
    public typealias Identity = String
    
    public var reuseIdentifier: String = ""
    public var cellHeight: CGFloat = 0.0
    
    public var identity: String {
        return "\(self.hash)"
    }
}

open class CXHeaderFooterEntity: NSObject, CXEntityType {
    public var reuseIdentifier: String = ""
    public var sectionSize: CGSize = .zero
    public var sectionTitle: String = ""
    public let sectionSelected = PublishSubject<CXHeaderFooterEntity>()
}

open class CXSectionEntity: NSObject, CXEntityType, IdentifiableType {
    public typealias Identity = String
    
    public var headerEntity: CXHeaderFooterEntity?
    public var footerEntity: CXHeaderFooterEntity?
    
    public var sectionInset: UIEdgeInsets = .zero
    public var minimumLineSpacing: CGFloat = 0.0
    
    public var identity: String {
        return "\(self.hash)"
    }
}

#endif
