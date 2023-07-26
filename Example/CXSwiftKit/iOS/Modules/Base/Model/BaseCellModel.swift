//
//  BaseCellModel.swift
//  CXSwiftKit
//
//  Created by chenxing on 2023/7/7.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import CXSwiftKit
import RxDataSources

class BaseCellModel: NSObject, IdentifiableType {
    typealias Identity = String
    
    var reuseIdentifier: String = ""
    var cellHeight: CGFloat = 40
    
    var identity: String {
        return "\(self.hash)"
    }
}

class BaseHeaderFooterModel: NSObject {
    var reuseIdentifier: String = ""
    var sectionSize: CGSize = .zero
    var sectionTitle: String = ""
    let sectionSelected = PublishSubject<BaseHeaderFooterModel>()
}

class BaseSectionModel: NSObject, IdentifiableType {
    typealias Identity = String
    
    var headerModel: BaseHeaderFooterModel?
    var footerModel: BaseHeaderFooterModel?
    var sectionInset: UIEdgeInsets = .zero
    var minimumLineSpacing: CGFloat = 0.0
    
    var identity: String {
        return "\(self.hash)"
    }
}
