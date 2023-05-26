//
//  CXDocumentDelegate.swift
//  CXSwiftKit
//
//  Created by chenxing on 2022/5/9.
//

#if os(iOS)
import UIKit

@objc public protocol CXDocumentDelegate {
    @objc func cxDidPickDocuments(_ documents: [CXDocument]?)
}

#endif
