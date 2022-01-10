//
//  HTTPClientSpy.swift
//  RocketXsLaunchTests
//
//  Created by Shad Mazumder on 10/1/22.
//

import Foundation
import RocketXsLaunch

class HTTPClientSpy: HTTPClient {
    var message = [(url: URL, completion: (HTTPResult) -> Void)]()
    var requestedURL: [URL] {
        message.map({ $0.url })
    }
    
    func get(from url: URL, completion: @escaping (HTTPResult) -> Void) {
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
