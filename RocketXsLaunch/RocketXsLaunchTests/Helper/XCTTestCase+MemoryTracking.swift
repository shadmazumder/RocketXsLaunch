//
//  XCTTestCase+MemoryTracking.swift
//  RocketXsLaunchTests
//
//  Created by Shad Mazumder on 10/1/22.
//

import XCTest

extension XCTestCase {
    func trackMemoryLeak(_ instance: AnyObject, file: StaticString = #file, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Memory Leak!!! Didn't deallocated", file: file, line: line)
        }
    }
}
