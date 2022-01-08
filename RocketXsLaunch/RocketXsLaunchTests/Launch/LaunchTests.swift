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
    let success: Bool?
    let upcoming: Bool
}

extension Launch{
    var nonFailure: Bool{
        guard let success = success else { return upcoming }
        return success || upcoming
    }
}

extension Array where Element == Launch{
    func nonFailure() -> [Launch]{
        filter({$0.nonFailure})
    }
    
    func filterByYear(_ year: DateComponents) -> [Launch] {
        nonFailure().filter({ Calendar.current.dateComponents([.year], from: $0.date) == year })
    }
}

class LaunchTests: XCTestCase {
    func test_filterBySuccess_returnsNonFailureLaunch() {
        let nonFailure1 = makeUniqueSuccessfulLaunch()
        let nonFailure2 = makeUniqueSuccessfulLaunch()
        let failure1 = makeUniqueUnSuccessfulLaunch()
        let failure2 = makeUniqueUnSuccessfulLaunch()
        
        XCTAssertEqual([nonFailure1, failure1, nonFailure2, failure2].nonFailure(), [nonFailure1, nonFailure2])
    }
    
    func test_filterByYear_returnsOnlyNonFailureLaunchesDuringTargetYear() {
        let date = Date()
        let threeYearOldDate = dateFrom(date, adding: -3)
        let fiveYearOldDate = dateFrom(date, adding: -5)
        
        let lastThirdYear = calendar.dateComponents([.year], from: threeYearOldDate)
        let lastFifthYear = calendar.dateComponents([.year], from: fiveYearOldDate)
        
        let threeYearOldNonFailure = makeUniqueSuccessfulLaunch(threeYearOldDate)
        let threeYearOldFailure = makeUniqueUnSuccessfulLaunch(threeYearOldDate)
        
        let fiveYearOldNonFailure = makeUniqueSuccessfulLaunch(fiveYearOldDate)
        let fiveYearOldFailure = makeUniqueUnSuccessfulLaunch(fiveYearOldDate)
        
        XCTAssertEqual([threeYearOldNonFailure, threeYearOldFailure, fiveYearOldNonFailure, fiveYearOldFailure].filterByYear(lastThirdYear), [threeYearOldNonFailure])
        
        XCTAssertEqual([threeYearOldNonFailure, threeYearOldFailure, fiveYearOldNonFailure, fiveYearOldFailure].filterByYear(lastFifthYear), [fiveYearOldNonFailure])
    }
    
    // MARK: - Helper
    private func makeUniqueSuccessfulLaunch(_ date: Date = Date()) -> Launch {
        Launch(name: "Any Name", id: UUID(), details: "Some details", date: date, imageUrl: nil, rocketId: UUID(), success: true, upcoming: false)
    }
    
    private func makeUniqueUnSuccessfulLaunch(_ date: Date = Date()) -> Launch {
        Launch(name: "Any Name", id: UUID(), details: "Some details", date: date, imageUrl: nil, rocketId: UUID(), success: false, upcoming: false)
    }
    
    private var calendar: Calendar{
        Calendar(identifier: .gregorian)
    }
    
    private func dateFrom(_ date: Date = Date() , adding year: Int) -> Date {
        calendar.date(byAdding: .year, value: year, to: date)!
    }
}

extension Launch: Equatable{}
