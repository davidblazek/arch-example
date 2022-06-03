//
//  RootModule.swift
//  AppCore
//

import Foundation
import UIKit
import Swinject
import Shared

public class RootModule: BaseModule {

    private weak var appDelegate: AppDelegateInterface?

    public override init() {
        super.init()
        let assemblies = makeAssemblies(with: instanceProvider)
        instanceProvider.addAssembliesContent(assemblies)
    }
    
    public func initialize(appDelegate: AppDelegateInterface?) {
        self.appDelegate = appDelegate
        
        instanceProvider.register(submodules: [RootCommonAssembly(appDelegateInterface: appDelegate)])
    }
    
    public func start() -> UIViewController {
        return MainModule(parentInstanceProvider: instanceProvider).start()
    }
    
    public func handle(exception: NSException) {
        do {
            try instanceProvider.getInstance(LogService.self).error("\(exception.description)\n\(exception.callStackSymbols)", tag: .uncaughtException)
        } catch {}
    }
    
    internal func makeAssemblies(with instanceProvider: InstanceProvider) -> [Assembly] {
        return []
    }
}

extension RootModule {
    
    public func applicationWillEnterForeground() {
        try? instanceProvider.getInstance(AppWillEnterForegroundController.self).applicationWillEnterForeground()
    }
}
