//
//  MemberModel.swift
//  CXSwiftKit_Example
//
//  Created by Teng Fei on 2023/7/26.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation
import ObjectMapper

struct MemberModel: Mappable {
    var id: String?
    var name: String?
    var url: String?
    
    init?(map: ObjectMapper.Map) {
    }
    
    mutating func mapping(map: ObjectMapper.Map) {
        id   <- map["id"]
        name <- map["name"]
        url  <- map["url"]
    }
}
