//
//  CXRequestProtocol.swift
//  CXSwiftKit
//
//  Created by chenxing on 2023/3/16.
//

#if canImport(Moya) && canImport(HandyJSON)
import Moya
import HandyJSON

public protocol APIType {
    var baseUrl: String { get }
    var path: String { get }
    var method: CXRequestMethod { get }
    var taskType: CXTaskType { get }
    var headers: [String : String] { get }
    var sampleData: Data? { get set }
}

public struct API: APIType {
    
    public let baseUrl: String
    public let path: String
    public let method: CXRequestMethod
    public let taskType: CXTaskType
    public let headers: [String : String]
    public var sampleData: Data?
    
    public init(baseUrl: String = "", path: String, method: CXRequestMethod, headers: [String : String] = [:]) {
        self.baseUrl = baseUrl
        self.path = path
        self.method = method
        self.taskType = CXTaskType.requestPlain
        self.headers = headers
    }
    
    public init(baseUrl: String = "",
                path: String,
                method: CXRequestMethod,
                parameters: [String : Any],
                encoding: ParameterEncoding,
                headers: [String : String] = [:])
    {
        self.baseUrl = baseUrl
        self.path = path
        self.method = method
        self.taskType = .request(parameters: parameters, encoding: encoding)
        self.headers = headers
    }
    
    public init(baseUrl: String = "", path: String, method: CXRequestMethod, data: Data, headers: [String : String] = [:]) {
        self.baseUrl = baseUrl
        self.path = path
        self.method = method
        self.taskType = CXTaskType.requestData(data)
        self.headers = headers
    }
    
    public init(baseUrl: String = "", path: String, entity: Encodable, headers: [String : String] = [:]) {
        self.baseUrl = baseUrl
        self.path = path
        self.method = .post
        self.taskType = CXTaskType.requestJSON(entity)
        self.headers = headers
    }
    
}

public struct StreamAPI: APIType {
    
    public let baseUrl: String
    public let path: String
    public let method: CXRequestMethod
    public let taskType: CXTaskType
    public let headers: [String : String]
    public var sampleData: Data?
    
    public init(baseUrl: String = "", path: String, fileURL: URL, headers: [String : String] = [:]) {
        self.baseUrl = baseUrl
        self.path = path
        self.method = .post
        self.taskType = CXTaskType.uploadFile(fileURL)
        self.headers = headers
    }
    
    public init(downloadURL: URL, toDirectory: String, headers: [String : String] = [:]) {
        self.baseUrl = ""
        self.path = ""
        self.method = .get
        self.taskType = CXTaskType.download(url: downloadURL, toDirectory: toDirectory)
        self.headers = headers
    }
    
}

public struct TestAPI: APIType {
    
    public let baseUrl: String
    public let path: String
    public let method: CXRequestMethod
    public let taskType: CXTaskType
    public let headers: [String : String]
    public var sampleData: Data?
    
    public init(baseUrl: String = "", path: String, method: CXRequestMethod, sampleData: Data?, headers: [String : String] = [:]) {
        self.baseUrl = baseUrl
        self.path = path
        self.method = method
        self.sampleData = sampleData
        self.taskType = CXTaskType.request(parameters: [:], encoding: URLEncoding.default)
        self.headers = headers
    }
    
}

public protocol CXRequestProtocol: HandyJSON {
    static func request(api: APIType, response: ((CXResponseResult<Self>) -> Void)?)
}

public extension CXRequestProtocol {
    
    static func request(api: APIType, response: ((CXResponseResult<Self>) -> Void)?) {
        let completionHandler: ((Result<Data, Error>) -> Void) = { result in
            switch result {
            case .success(let data):
                let jsonStr = String(data: data, encoding: .utf8)
                debugPrint("[I] " + "response=\(jsonStr ?? "")")
                guard let jsonObj = self.self.deserialize(from: jsonStr) else {
                    response?(.failure(.deserializeFailed))
                    return
                }
                response?(.success(jsonObj))
            case .failure(let error):
                response?(.failure(.requestFailed(error)))
            }
        }
        
        var request = CXRequest(baseUrl: api.baseUrl, path: api.path, method: api.method, taskType: api.taskType)
        request.updateHeaders(api.headers)
        request.setupSampleData(api.sampleData)
        CXNetWorkManager.shared.send(request, completionHandler: completionHandler)
    }
    
}

#endif
