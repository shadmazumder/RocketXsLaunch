//
//  HTTPClientWrapper.swift
//  RocketXsLaunch
//
//  Created by Shad Mazumder on 9/1/22.
//

import Foundation
import Alamofire

public class HTTPClientWrapper: HTTPClient {
    private let session: Session
    
    public init(sessionCofiguration: URLSessionConfiguration? = nil) {
        let config: URLSessionConfiguration
        
        if let sessionCofiguration = sessionCofiguration {
            config = sessionCofiguration
        }else{
            config = URLSessionConfiguration.default
        }
        
        session = Session(configuration: config)
    }
    
    public func get(from url: URL, completion: @escaping (HTTPResult) -> Void) {
        session.request(url).response { response in
            if let error = response.error{
                completion(.failure(error))
            }
        }
    }
}
