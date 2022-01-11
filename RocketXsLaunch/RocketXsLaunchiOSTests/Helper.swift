//
//  Helper.swift
//  RocketXsLaunchiOSTests
//
//  Created by Shad Mazumder on 11/1/22.
//

import UIKit
import XCTest
import RocketXsLaunchiOS

extension XCTestCase {
    func trackMemoryLeak(_ instance: AnyObject, file: StaticString = #file, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Memory Leak!!! Didn't deallocated", file: file, line: line)
        }
    }
}

extension LaunchesViewController{
    var cellCount: Int{ tableView.numberOfRows(inSection: 0) }
}
