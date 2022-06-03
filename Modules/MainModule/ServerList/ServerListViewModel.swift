//
//  ServerListViewModel.swift
//  AppCore
//

import Shared

final class ServerListViewModel {
    
    private let serverListCoordinator: ServerListCoordinable
    private let configurationProvider: VPNServerProvider
    private let subscriptionService: SubscriptionService
    private let logService: LogService
    private let currentServer: VPNProfileModel?
    private let onServerSelected: ((VPNProfileModel) -> Void)
    
    weak var viewDelegate: ServerListViewDelegate?
    
    init(
        serverListCoordinator: ServerListCoordinable,
        configurationProvider: VPNServerProvider,
        subscriptionService: SubscriptionService,
        logService: LogService,
        currentServer: VPNProfileModel?,
        onServerSelected: @escaping ((VPNProfileModel) -> Void)
    ) {
        self.serverListCoordinator = serverListCoordinator
        self.configurationProvider = configurationProvider
        self.subscriptionService = subscriptionService
        self.logService = logService
        self.currentServer = currentServer
        self.onServerSelected = onServerSelected
    }
    
    func viewDidLoad() {
    }
    
    func viewWillAppear() {
        loadServers()
    }
    
    func premiumAction() {
        serverListCoordinator.showPurchases()
    }
    
    func closeAction() {
        serverListCoordinator.closeServerList()
    }
    
    func serverSelected(item: VPNProfileModel) {
        if item.isLocked {
            premiumAction()
        } else {
            onServerSelected(item)
            closeAction()
        }
    }
    
    private func loadServers() {
        viewDelegate?.setLoading(isLoading: true)
        
        let isSubscriptionActive = subscriptionService.isSubscriptionActive()
        viewDelegate?.setIsPremium(isPremium: isSubscriptionActive)
        
        configurationProvider.getAvailableConfigurations { [weak self] result in
            guard let self = self else { return }
            
            self.viewDelegate?.setLoading(isLoading: false)
            switch result {
            case .success(let all):
                all.forEach {
                    $0.isActive = self.currentServer == $0
                    $0.isLocked = !isSubscriptionActive && $0.configuration.premium
                }
                self.viewDelegate?.setServers(items: all)
            case .failure(let error):
                self.logService.error("ServerListViewModel | loadServers | error: \(error.localizedDescription)", tag: .api)
                self.serverListCoordinator.showAlert(title: Localizable.generalAppname(), message: error.message, confirm: Localizable.generalOk(), onConfirm: self.closeAction)
            }
        }
    }
}
