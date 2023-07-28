//
//  DocumentModel.swift
//  CXSwiftKit_Example
//
//  Created by chenxing on 2023/7/26.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation

class DocumentModel: BaseCellModel {
    var fileURL: URL
    var name: String
    
    init(fileURL: URL, name: String) {
        self.fileURL = fileURL
        self.name = name
    }
}