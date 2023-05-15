//
//  CXRequestProtocol.swift
//  CXSwiftKit
//
//  Created by chenxing on 2023/3/16.
//

#if canImport(Moya) && canImport(HandyJSON)
import Moya
import HandyJSON

public struct API {
    
    var url: String
    var method: CXRequestMethod
    var taskType: CXTaskType
    var headers: [String : String]
    
    public init(url: String, method: CXRequestMethod, headers: [String : String] = [:]) {
        self.url = url
        self.method = method
        self.taskType = CXTaskType.requestPlain
        self.headers = headers
    }
    
    public init(url: String,
                method: CXRequestMethod,
                parameters: [String : Any],
                encoding: ParameterEncoding,
                headers: [String : String] = [:])
    {
        self.url = url
        self.method = method
        self.taskType = .request(parameters: parameters, encoding: encoding)
        self.headers = headers
    }
    
    public init(url: String, method: CXRequestMethod, data: Data, headers: [String : String] = [:]) {
        self.url = url
        self.method = method
        self.taskType = CXTaskType.requestData(data)
        self.headers = headers
    }
    
    public init(url: String, entity: Encodable, headers: [String : String] = [:]) {
        self.url = url
        self.method = .post
        self.taskType = CXTaskType.requestJSON(entity)
        self.headers = headers
    }
    
}

public struct IOAPI {
    
    var url: String
    var method: CXRequestMethod
    var taskType: CXTaskType
    var headers: [String : String]
    
    public init(url: String, fileURL: URL, headers: [String : String] = [:]) {
        self.url = url
        self.method = .post
        self.taskType = CXTaskType.uploadFile(fileURL)
        self.headers = headers
    }
    
    public init(downloadURL: URL, toDirectory: String, headers: [String : String] = [:]) {
        self.url = ""
        self.method = .get
        self.taskType = CXTaskType.download(url: downloadURL, toDirectory: toDirectory)
        self.headers = headers
    }
    
}

public protocol CXRequestProtocol: HandyJSON {
    static func request(api: API, response: ((CXResponseResult<Self>) -> Void)?)
}

public extension CXRequestProtocol {
    
    static func request(api: API, response: ((CXResponseResult<Self>) -> Void)?) {
        let completionHandler: ((Result<Data, Error>) -> Void) = { result in
            switch result {
            case .success(let data):
                let jsonStr = String(data: data, encoding: .utf8)
                CXLogger.log(level: .info, message: "url=\(api.url)")
                CXLogger.log(level: .info, message: "response=\(jsonStr ?? "")")
                guard let jsonObj = self.self.deserialize(from: jsonStr) else {
                    response?(.failure(.deserializeFailed))
                    return
                }
                response?(.success(jsonObj))
            case .failure(let error):
                response?(.failure(.requestFailed(error)))
            }
        }
        
        var request = CXRequest(url: api.url, method: api.method, taskType: api.taskType)
        request.updateHeaders(api.headers)
        CXNetWorkManager.shared.send(request, completionHandler: completionHandler)
    }
    
}

#endif
