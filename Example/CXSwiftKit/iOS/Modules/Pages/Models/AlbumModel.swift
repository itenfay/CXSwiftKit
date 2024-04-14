//
//  PermissionModel.swift
//  CXSwiftKit_Example
//
//  Created by Teng Fei on 2023/7/26.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import CXSwiftKit
import RxListDataSource

class PermissionModel: CXCellEntity {
    let type = BehaviorRelay<CXPermissionType>(value: .none)
    let status = BehaviorRelay<CXPermissionStatus>(value: .unknown)
}
