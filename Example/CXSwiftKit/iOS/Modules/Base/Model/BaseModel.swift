//
//  BaseModel.swift
//  CXSwiftKit
//
//  Created by Tenfay on 2023/7/7.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation
import CXSwiftKit
import HandyJSON

// MARK: - CXHJBaseModel
public protocol CXHJBaseModel: HandyJSON, CXBaseModel {}

class BaseModel: CXHJBaseModel {
    required init() {}
}
