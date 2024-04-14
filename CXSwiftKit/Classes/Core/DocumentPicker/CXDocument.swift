//
//  CXDocument.swift
//  CXSwiftKit
//
//  Created by Teng Fei on 2022/5/9.
//

#if os(iOS)
import UIKit

public class CXDocument: UIDocument {
    
    @objc public var data: Data?
    
    public override func contents(forType typeName: String) throws -> Any {
        guard let data = data else { return Data() }
        if #available(iOS 11.0, *) {
            return try NSKeyedArchiver.archivedData(withRootObject: data, requiringSecureCoding: true)
        } else {
            return NSKeyedArchiver.archivedData(withRootObject: data)
        }
    }
    
    public override func load(fromContents contents: Any, ofType typeName: String?) throws {
        guard let tData = contents as? Data else { return }
        data = tData
    }
    
}

#endif
