//
//  BaseModule.swift
//  AppCore
//

open class BaseModule {
    
    public let instanceProvider = InstanceProvider(parentContainer: SharedModule.container)
    
    public init() {
    }
}
