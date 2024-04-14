//
//  CXRequest.swift
//  CXSwiftKit
//
//  Created by Teng Fei on 2023/3/16.
//

import Foundation
#if canImport(Moya)
import Moya

public enum CXRequestMethod: Int8, CustomStringConvertible {
    case get, post, head, put, delete, options
    public var description: String {
        switch self {
        case .get:     return "GET"
        case .post:    return "POST"
        case .head:    return "HEAD"
        case .put:     return "PUT"
        case .delete:  return "DELETE"
        case .options: return "OPTIONS"
        }
    }
}

public enum CXTaskType {
    case requestPlain
    case requestData(Data)
    case requestJSON(Encodable)
    case request(parameters: [String : Any], encoding: ParameterEncoding)
    case uploadFile(URL)
    case download(url: URL, toDirectory: String)
}

/// The necessary information of a request.
public struct CXRequest {
    
    public private(set) var baseUrl: String
    public private(set) var path: String
    public private(set) var method: CXRequestMethod
    public private(set) var headers: [String : String] = ["Content-Type" : "application/x-www-form-urlencoded"]
    public private(set) var taskType: CXTaskType
    public private(set) var sampleData: Data = "".data(using: .utf8)!
    
    public init(baseUrl: String, path: String, method: CXRequestMethod, taskType: CXTaskType) {
        self.baseUrl = baseUrl
        self.path = path
        self.method = method
        self.taskType = taskType
    }
    
    public mutating func updateHeaders(_ headers: [String : String]?) {
        guard let _headers = headers, !_headers.isEmpty else { return }
        for (k, v) in _headers {
            //self.headers.updateValue(v, forKey: k)
            self.headers[k] = v
        }
    }
    
    public mutating func setupSampleData(_ data: Data?) {
        guard let sampleData = data else { return }
        self.sampleData = sampleData
    }
    
}

#endif
