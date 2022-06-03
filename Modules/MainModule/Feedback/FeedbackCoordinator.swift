//
//  FeedbackCoordinator.swift
//  AppCore
//

import Foundation

protocol FeedbackCoordinable: AlertCoordinable {
    func showFeedback()
    func closeFeedback()
}
