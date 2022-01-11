//
//  LaunchAPIModelMapper.swift
//  RocketXsLaunchTests
//
//  Created by Shad Mazumder on 10/1/22.
//

import Foundation
import RocketXsLaunch

public struct LaunchAPIModelMapper {
    public let name: String
    public let id: String
    public let details: String
    public let dateString: String
    public let links: Links
    public let rocketId: String
    public let success: Bool?
    public let upcoming: Bool
    
    public var imageUrl: URL?{ URL(string: (links.patch?.small!)!) }
    public var date: Date? { ISO8601DateFormatter().date(from: dateString) }
}

extension LaunchAPIModelMapper: Equatable{
    public static func == (lhs: LaunchAPIModelMapper, rhs: LaunchAPIModelMapper) -> Bool {
        (lhs.id == rhs.id &&
        lhs.id == rhs.id &&
        lhs.details == rhs.details &&
        lhs.dateString == rhs.dateString &&
        lhs.rocketId == rhs.rocketId &&
        lhs.success == rhs.success &&
        lhs.upcoming == rhs.upcoming &&
        lhs.imageUrl! == rhs.imageUrl! &&
        lhs.date! == rhs.date!)
    }
    
}

extension LaunchAPIModelMapper{
    var model: LaunchAPIModel{
        LaunchAPIModel(name: name,
                       id: id,
                       details: details,
                       dateString: dateString,
                       links: links,
                       rocketId: rocketId,
                       success: success,
                       upcoming: upcoming)
    }
}

extension LaunchAPIModel{
    var mapper: LaunchAPIModelMapper{
        LaunchAPIModelMapper(name: name,
                             id: id,
                             details: details!,
                             dateString: dateString,
                             links: links!,
                             rocketId: rocketId,
                             success: success,
                             upcoming: upcoming)
    }
}
