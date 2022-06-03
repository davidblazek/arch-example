//
//  ServerListAssembly.swift
//  AppCore
//

import Swinject
import SwinjectAutoregistration
import UIKit

public class ServerListAssembly: Assembly {

    public func assemble(container: Container) {
        container.autoregister(ServerListViewModel.self, arguments: VPNProfileModel?.self, ((VPNProfileModel) -> Void).self, initializer: ServerListViewModel.init)
    
        container.register(ServerListViewController.self) { (r, profile: VPNProfileModel?, onServerSelected: @escaping ((VPNProfileModel) -> Void)) in
            let viewModel = r.resolve(ServerListViewModel.self, arguments: profile, onServerSelected)!
            let vc = ServerListViewController(viewModel: viewModel)
            viewModel.viewDelegate = vc
            return vc
        }
    }
}
