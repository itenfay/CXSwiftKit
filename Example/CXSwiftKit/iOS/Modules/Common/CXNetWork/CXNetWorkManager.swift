//
//  CXNetWorkManager.swift
//  CXSwiftKit
//
//  Created by chenxing on 2023/3/16.
//

import Foundation
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
            return URL(string: "\(request.baseUrl)") ?? URL(string: "https://host.error")!
        }
    }
    
    var path: String {
        switch request.taskType {
        case .download(_, _):
            return ""
        default:
            return request.path
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
    
    var sampleData: Data {
        return request.sampleData
    }
    
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
            return cxAssetRootDir.nwAppendingPathComponent(toDirectory).nwAppendingPathComponent(fileName)
        default:
            return cxAssetRootDir
        }
    }
    
    var downloadDestination: DownloadDestination {
        return { _, _ in return (self.localLocation, .removePreviousFile) }
    }
    
}

//**************************************************************************************************************
// e.g.:
// Downloads an image to the local.
//let url = "https://atts.w3cschool.cn/attachments/image/20171028/1509160178371523.png"
//CXNetWorkManager.shared.request(api: StreamAPI(downloadURL: URL(string: url)!, toDirectory: "Images")) { result in
//    switch result {
//    case .success(let data):
//        print("filePath: \(String(data: data, encoding: .utf8))")
//    case .failure(let error):
//        print("error: \(error)")
//    }
//}

// Gets an image data.
//let base = "https://xxx.xxx.xx"
//let imgCodePath = "/auth/v1/verify/phoneImgCode"
//CXNetWorkManager.shared.request(api: API(baseUrl: base, path: imgCodePath, method: .get)) { result in
//    switch result {
//    case .success(let data):
//        let image = UIImage(data: data)
//        print("imageData: \(data), image: \(image)")
//    case .failure(let error):
//        print("error: \(error)")
//    }
//}

// Gets cookies, and so on.
//CXNetWorkManager.shared.onRequestCompletion = { [weak self] response in
//    print("response: \(response), httpURLRespone: \(response.response)")
//}
//**************************************************************************************************************

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
    /// Track inflights.
    public var trackInflights: Bool = false
    
    /// The closure decides how a request should be stubbed.
    private var stubClosure: MoyaProvider<MoyaApi>.StubClosure = MoyaProvider.neverStub
    /// The closure represents a request has been completed.
    public var onRequestCompletion: ((Moya.Response) -> Void)?
    
    /// Invokes this method when update the parameters.
    public func updateProvider() {
        apiProvider = MoyaProvider<MoyaApi>(requestClosure: {
            [unowned self] (endpoint: Endpoint, closure: MoyaProvider<MoyaApi>.RequestResultClosure) -> Void in
            if var urlRequest = try? endpoint.urlRequest() {
                urlRequest.timeoutInterval = self.timeoutInterval
                closure(.success(urlRequest))
            } else {
                closure(.failure(MoyaError.requestMapping(endpoint.url)))
            }}, stubClosure: stubClosure, plugins: plugins, trackInflights: trackInflights)
    }
    
    /// Send a request.
    public func send(_ request: CXRequest, completionHandler: @escaping (Swift.Result<Data,Error>) -> Void) {
        //self.updateStub(request)
        let target = MoyaApi(request: request)
        self.request(target: target, completion: completionHandler)
    }
    
    private func request(target: MoyaApi, completion: @escaping (Swift.Result<Data, Error>) -> Void) {
        apiProvider.request(target) { [unowned self] result in
            switch result {
            case .success(let response):
                self.onRequestCompletion?(response)
                completion(.success(response.data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /// Executes a request.
    public func request(api: APIType, response: ((CXResponseResult<Data>) -> Void)?) {
        var downloadPath = ""
        
        switch api.taskType {
        case .download(let url, let toDirectory):
            do {
                let targetURL = cxAssetRootDir.nwAppendingPathComponent(toDirectory)
                try FileManager.default.createDirectory(at: targetURL, withIntermediateDirectories: true)
                let fileName = url.lastPathComponent
                downloadPath = targetURL.nwAppendingPathComponent(fileName).nwPath
            } catch let error {
                response?(.failure(.innerError(error.localizedDescription)))
                return
            }
        default: break
        }
        
        let completionHandler: ((Swift.Result<Data, Error>) -> Void) = { result in
            switch result {
            case .success(let data):
                if downloadPath.isEmpty {
                    response?(.success(data))
                } else {
                    response?(.success(downloadPath.data(using: .utf8) ?? Data()))
                }
            case .failure(let error):
                response?(.failure(.requestFailed(error)))
            }
        }
        
        var request = CXRequest(baseUrl: api.baseUrl, path: api.path, method: api.method, taskType: api.taskType)
        request.updateHeaders(api.headers)
        request.setupSampleData(api.sampleData)
        CXNetWorkManager.shared.send(request, completionHandler: completionHandler)
    }
    
    private func updateStub(_ request: CXRequest) {
        if !request.sampleData.isEmpty {
            stubClosure = MoyaProvider.delayedStub(1)
        } else {
            stubClosure = MoyaProvider.neverStub
        }
        updateProvider()
    }
    
}

extension URL {
    
    public func nwAppendingPathComponent(_ path: String) -> URL {
        if #available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *) {
            return appending(path: path, directoryHint: .inferFromPath)
        } else {
            return appendingPathComponent(path)
        }
    }
    
    public var nwPath: String {
        if #available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *) {
            return path(percentEncoded: false)
        } else {
            return path
        }
    }
    
}

#endif
