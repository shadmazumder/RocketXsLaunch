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
        let givenURL = anyValidURL()
        let exp = expectation(description: "Waiting for response")
        
        URLProtocolStub.observeRequest { request in
            XCTAssertEqual(request.url, givenURL)
            XCTAssertEqual(request.httpMethod, "GET")
            exp.fulfill()
        }
        
        makeSUT().get(from: givenURL) { _ in }
        
        wait(for: [exp], timeout: 0.5)
    }
    
    func test_getFromURL_failsOnRequestError() {
        let givenError = NSError(domain: "Session error", code: 1)
        
        let receivedError = requestErrorFor(data: nil, response: nil, expectedError: givenError) as NSError?
        
        XCTAssertNotNil(receivedError)
    }
    
    func test_getFromURL_failsOnAllInvalidValueRepresentatio() {
        XCTAssertNotNil(requestErrorFor(data: nil, response: nil, expectedError: nil))
        XCTAssertNotNil(requestErrorFor(data: nil, response: nonHTTPURLResponse(), expectedError: nil))
        XCTAssertNotNil(requestErrorFor(data: anyData(), response: nil, expectedError: nil))
        XCTAssertNotNil(requestErrorFor(data: anyData(), response: anyHTTPURLResponse(), expectedError: anyNSError()))
        XCTAssertNotNil(requestErrorFor(data: nil, response: nonHTTPURLResponse(), expectedError: anyNSError()))
        XCTAssertNotNil(requestErrorFor(data: nil, response: anyHTTPURLResponse(), expectedError: anyNSError()))
        XCTAssertNotNil(requestErrorFor(data: anyData(), response: nonHTTPURLResponse(), expectedError: anyNSError()))
        XCTAssertNotNil(requestErrorFor(data: anyData(), response: anyHTTPURLResponse(), expectedError: anyNSError()))
        XCTAssertNotNil(requestErrorFor(data: anyData(), response: nonHTTPURLResponse(), expectedError: nil))
    }
    
    func test_getFromURL_suceedsOnHTTPURLResponseWithData() {
        let expectedData = anyData()
        let expectedHTTPResponse = anyHTTPURLResponse()
        let receivedValues = requestValuesFor(data: expectedData, response: expectedHTTPResponse, expectedError: nil)

        URLProtocolStub.stub(data: expectedData, response: expectedHTTPResponse, error: nil)

        XCTAssertEqual(receivedValues?.data, expectedData)
        XCTAssertEqual(receivedValues?.response.url, expectedHTTPResponse.url)
        XCTAssertEqual(receivedValues?.response.statusCode, expectedHTTPResponse.statusCode)

    }
    
    func test_getFromURL_failsWithNilDataOnHTTPURLResponseWithNilData() {
        let expectedHTTPResponse = anyHTTPURLResponse()
        let receivedError = requestErrorFor(data: nil, response: expectedHTTPResponse, expectedError: nil)

        URLProtocolStub.stub(data: nil, response: expectedHTTPResponse, error: nil)

        XCTAssertNotNil(receivedError)
    }
    
    // MARK: - Helper
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> HTTPClient {
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.protocolClasses = [URLProtocolStub.self]
        
        let sut = HTTPClientWrapper(sessionCofiguration: sessionConfig)
        trackMemoryLeak(sut)
        return sut
    }
    
    private func anyValidURL() -> URL {
        return URL(string: "https://api.spacexdata.com/v4/launches")!
    }
    
    private func requestErrorFor(data: Data?, response: URLResponse?, expectedError: Error?, file: StaticString = #file, line: UInt = #line) -> Error? {
        let result  = requestResultFor(data: data, response: response, expectedError: expectedError, file: file, line: line)
        
        switch result {
        case let .failure(error):
            return error
        default:
            XCTFail("Was expecting failure but got \(result)", file: file, line: line)
            return nil
        }
    }
    
    private func requestResultFor(data: Data?, response: URLResponse?, expectedError: Error?, file: StaticString = #file, line: UInt = #line) -> HTTPClient.HTTPResult {
        let exp = expectation(description: "Waiting for completion")
        let sut = makeSUT(file: file, line: line)
        
        URLProtocolStub.stub(data: data, response: response, error: expectedError)
        
        var receivedResults: HTTPClient.HTTPResult!
        
        sut.get(from: anyValidURL()) { result in
            receivedResults = result
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
        
        return receivedResults
    }
    
    private func requestValuesFor(data: Data?, response: URLResponse?, expectedError: Error?, file: StaticString = #file, line: UInt = #line) -> (data: Data, response: HTTPURLResponse)? {
        let result  = requestResultFor(data: data, response: response, expectedError: expectedError, file: file, line: line)

        switch result {
        case let .success((receivedData, receivedResponse)):
            return (receivedData, receivedResponse)
        default:
            XCTFail("Was expecting Success but got \(result)", file: file, line: line)
            return nil
        }
    }
    
    private func nonHTTPURLResponse() -> URLResponse {
        return URLResponse(url: anyValidURL(), mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
    }

    private func anyHTTPURLResponse() -> HTTPURLResponse {
        return HTTPURLResponse(url: anyValidURL(), statusCode: 200, httpVersion: nil, headerFields: nil)!
    }
    
    private func anyData() -> Data {
        return Data("any data".utf8)
    }
    
    func anyNSError() -> NSError {
        return NSError(domain: "any domain", code: 0, userInfo: nil)
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

