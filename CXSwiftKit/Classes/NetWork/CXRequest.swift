//
//  CXRequest.swift
//  CXSwiftKit
//
//  Created by chenxing on 2023/3/16.
//

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
    
    public private(set) var url: String
    public private(set) var method: CXRequestMethod
    public private(set) var headers: [String : String] = ["Content-Type" : "application/x-www-form-urlencoded"]
    public private(set) var taskType: CXTaskType
    
    public init(url: String, method: CXRequestMethod, taskType: CXTaskType) {
        self.url = url
        self.method = method
        self.taskType = taskType
    }
    
    public mutating func updateHeaders(_ headers: [String : String]?) {
        if let _headers_ = headers, !_headers_.isEmpty {
            self.headers = _headers_
        }
    }
    
}

#endif
