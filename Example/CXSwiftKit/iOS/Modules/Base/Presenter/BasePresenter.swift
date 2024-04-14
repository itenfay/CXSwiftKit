//
//  BasePresenter.swift
//  CXSwiftKit
//
//  Created by Teng Fei on 2023/7/7.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation

protocol Presenter: AnyObject {
    func loadData()
}

class BasePresenter: NSObject, Presenter {
    
    func loadData() {}
    
}
