//
//  ClientFeedbackSubjectEntity.swift
//  AppCore
//

import Foundation

public struct ClientFeedbackSubjectEntity: PickerItem, Codable {
    
    public let id: Int?
    public let name: String?

    public init(id: Int?, name: String?) {
        self.id = id
        self.name = name
    }

    public func getTitle() -> String {
        switch id {
        case 1: return Localizable.feedbackCategory1()
        case 2: return Localizable.feedbackCategory2()
        case 3: return Localizable.feedbackCategory3()
        case 4: return Localizable.feedbackCategory4()
        case 5: return Localizable.feedbackCategory5()
        case 6: return Localizable.feedbackCategory6()
        default: return Localizable.feedbackCategory6()
        }
    }
}
