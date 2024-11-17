//
//  Configurator.swift
//  CXSwiftKit
//
//  Created by Tenfay on 2023/7/7.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit

protocol Configurator {
    associatedtype C: UIViewController
    func configure(controller: C)
}
