//
//  RemoteLoader.swift
//  RocketXsLaunch
//
//  Created by Shad Mazumder on 9/1/22.
//

import Foundation

public final class RemoteLoader<T: Decodable>{
    public typealias Result = Swift.Result<T, Error>
    
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
            jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
            jsonDecoder.dateDecodingStrategy = .iso8601
            let root = try jsonDecoder.decode(T.self, from: data)
            completion(.success(root))
        } catch {
            completion(.failure(Error.invalidData))
        }
    }
}
