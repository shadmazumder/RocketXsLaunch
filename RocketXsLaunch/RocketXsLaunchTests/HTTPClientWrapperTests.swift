//
//  HTTPClientWrapperTests.swift
//  RocketXsLaunchTests
//
//  Created by Shad Mazumder on 9/1/22.
//

import XCTest
import RocketXsLaunch

class HTTPClientWrapperTests: XCTestCase {
    override func setUp() {
        super.setUp()
        URLProtocolStub.startInterceptingRequest()
    }

    override func tearDown() {
        super.tearDown()
        URLProtocolStub.stopInterceptingRequest()
    }
    
    func test_getFromURL_performsGETRequestWithURL() {
        let givenURL = anyURL()
        let exp = expectation(description: "Waiting for response")

        URLProtocolStub.observeRequest { request in
            XCTAssertEqual(request.url, givenURL)
            XCTAssertEqual(request.httpMethod, "GET")
            exp.fulfill()
        }

        makeSUT().get(from: givenURL) { _ in }

        wait(for: [exp], timeout: 0.5)
    }
    
    // MARK: - Helper
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> HTTPClient {
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.protocolClasses = [URLProtocolStub.self]
        
        let sut = HTTPClientWrapper(sessionCofiguration: sessionConfig)
        return sut
    }

    private func anyURL() -> URL {
        return URL(string: "any-url")!
    }
}

private class URLProtocolStub: URLProtocol {
    private struct Stub {
        let data: Data?
        let response: URLResponse?
        let error: Error?
    }

    private static var stub: Stub?
    private static var requestObservable: ((URLRequest) -> Void)?

    static func stub(data: Data?, response: URLResponse?, error: Error?) {
        stub = Stub(data: data, response: response, error: error)
    }

    static func observeRequest(observer: @escaping ((URLRequest)-> Void)) {
        requestObservable = observer
    }

    static func startInterceptingRequest() {
        URLProtocol.registerClass(URLProtocolStub.self)
    }

    static func stopInterceptingRequest() {
        URLProtocol.unregisterClass(URLProtocolStub.self)
        stub = nil
        URLProtocolStub.requestObservable = nil
    }

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        if let requestObserver = URLProtocolStub.requestObservable {
            client?.urlProtocolDidFinishLoading(self)
            return requestObserver(request)
        }

        if let data = URLProtocolStub.stub?.data {
            client?.urlProtocol(self, didLoad: data)
        }

        if let response = URLProtocolStub.stub?.response {
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        }

        if let error = URLProtocolStub.stub?.error {
            client?.urlProtocol(self, didFailWithError: error)
        }

        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}
}

