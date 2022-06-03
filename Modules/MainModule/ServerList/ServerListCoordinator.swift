//
//  ServerListCoordinator.swift
//  AppCore
//

import Foundation
import UIKit

protocol ServerListCoordinable: AlertCoordinable, BaseModalCoordinable {
    func showServerList(current: VPNProfileModel?, onServerSelected: @escaping ((VPNProfileModel) -> Void))
    func closeServerList()
    func showPurchases()
}
