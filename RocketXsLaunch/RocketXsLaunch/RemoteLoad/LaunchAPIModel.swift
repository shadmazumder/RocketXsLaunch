//
//  LaunchAPIModel.swift
//  RocketXsLaunch
//
//  Created by Shad Mazumder on 10/1/22.
//

import Foundation

public struct Patch: Decodable{
    public let small: String
    
    public init(small: String){
        self.small = small
    }
}

public struct Links: Decodable{
    public let patch: Patch
    
    public init(patch: Patch) {
        self.patch = patch
    }
}

public struct LaunchAPIModel {
    public let name: String
    public let id: String
    public let details: String
    public let dateString: String
    public let links: Links
    public let rocketId: String
    public let success: Bool?
    public let upcoming: Bool
    
    public var imageUrl: URL?{ URL(string: links.patch.small) }
    public var date: Date? { ISO8601DateFormatter().date(from: dateString) }
    
    public init(name: String, id: String, details: String, dateString: String, links: Links, rocketId: String, success: Bool?, upcoming: Bool){
        self.name = name
        self.id = id
        self.details = details
        self.dateString = dateString
        self.links = links
        self.rocketId = rocketId
        self.success = success
        self.upcoming = upcoming
    }
}

extension LaunchAPIModel: Decodable{
    enum CodingKeys: String, CodingKey{
        case name
        case id
        case details
        case dateString = "dateUtc"
        case links
        case rocketId = "rocket"
        case success
        case upcoming
    }
}
