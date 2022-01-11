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
        XCTAssertTrue(launchesViewControllerFromPostSotyboard() is LaunchesViewController, "Initial ViewController is not LaunchesViewController")
    }
    
    func test_loadView_rendresHeader() {
        let headerText = "Some Header"
        let sut = makeSUT(headerText)

        sut.loadViewIfNeeded()

        XCTAssertEqual(sut.title, headerText)
    }
    
    func test_init_rendersNoItems() {
        let sut = makeSUT()
        sut.loadViewIfNeeded()

        XCTAssertEqual(sut.cellCount, 0)
    }
        
    // MARK: - Helper
    private func makeSUT(_ headerText: String = "") -> LaunchesViewController{
        let sut = launchesViewControllerFromPostSotyboard() as! LaunchesViewController
        sut.title = headerText
        return sut
    }
    
    private func launchesViewControllerFromPostSotyboard() -> UIViewController? {
        let bundle = Bundle(for: LaunchesViewController.self)
        let storyboard = UIStoryboard(name: "Launches", bundle: bundle)
        return storyboard.instantiateInitialViewController()
    }
}

