//
//  VPNProfileConfiguration.swift
//  AppCore
//

import Foundation

public struct VPNProfileConfiguration: Codable {
    
    public let uuid: String
    public let ipv4: String
    public let availability: Int? // ratio of up and down time
    public let speed: Int? // unknown units
    public let anonymity: String?
    public let premium: Bool
    public let location: String?
    public let countryCode: String?
    public let description: String?
    public let coordinates: String?
    public let imgUrl: String?
    public let name: String?
    
    public init(
        uuid: String,
        ipv4: String,
        availability: Int?,
        speed: Int?,
        anonymity: String?,
        premium: Bool,
        location: String?,
        countryCode: String?,
        description: String?,
        coordinates: String?,
        imgUrl: String?,
        name: String?) {
        self.uuid = uuid
        self.ipv4 = ipv4
        self.availability = availability
        self.speed = speed
        self.anonymity = anonymity
        self.premium = premium
        self.location = location
        self.countryCode = countryCode
        self.description = description
        self.coordinates = coordinates
        self.imgUrl = imgUrl
        self.name = name
    }
    
    public var displayName: String { "\(name ?? location ?? ipv4 )" }
}
