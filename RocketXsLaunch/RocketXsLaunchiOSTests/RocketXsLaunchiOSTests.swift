//
//  RocketXsLaunchiOSTests.swift
//  RocketXsLaunchiOSTests
//
//  Created by Shad Mazumder on 11/1/22.
//

import XCTest
import RocketXsLaunch
import RocketXsLaunchiOS

class RocketXsLaunchiOSTests: XCTestCase {
    func test_loadingFromStoryboard_returnsLaunchesViewController() {
        XCTAssertTrue(LaunchesViewControllerFromPostSotyboard() is LaunchesViewController)
    }
    
    // MARK: - Helper
    private func LaunchesViewControllerFromPostSotyboard() -> UIViewController? {
        let bundle = Bundle(for: LaunchesViewController.self)
        let storyboard = UIStoryboard(name: "Launches", bundle: bundle)
        return storyboard.instantiateInitialViewController()
    }
}

extension XCTestCase {
    func trackMemoryLeak(_ instance: AnyObject, file: StaticString = #file, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Memory Leak!!! Didn't deallocated", file: file, line: line)
        }
    }
}

