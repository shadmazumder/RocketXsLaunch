//
//  Loader.swift
//  RocketXsLaunch
//
//  Created by Shad Mazumder on 11/1/22.
//

import Foundation

public protocol Loader {
    associatedtype APIModel: Decodable
    associatedtype LoaderError: Error
    
    typealias Result = Swift.Result<APIModel, LoaderError>

    func load(completion: @escaping ((Result) -> Void))
}
