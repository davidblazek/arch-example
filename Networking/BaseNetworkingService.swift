//
//  ApiService.swift
//  AppCore
//

import Foundation
import Alamofire
import Shared

struct VoidResponse: Decodable {}

class BaseNetworkingService {
    
    let environment: NetworkingEnvironment
    let appInfoService: AppInfoService
    let logService: LogService
    
    init(environment: NetworkingEnvironment, appInfoService: AppInfoService, logService: LogService) {
        self.environment = environment
        self.appInfoService = appInfoService
        self.logService = logService
    }
    
    func request<T: Decodable>(endpoint: Endpoint, completion: @escaping (Result<T, ApiError>) -> Void) {
        request(endpoint: endpoint, resultMapper: { $0 }, completion: completion)
    }
    
    func request<T: Decodable, U>(endpoint: Endpoint, resultMapper: @escaping (T) -> U, completion: @escaping (Result<U, ApiError>) -> Void) {
        AF.request(fullPath(endpoint: endpoint), method: endpoint.method, parameters: endpoint.parameters, encoding: endpoint.encoding).responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let data):
                let mapped = resultMapper(data)
                completion(.success(mapped))
            case .failure(let error):
                completion(.failure(ApiError.map(from: error)))
            }
        }
    }
    
    func upload(endpoint: Endpoint, completion: @escaping (Result<Void, ApiError>) -> Void) {
        AF.upload(
            multipartFormData: { [weak self] multipartFormData in
                endpoint.parameters?.forEach { key, value in
                    switch value {
                    case let url as URL:
                        multipartFormData.append(url, withName: key, fileName: url.lastPathComponent, mimeType: "")
                    case let string as String:
                        multipartFormData.append(string.data(using: String.Encoding.utf8)!, withName: key)
                    case let number as NSNumber:
                        multipartFormData.append(number.stringValue.data(using: String.Encoding.utf8)!, withName: key)
                    default:
                        self?.logService.debug("BaseNetworkingService | multipart upload | Unprocessable value \(value) with key \(key)", tag: .api)
                    }
                }
            },
            to: fullPath(endpoint: endpoint),
            usingThreshold: UInt64(),
            method: endpoint.method,
            headers: HTTPHeaders(getUserAgentHeader())
        ).response { response in
            switch response.result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(ApiError.map(from: error)))
            }
        }
    }
    
    private func fullPath(endpoint: Endpoint) -> String {
        return environment.baseUrl + endpoint.path
    }
    
    private func getUserAgentHeader() -> [String: String] {
        return ["User-Agent": "\(appInfoService.bundleId)/\(appInfoService.appVersion)/\(appInfoService.bundleVersion)"]
    }
}
