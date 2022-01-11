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
    func test_init_doesNotStartLoading() {
        assertLoadingCount(0)
    }
    
    // MARK: - Helper
    private func makeSUT(_ headerText: String = "", loader: RemoteLoader<LaunchAPIModel>) -> LaunchesViewController {
        let sut = LaunchesViewControllerFromPostSotyboard()
        sut.remoteLoader = loader
        sut.title = headerText
        
        trackMemoryLeak(sut)
        trackMemoryLeak(loader)
        
        return sut
    }
    
    private func assertLoadingCount(_ extectedCount: Int, action: (() -> ())? = nil){
        var counter = 0
        struct Client: HTTPClient{
            func get(from url: URL, completion: @escaping (HTTPResult) -> Void) {}
        }
        
        let loader = RemoteLoader<LaunchAPIModel>(url: URL(string: "any-url")!, client: Client())
        loader.load { _ in
            counter = +1
        }
        
        let _ = makeSUT(loader: loader)
        action?()
        XCTAssertEqual(counter, extectedCount)
    }
    
    private func LaunchesViewControllerFromPostSotyboard() -> LaunchesViewController {
        let bundle = Bundle(for: LaunchesViewController.self)
        let storyboard = UIStoryboard(name: "Launches", bundle: bundle)
        return storyboard.instantiateInitialViewController() as! LaunchesViewController
    }
}

extension XCTestCase {
    func trackMemoryLeak(_ instance: AnyObject, file: StaticString = #file, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Memory Leak!!! Didn't deallocated", file: file, line: line)
        }
    }
}

