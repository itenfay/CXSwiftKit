//
//  CXDocumentDelegate.swift
//  CXSwiftKit
//
//  Created by Teng Fei on 2022/5/9.
//

#if os(iOS)
import UIKit

@objc public protocol CXDocumentDelegate {
    func cxDidPickDocuments(_ documents: [CXDocument]?)
}

#endif
