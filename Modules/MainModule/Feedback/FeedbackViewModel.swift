//
//  FeedbackViewModel.swift
//  AppCore
//

import Foundation
import Shared

final class FeedbackViewModel {

    private let coordinator: FeedbackCoordinable
    private let feedbackService: FeedbackService
    private let logService: LogService
    
    weak var viewDelegate: FeedbackViewDelegate?
    
    private(set) var feedbackTopics: [ClientFeedbackSubjectEntity] = []
    
    init(feedbackCoordinator: FeedbackCoordinable, feedbackService: FeedbackService, logService: LogService) {
        self.coordinator = feedbackCoordinator
        self.feedbackService = feedbackService
        self.logService = logService
    }
    
    func viewDidLoad() {
        loadTopics()
    }
    
    func loadTopics() {
        viewDelegate?.setLoading(isLoading: true)
        
        feedbackService.getFeedbackTopics { [weak self] result in
            switch result {
            case .success(let topics):
                if !topics.isEmpty {
                    self?.feedbackTopics = topics
                    self?.viewDelegate?.setTopics(topics: topics)
                    self?.viewDelegate?.setLoading(isLoading: false)
                } else {
                    self?.coordinator.showAlert(title: Localizable.generalError(), message: Localizable.feedbackErrorNotloaded(), confirm: Localizable.generalOk()) { self?.closeAction() }
                }
            case .failure(let error):
                self?.logService.error("FeedbackViewModel | loadTopics | error: \(error.localizedDescription)", tag: .api)
                self?.coordinator.showAlert(title: Localizable.generalError(), message: error.message, confirm: Localizable.generalOk()) { self?.closeAction() }
            }
        }
    }
    
    func closeAction() {
        coordinator.closeFeedback()
    }
    
    func send(category: ClientFeedbackSubjectEntity?, email: String?, comment: String?) {
        guard validateInput(category: category, email: email, comment: comment) else {
            return
        }

        if let url = logService.getZippedLogFileUrl(), let email = email, let comment = comment, let subject = category {
            viewDelegate?.setLoading(isLoading: true)
            feedbackService.sendClientFeedback(subject: subject, email: email, message: comment, logFileUrl: url) { [weak self] result in
                self?.viewDelegate?.setLoading(isLoading: false)
                switch result {
                case .success:
                    self?.coordinator.showAlert(title: Localizable.feedbackSuccessTitle(), message: Localizable.feedbackSuccessMessage(), confirm: Localizable.generalOk()) { self?.closeAction() }
                case .failure(let error):
                    self?.logService.error("FeedbackViewModel | send | error: \(error.localizedDescription)", tag: .api)
                    self?.coordinator.showAlert(title: Localizable.generalError(), message: error.message, confirm: Localizable.generalOk())
                }
            }
        }
    }
    
    private func validateInput(category: ClientFeedbackSubjectEntity?, email: String?, comment: String?) -> Bool {
        let invalidCategory = category == nil
        let invalidComment = comment.isEmptyOrWhitespace
        let invalidEmail = email.isNullOrEmpty || email?.isValidEmail() == false
        
        if invalidCategory || invalidEmail || invalidComment {
            viewDelegate?.setInvalidData(invalidCategory: invalidCategory, invalidEmail: invalidEmail, invalidComment: invalidComment)
            return false
        }
        return true
    }
}
