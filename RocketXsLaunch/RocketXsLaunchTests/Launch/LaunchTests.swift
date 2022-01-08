//
//  LaunchTests.swift
//  RocketXsLaunchTests
//
//  Created by Shad Mazumder on 8/1/22.
//

import XCTest
import RocketXsLaunch

class LaunchTests: XCTestCase {
    func test_filterBySuccess_returnsNonFailureLaunch() {
        let nonFailure1 = makeUniqueNonFailureLaunch()
        let nonFailure2 = makeUniqueNonFailureLaunch()
        let failure1 = makeUniqueFailureLaunch()
        let failure2 = makeUniqueFailureLaunch()
        
        XCTAssertEqual([nonFailure1, failure1, nonFailure2, failure2].nonFailure(), [nonFailure1, nonFailure2])
    }
    
    func test_filterByYear_returnsOnlyNonFailureLaunchesDuringTargetYear() {
        let date = Date()
        let threeYearOldDate = dateFrom(date, adding: -3)
        let fiveYearOldDate = dateFrom(date, adding: -5)
        
        let lastThirdYear = calendar.dateComponents([.year], from: threeYearOldDate)
        let lastFifthYear = calendar.dateComponents([.year], from: fiveYearOldDate)
        
        let threeYearOldNonFailure = makeUniqueNonFailureLaunch(threeYearOldDate)
        let threeYearOldFailure = makeUniqueFailureLaunch(threeYearOldDate)
        
        let fiveYearOldNonFailure = makeUniqueNonFailureLaunch(fiveYearOldDate)
        let fiveYearOldFailure = makeUniqueFailureLaunch(fiveYearOldDate)
        
        XCTAssertEqual([threeYearOldNonFailure, threeYearOldFailure, fiveYearOldNonFailure, fiveYearOldFailure].filterByYear(lastThirdYear), [threeYearOldNonFailure])
        
        XCTAssertEqual([threeYearOldNonFailure, threeYearOldFailure, fiveYearOldNonFailure, fiveYearOldFailure].filterByYear(lastFifthYear), [fiveYearOldNonFailure])
    }
    
    func test_upcomingTrueIrespectiveOfSuccess_ReturnsTrueNonFailure() {
        let trueSuccessLaunch = makeUniqueNonFailureLaunch(success: true, upcoming: true)
        let flaseSuccessLaunch = makeUniqueNonFailureLaunch(success: false, upcoming: true)
        let nilSuccessLaunch = makeUniqueNonFailureLaunch(success: nil, upcoming: true)
        
        XCTAssertEqual([trueSuccessLaunch.nonFailure, flaseSuccessLaunch.nonFailure, nilSuccessLaunch.nonFailure], [true, true, true])
    }
    
    func test_upcomingFalseReturns_SuccessValueOnNonFailure() {
        let trueSuccessLaunch = makeUniqueNonFailureLaunch(success: true, upcoming: false)
        let flaseSuccessLaunch = makeUniqueNonFailureLaunch(success: false, upcoming: false)
        
        XCTAssertEqual([trueSuccessLaunch.nonFailure, flaseSuccessLaunch.nonFailure], [true, false])
    }
    
    func test_InvalidCombinationOfUpcommingAndSuccess_returnsFalseNonFailure() {
        let nilSuccessLaunch = makeUniqueNonFailureLaunch(success: nil, upcoming: false)
        let falseSuccessAndFalseUpcomingLaunch = makeUniqueNonFailureLaunch(success: false, upcoming: false)
        
        XCTAssertEqual([nilSuccessLaunch.nonFailure, falseSuccessAndFalseUpcomingLaunch.nonFailure], [false, false])
    }
    
    // MARK: - Helper
    private func makeUniqueNonFailureLaunch(_ date: Date = Date(), success: Bool? = true, upcoming: Bool = false) -> Launch {
        Launch(name: "Any Name", id: UUID().uuidString, details: "Some details", date: date, imageUrl: nil, rocketId: UUID().uuidString, success: success, upcoming: upcoming)
    }
    
    private func makeUniqueFailureLaunch(_ date: Date = Date(), success: Bool = false, upcoming: Bool = false) -> Launch {
        Launch(name: "Any Name", id: UUID().uuidString, details: "Some details", date: date, imageUrl: nil, rocketId: UUID().uuidString, success: success, upcoming: upcoming)
    }
    
    private var calendar: Calendar{
        Calendar(identifier: .gregorian)
    }
    
    private func dateFrom(_ date: Date = Date() , adding year: Int) -> Date {
        calendar.date(byAdding: .year, value: year, to: date)!
    }
}

extension Launch: Equatable{
    public static func == (lhs: Launch, rhs: Launch) -> Bool {
        lhs.id == rhs.id
    }
}
