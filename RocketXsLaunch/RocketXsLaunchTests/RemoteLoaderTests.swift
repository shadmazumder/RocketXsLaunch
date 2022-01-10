//
//  RemoteLoaderTests.swift
//  RocketXsLaunchTests
//
//  Created by Shad Mazumder on 9/1/22.
//

import XCTest
import RocketXsLaunch

class RemoteLoaderTests: XCTestCase {
    func test_init_doesNotRequestDataFromURL() {
        let (_, client) = makeSUT()

        XCTAssertTrue(client.message.isEmpty)
    }
    
    func test_load_requestDataFromURL() {
        let url = anyURL()
        let (sut, client) = makeSUT(url)

        sut.load { _ in }

        XCTAssertEqual(client.requestedURL, [url])
    }
    
    func test_loadTwice_requestTwiceDataFromURL() {
        let url = anyURL()
        let (sut, client) = makeSUT(url)

        sut.load { _ in }
        sut.load { _ in }

        XCTAssertEqual(client.requestedURL, [url, url])
    }
    
    func test_load_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()
        let anyError = NSError(domain: "Any doamin", code: 0)

        expect(sut, tocompleteWith: .failure(RemoteLoader.Error.connectivity)) {
            client.completeWithError(anyError)
        }
    }
    
    func test_load_deliversNon200ResponseErrorOnNon200HTTPResponseStatusCode() {
        let (sut, client) = makeSUT()
        let non200HTTPResponseStatusCode = [199, 201, 233, 401]

        non200HTTPResponseStatusCode.enumerated().forEach({ index, statusCode in
            expect(sut, tocompleteWith: .failure(RemoteLoader.Error.non200HTTPResponse)) {
                client.completeWith(Data(), statusCode: statusCode, index: index)
        } })
    }
    
    func test_load_deliversEmptyItemsOn200HTTPResponseWithEmptyJSON() {
        let (sut, client) = makeSUT()
        let emptyEntities = ""

        expect(sut, tocompleteWith: .success("")) {
            let data = try! JSONEncoder().encode(emptyEntities)
            client.completeWith(data)
        }
    }
    
    func test_load_deliversItemsOn200HTTPResponseWithJSONItems() {
        let (sut, client) = makeSUT()
        let jsonWithData = anyValidJsonStringWithData()

        expect(sut, tocompleteWith: .success(jsonWithData.validJsonString)) {
            client.completeWith(jsonWithData.data)
        }
    }
    
    func test_load_doesNotDeliverResultAfterSUTBeenDeallocated() {
        let client = HTTPClientSpy()
        var sut: RemoteLoaderStringType? = RemoteLoaderStringType(url: anyURL(), client: client)
        var receivedResult: RemoteLoaderStringType.Result?
        sut?.load(completion: { receivedResult = $0 })

        sut = nil
        client.completeWith(anyValidJsonStringWithData().data)

        XCTAssertNil(receivedResult)
    }
    
    func test_load_deliversItemOnSnakeCaseKey() {
        struct Flight: Codable, Equatable{
            let flightNumber: Int
        }
        let expectedResult = Flight(flightNumber: 1)
        let json = """
        {
            "flight_number": 1
        }
        """.data(using: .utf8)!
        
        let client = HTTPClientSpy()
        let sut = RemoteLoader<Flight>(url: URL(string: "any-url")!, client: client)
        
        let exp = expectation(description: "Waiting for the client")

        sut.load { result in
            switch (result) {
            case let .success(recieved):
                XCTAssertEqual(recieved, expectedResult)
            default:
                XCTFail("Expected \(expectedResult) but got \(result)")
            }
            exp.fulfill()
        }
        
        client.completeWith(json)

        wait(for: [exp], timeout: 1.0)
    }
    
    // MARK: - Helper
    private typealias RemoteLoaderStringType = RemoteLoader<String>
    
    private func makeSUT(_ url: URL = URL(string: "some-url")!) -> (sut: RemoteLoaderStringType, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteLoaderStringType(url: url, client: client)
        
        trackMemoryLeak(client)
        trackMemoryLeak(sut)

        return(sut, client)
    }
    
    private func anyURL() -> URL {
        return URL(string: "any-url")!
    }
    
    private func expect(_ sut: RemoteLoaderStringType, tocompleteWith expectedResult: RemoteLoaderStringType.Result, when action: ()-> Void, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Waiting for the client")

        sut.load { result in
            switch (result, expectedResult) {
            case let (.success(recieved), .success(expected)):
                XCTAssertEqual(recieved, expected, file: file, line: line)
            case let (.failure(receivedError), .failure(expectedError)):
                XCTAssertEqual(receivedError.localizedDescription, expectedError.localizedDescription, file: file, line: line)

            default:
                XCTFail("Expected \(expectedResult) but got \(result)", file: file, line: line)
            }
            exp.fulfill()
        }

        action()

        wait(for: [exp], timeout: 1.0)
    }
    
    private func anyValidJsonStringWithData(_ validJsonString: String = "{\"id\":\"some-id\"}") -> (validJsonString: String, data: Data) {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let data = try! encoder.encode(validJsonString)

        return (validJsonString, data)
    }
}
