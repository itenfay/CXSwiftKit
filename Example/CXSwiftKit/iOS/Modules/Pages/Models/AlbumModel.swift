//
//  PermissionModel.swift
//  CXSwiftKit_Example
//
//  Created by chenxing on 2023/7/26.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation
import CXSwiftKit
import RxCocoa
import RxSwift

class PermissionModel: CXCellEntity {
    let type = BehaviorRelay<CXPermissionType>(value: .none)
    let status = BehaviorRelay<CXPermissionStatus>(value: .unknown)
}
