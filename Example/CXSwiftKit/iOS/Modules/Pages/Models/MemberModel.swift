//
//  MemberModel.swift
//  CXSwiftKit_Example
//
//  Created by Teng Fei on 2023/7/26.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation
import CXSwiftKit
import HandyJSON

public protocol CXHJBaseModel: HandyJSON, CXBaseModel {}

struct MemberModel: CXHJBaseModel {
    var id: String?
    var name: String?
    var url: String?
}
