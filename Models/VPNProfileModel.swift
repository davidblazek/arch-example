//
//  VPNProfileModel.swift
//  AppCore
//

import Foundation
import Shared
import UIKit

public enum ConnectionStatus {
    case idle
    case invalid
    case connecting
    case connected
    case disconnected
    case unknown
    
    var caption: String {
        switch self {
        case .idle:
            return Localizable.mainConnectionStatusIdle()
        case .invalid:
            return Localizable.mainConnectionStatusInvalid()
        case .connecting:
            return Localizable.mainConnectionStatusConnecting()
        case .connected:
            return Localizable.mainConnectionStatusConnected()
        case .disconnected:
            return Localizable.mainConnectionStatusDisconnected()
        case .unknown:
            return Localizable.mainConnectionStatusUnknown()
        }
    }
    
    var image: UIImage? {
        switch self {
        case .idle:
            return R.image.imgStatusIdle()
        case .invalid:
            return R.image.imgStatusError()
        case .connecting:
            return R.image.imgStatusConnecting()
        case .connected:
            return R.image.imgStatusConnected()
        case .disconnected:
            return R.image.imgStatusDisconnected()
        case .unknown:
            return R.image.imgStatusIdle()
        }
    }

    var animationName: String? {
        switch self {
        case .idle:
            return "animation_status_idle"
        case .connected:
            return "animation_status_connected"
        default:
            return nil
        }
    }

    var isStateAnimated: Bool {
        return animationName != nil
    }
}

public class VPNProfileModel: Equatable {
    
    let configuration: VPNProfileConfiguration
    
    var status: ConnectionStatus = .idle
    var isActive: Bool = false
    var isLocked: Bool = true
    
    init(configuration: VPNProfileConfiguration) {
        self.configuration = configuration
    }
    
    var name: String { configuration.displayName }
    
    var description: String? { configuration.description }
    
    var flagImageUrl: String? { NetworkingUtils.getImageUrl(countryCode: configuration.countryCode) }
    
    public static func == (lhs: VPNProfileModel, rhs: VPNProfileModel) -> Bool {
        return lhs.configuration.uuid == rhs.configuration.uuid
    }
}
