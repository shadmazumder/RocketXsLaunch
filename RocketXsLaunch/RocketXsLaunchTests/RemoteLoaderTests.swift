//
//  RemoteLoaderTests.swift
//  RocketXsLaunchTests
//
//  Created by Shad Mazumder on 9/1/22.
//

import XCTest
import RocketXsLaunch

final class RemoteLoader<T: Decodable>{
    typealias Result = Swift.Result<T, Error>
    
    public enum Error: Swift.Error {
        case connectivity
        case non200HTTPResponse
        case invalidData
    }

    private let url: URL
    private let client: HTTPClient

    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    public func load(completion: @escaping ((Result) -> Void)) {
        client.get(from: url) {[weak self] result in
            switch result {
            case let .success((data, response)):
                self?.mapSuccessFrom(response, data, completion)
            default:
                completion(.failure(.connectivity))
            }
        }
    }
    
    private func mapSuccessFrom(_ response: HTTPURLResponse, _ data: Data, _ completion: @escaping ((Result) -> Void)) {
        if response.statusCode == 200 {
            mapResultFrom(data, completion: completion)
        }else {
            completion(.failure(Error.non200HTTPResponse))
        }
    }
    
    private func mapResultFrom(_ data: Data, completion: @escaping ((Result) -> Void)) {
        do {
            let jsonDecoder = JSONDecoder()
            jsonDecoder.dateDecodingStrategy = .iso8601
            let root = try jsonDecoder.decode(T.self, from: data)
            completion(.success(root))
        } catch {
            completion(.failure(Error.invalidData))
        }
    }
}

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
    
    private func anyValidJsonStringWithData() -> (validJsonString: String, data: Data) {
        let validJsonString = "{\"id\":\"some-id\"}"
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let data = try! encoder.encode(validJsonString)

        return (validJsonString, data)
    }
    
    private func trackMemoryLeak(_ instance: AnyObject, file: StaticString = #file, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Memory Leak!!! Didn't deallocated", file: file, line: line)
        }
    }
}

private class HTTPClientSpy: HTTPClient {
    var message = [(url: URL, completion: (HTTPClient.Result) -> Void)]()
    var requestedURL: [URL] {
        message.map({ $0.url })
    }
    
    func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) {
        message.append((url, completion))
    }
    
    func completeWith(_ data: Data, statusCode: Int = 200, index: Int = 0) {
        let response = HTTPURLResponse(url: requestedURL[index], statusCode: statusCode, httpVersion: nil, headerFields: nil)!

        message[index].completion(.success((data, response)))
    }
    
    func completeWithError(_ error: Error, index: Int = 0) {
        message[index].completion(.failure(error))
    }
}
