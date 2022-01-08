//
//  RemoteLoaderTests.swift
//  RocketXsLaunchTests
//
//  Created by Shad Mazumder on 9/1/22.
//

import XCTest

protocol HTTPClient {
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>

    func get(from url: URL, completion: @escaping (Result) -> Void)
}

final class RemotePostLoader{
    typealias Result = Swift.Result<[Decodable], Error>
    
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
        client.get(from: url) { _ in }
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
    
    // MARK: - Helper
    private func makeSUT(_ url: URL = URL(string: "some-url")!) -> (sut: RemotePostLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemotePostLoader(url: url, client: client)

        return(sut, client)
    }
    
    private func anyURL() -> URL {
        return URL(string: "any-url")!
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
}
