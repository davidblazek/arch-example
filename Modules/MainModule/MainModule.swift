//
//  MainModule.swift
//  AppCore
//

import Foundation
import UIKit
import Swinject

public class MainModule {

    let instanceProvider: InstanceProvider
    
    public init(parentInstanceProvider: InstanceProvider) {
        self.instanceProvider = InstanceProvider(parentInstanceProvider: parentInstanceProvider)
    }
    
    public func start() -> UIViewController {
        let navigationController = NavigationController()
        instanceProvider.addAssembliesContent(makeAssemblies(with: instanceProvider, navigationController: navigationController))
        
        do {
            let mainViewController = try instanceProvider.getInstance(MainViewController.self)
            navigationController.setViewControllers([mainViewController], animated: false)
            return navigationController
        } catch {}
        
        return UIViewController()
    }
    
    internal func makeAssemblies(with instanceProvider: InstanceProvider, navigationController: UINavigationController) -> [Assembly] {
        return [
            MainAssembly(instanceProvider: instanceProvider, navigationController: navigationController),
            VPNAssembly(),
            StoreKitAssembly(),
            AgreementAssembly(),
            ServerListAssembly(),
            ProfileTutorialAssembly(),
            PurchaseAssembly(),
            FeedbackAssembly()
        ]
    }
}
