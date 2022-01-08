//
//  LaunchTests.swift
//  RocketXsLaunchTests
//
//  Created by Shad Mazumder on 8/1/22.
//

import XCTest

struct Launch {
    let name: String
    let id: UUID
    let details: String
    let date: Date
    let imageUrl: URL?
    let rocketId: UUID
    let success: Bool
}

extension Array where Element == Launch{
    func successful() -> [Launch]{
        self.filter({$0.success})
    }
}

class LaunchTests: XCTestCase {
    func test_filterBySuccess_returnsSeccessfullLaunch() {
        let success1 = makeUniqueSuccessfulLaunch()
        let success2 = makeUniqueSuccessfulLaunch()
        let unsuccess1 = makeUniqueUnSuccessfulLaunch()
        let unsuccess2 = makeUniqueUnSuccessfulLaunch()
        
        XCTAssertEqual([success1, unsuccess1, success2, unsuccess2].successful(), [success1, success2])
    }
    
    // MARK: - Helper
    private func makeUniqueSuccessfulLaunch(_ date: Date = Date()) -> Launch {
        Launch(name: "Any Name", id: UUID(), details: "Some details", date: date, imageUrl: nil, rocketId: UUID(), success: true)
    }
    
    private func makeUniqueUnSuccessfulLaunch(_ date: Date = Date()) -> Launch {
        Launch(name: "Any Name", id: UUID(), details: "Some details", date: date, imageUrl: nil, rocketId: UUID(), success: false)
    }
    
    private var calendar: Calendar{
        Calendar(identifier: .gregorian)
    }
    
    private func dateFrom(_ date: Date = Date() , adding year: Int) -> Date {
        calendar.date(byAdding: .year, value: year, to: date)!
    }
}

extension Launch: Equatable{}
