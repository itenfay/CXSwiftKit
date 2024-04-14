//
//  CXScanResult.swift
//  CXSwiftKit
//
//  Created by Teng Fei on 2023/6/5.
//

import Foundation
#if os(iOS)
import UIKit

public class CXScanResult: NSObject {
    /// Represents the content of scanned code.
    @objc public var stringValue: String?
    /// Represents the captured image of scanned code.
    @objc public var image: UIImage?
    /// Represents the type of scanned code.
    @objc public var codeType: String?
    /// Represents the position of scanned code.
    @objc public var codeCorners: [CGPoint]?
    
    @objc public init(value: String?, image: UIImage?, codeType: String?, codeCorners: [CGPoint]?) {
        self.stringValue = value
        self.image = image
        self.codeType = codeType
        self.codeCorners = codeCorners
    }
}

#endif
