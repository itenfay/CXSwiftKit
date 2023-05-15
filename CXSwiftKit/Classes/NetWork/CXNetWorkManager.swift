//
//  CXNetWorkManager.swift
//  CXSwiftKit
//
//  Created by chenxing on 2023/3/16.
//

#if canImport(Moya)
import Moya

public let cxAssetRootDir: URL = {
    let directoryURLs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return directoryURLs[0]
}()

private struct MoyaApi: TargetType {
    
    var request: CXRequest
    
    init(request: CXRequest) {
        self.request = request
    }
    
    var baseURL: URL {
        switch request.taskType {
        case .download(let url, _):
            return url
        default:
            return URL(string: "")!
        }
    }
    
    var path: String {
        switch request.taskType {
        case .download(_, _):
            return ""
        default:
            return request.url
        }
    }
    
    var method: Moya.Method {
        switch request.method {
        case .get:     return .get
        case .post:    return .post
        case .head:    return .head
        case .put:     return .put
        case .delete:  return .delete
        case .options: return .options
        }
    }
    
    var sampleData: Data = "".data(using: .utf8)!
    
    var task: Task {
        switch request.taskType {
        case .requestPlain:
            return .requestPlain
        case .requestData(let data):
            return .requestData(data)
        case .request(let parameters, let encoding):
            if parameters.isEmpty {
                return .requestPlain
            } else {
                return .requestParameters(parameters: parameters, encoding: encoding)
            }
        case .requestJSON(let entity):
            return .requestJSONEncodable(entity)
        case .uploadFile(let fileURL):
            return .uploadFile(fileURL)
        case .download(_, _):
            return .downloadDestination(downloadDestination)
        }
    }
    
    var headers: [String : String]? {
        return request.headers
    }
    
    var localLocation: URL {
        switch request.taskType {
        case .download(let url, let toDirectory):
            let fileName = url.lastPathComponent
            return cxAssetRootDir.appendingPathComponent(toDirectory).appendingPathComponent(fileName)
        default:
            return cxAssetRootDir
        }
    }
    
    var downloadDestination: DownloadDestination {
        CXLogger.log(level: .info, message: "localLocation=\(localLocation)")
        return { _, _ in return (self.localLocation, .removePreviousFile) }
    }
    
}

public class CXNetWorkManager {
    
    private var apiProvider: MoyaProvider<MoyaApi>!
    
    public static let shared = CXNetWorkManager()
    
    /// Init
    private init() {
        self.updateProvider()
    }
    
    /// The timeout interval of the request.
    public var timeoutInterval: TimeInterval = 15
    /// The moya plugins.
    public var plugins: [PluginType] = []
    public var trackInflights: Bool = false
    
    /// Invokes this method when update the parameters.
    public func updateProvider() {
        apiProvider = MoyaProvider<MoyaApi>(requestClosure: {
            [unowned self] (endpoint: Endpoint, closure: MoyaProvider<MoyaApi>.RequestResultClosure) -> Void in
            if var urlRequest = try? endpoint.urlRequest() {
                urlRequest.timeoutInterval = self.timeoutInterval
                closure(.success(urlRequest))
            } else {
                closure(.failure(MoyaError.requestMapping(endpoint.url)))
            }} , plugins: plugins, trackInflights: trackInflights)
    }
    
    /// Send a request.
    public func send(_ request: CXRequest, completionHandler: @escaping (Result<Data,Error>) -> Void) {
        let target = MoyaApi(request: request)
        self.request(target: target, completion: completionHandler)
    }
    
    private func request(target: MoyaApi, completion: @escaping (Result<Data, Error>) -> Void) {
        apiProvider.request(target) { (res) in
            switch res {
            case .success(let a):
                completion(.success(a.data))
            case .failure:
                completion(.failure(res.error!))
            }
        }
    }
    
    public func request(api: IOAPI, response: ((CXResponseResult<Data>) -> Void)?) {
        let completionHandler: ((Result<Data, Error>) -> Void) = { result in
            switch result {
            case .success(let data):
                response?(.success(data))
            case .failure(let error):
                response?(.failure(.requestFailed(error)))
            }
        }
        
        switch api.taskType {
        case .download(_, let toDirectory):
            do {
                let targetURL = cxAssetRootDir.appendingPathComponent(toDirectory)
                try FileManager.default.createDirectory(at: targetURL, withIntermediateDirectories: true)
            } catch let error {
                response?(.failure(.innerError(error.localizedDescription)))
                return
            }
        default: break
        }
        
        var request = CXRequest(url: api.url, method: api.method, taskType: api.taskType)
        request.updateHeaders(api.headers)
        CXNetWorkManager.shared.send(request, completionHandler: completionHandler)
    }
    
}

#endif
