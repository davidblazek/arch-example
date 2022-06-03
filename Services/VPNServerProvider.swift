//
//  VPNServerProvider.swift
//  AppCore
//

import Foundation
import Shared

public protocol VPNServerProvider {
    func getAvailableConfigurations(response: @escaping (Result<[VPNProfileModel], ApiError>) -> Void)
    func getDefaultConfiguration(response: @escaping (VPNProfileModel?) -> Void)
}

final class VPNServerProviderImpl: BaseNetworkingService, VPNServerProvider {
    
    public func getAvailableConfigurations(response: @escaping (Result<[VPNProfileModel], ApiError>) -> Void) {
        request(
            endpoint: .serverList(locale: appInfoService.languageCode),
            resultMapper: { ($0 as Array).map { VPNProfileModel(configuration: $0) } },
            completion: response)
    }
    
    public func getDefaultConfiguration(response: @escaping (VPNProfileModel?) -> Void) {
        getAvailableConfigurations { [weak self] result in
            switch result {
            case .success(let configs):
                response(configs.first { !$0.configuration.premium })
            case .failure(let error):
                self?.logService.error("VPNServerProviderImpl | getDefaultConfiguration | error: \(error.localizedDescription)", tag: .api)
                response(nil)
            }
        }
    }
}
