//
//  DataModel.swift
//  CXSwiftKit
//
//  Created by Teng Fei on 2023/7/7.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit

class DataModel: BaseModel {
    var name: String
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    init(name: String) {
        self.name = name
    }
}
