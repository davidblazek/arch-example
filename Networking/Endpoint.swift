//
//  Endpoint.swift
//  AppCore
//

import Foundation
import Alamofire

public enum Endpoint {
    
    case feedbackTopics
    case sendFeedback(subject: ClientFeedbackSubjectEntity, email: String, message: String, device: String, platform: String, platformVersion: String, zipFileUrl: URL)
    case serverList(locale: String)
    
    var path: String {
        switch self {
        case .feedbackTopics: return "/log_feedback_subject"
        case .sendFeedback: return "/log_feedback"
        case .serverList: return "/servers"
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .feedbackTopics, .serverList:
            return .get
        case .sendFeedback:
            return .post
        }
    }
    
    var contentType: String {
        switch self {
        case .sendFeedback:
            return "multipart/form-data"
        default:
            return "application/json"
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .sendFeedback(let subject, let email, let message, let device, let platform, let platformVersion, let zipFileUrl):
            return ["subjectId": subject.id ?? 0, "email": email, "message": message, "device": device, "platform": platform, "platformVersion": platformVersion, "zipFile": zipFileUrl]
        case .serverList(let locale):
            return ["locale": locale]
        default:
            return [String: Any]()
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        default:
            switch method {
            case .post, .put:
                return JSONEncoding.default
            default:
                return URLEncoding(destination: URLEncoding.Destination.methodDependent)
            }
        }
    }
}
