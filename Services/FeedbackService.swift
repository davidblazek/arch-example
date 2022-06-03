//
//  FeedbackService.swift
//  AppCore
//

import Foundation
import Shared

protocol FeedbackService {
    func getFeedbackTopics(response: @escaping (Result<[ClientFeedbackSubjectEntity], ApiError>) -> Void)
    func sendClientFeedback(subject: ClientFeedbackSubjectEntity, email: String, message: String, logFileUrl: URL, response: @escaping (Result<Void, ApiError>) -> Void)
}

final class FeedbackServiceImpl: BaseNetworkingService, FeedbackService {
    
    func getFeedbackTopics(response: @escaping (Result<[ClientFeedbackSubjectEntity], ApiError>) -> Void) {
        request(endpoint: .feedbackTopics, completion: response)
    }
    
    func sendClientFeedback(subject: ClientFeedbackSubjectEntity, email: String, message: String, logFileUrl: URL, response: @escaping (Result<Void, ApiError>) -> Void) {
        upload(endpoint: .sendFeedback(
            subject: subject,
            email: email,
            message: message,
            device: appInfoService.deviceName,
            platform: appInfoService.platform,
            platformVersion: appInfoService.platformVersion,
            zipFileUrl: logFileUrl
        ), completion: response)
    }
}
