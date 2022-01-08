//
//  Launch.swift
//  RocketXsLaunch
//
//  Created by Shad Mazumder on 8/1/22.
//

import Foundation

public struct Launch {
    public let name: String
    public let id: String
    public let details: String
    public let date: Date
    public let imageUrl: URL?
    public let rocketId: String
    public let success: Bool?
    public let upcoming: Bool
    
    public init(name: String, id: String, details: String, date: Date, imageUrl: URL?, rocketId: String, success: Bool?, upcoming: Bool) {
        self.name = name
        self.id = id
        self.details = details
        self.date = date
        self.imageUrl = imageUrl
        self.rocketId = rocketId
        self.success = success
        self.upcoming = upcoming
    }
}

extension Launch{
    public var nonFailure: Bool{
        guard let success = success else { return upcoming }
        return success || upcoming
    }
}

extension Array where Element == Launch{
    public func nonFailure() -> [Launch]{
        filter({$0.nonFailure})
    }
    
    public func filterByYear(_ year: DateComponents) -> [Launch] {
        nonFailure().filter({ Calendar.current.dateComponents([.year], from: $0.date) == year })
    }
}
