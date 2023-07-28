//
//  AlbumModel.swift
//  CXSwiftKit_Example
//
//  Created by chenxing on 2023/7/26.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation

class AlbumModel: BaseCellModel {
    let id: String
    let name: String
    let count: Int
    
    init(id: String, name: String, count: Int) {
        self.id = id
        self.name = name
        self.count = count
    }
}
