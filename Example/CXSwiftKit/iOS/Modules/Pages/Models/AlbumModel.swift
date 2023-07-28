//
//  PermissionModel.swift
//  CXSwiftKit_Example
//
//  Created by chenxing on 2023/7/26.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import CXSwiftKit

class PermissionModel: BaseCellModel {
    let type = BehaviorRelay<CXPermissionType>(value: .none)
    let status = BehaviorRelay<CXPermissionStatus>(value: .unknown)
}
