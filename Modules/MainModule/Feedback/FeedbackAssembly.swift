//
//  FeedbackAssembly.swift
//  AppCore
//

import Swinject
import SwinjectAutoregistration
import UIKit

public class FeedbackAssembly: Assembly {

    public func assemble(container: Container) {
        container.autoregister(FeedbackService.self, initializer: FeedbackServiceImpl.init)
        
        container.autoregister(FeedbackViewModel.self, initializer: FeedbackViewModel.init)
        
        container.register(FeedbackViewController.self) { (r) in
            let viewModel = r.resolve(FeedbackViewModel.self)!
            let vc = FeedbackViewController(viewModel: viewModel)
            viewModel.viewDelegate = vc
            return vc
        }
    }
}
