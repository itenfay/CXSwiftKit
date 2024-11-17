//
//  CXDocumentDelegate.swift
//  CXSwiftKit
//
//  Created by Tenfay on 2022/5/9.
//

#if os(iOS)
import UIKit

@objc public protocol CXDocumentDelegate {
    func cxDidPickDocuments(_ documents: [CXDocument]?)
}

#endif
