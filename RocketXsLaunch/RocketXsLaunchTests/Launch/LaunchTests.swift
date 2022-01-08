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
        filter({$0.success})
    }
    
    func filterByYear(_ year: DateComponents) -> [Launch] {
        successful().filter({ Calendar.current.dateComponents([.year], from: $0.date) == year })
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
    
    func test_filterByYear_returnsOnlySuccessfulLaunchDuringTargetYear() {
        let date = Date()
        let threeYearOldDate = dateFrom(date, adding: -3)
        let fiveYearOldDate = dateFrom(date, adding: -5)
        
        let lastThirdYear = calendar.dateComponents([.year], from: threeYearOldDate)
        let lastFifthYear = calendar.dateComponents([.year], from: fiveYearOldDate)
        
        let threeYearOldSuccess = makeUniqueSuccessfulLaunch(threeYearOldDate)
        let threeYearOldUnsuccess = makeUniqueUnSuccessfulLaunch(threeYearOldDate)
        
        let fiveYearOldsuccess = makeUniqueSuccessfulLaunch(fiveYearOldDate)
        let fiveYearOldUnsuccess = makeUniqueUnSuccessfulLaunch(fiveYearOldDate)
        
        XCTAssertEqual([threeYearOldSuccess, threeYearOldUnsuccess, fiveYearOldsuccess, fiveYearOldUnsuccess].filterByYear(lastThirdYear), [threeYearOldSuccess])
        
        XCTAssertEqual([threeYearOldSuccess, threeYearOldUnsuccess, fiveYearOldsuccess, fiveYearOldUnsuccess].filterByYear(lastFifthYear), [fiveYearOldsuccess])
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
