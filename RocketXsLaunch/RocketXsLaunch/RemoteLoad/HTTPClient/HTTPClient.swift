//
//  HTTPClient.swift
//  RocketXsLaunch
//
//  Created by Shad Mazumder on 9/1/22.
//

import Foundation

public protocol HTTPClient {
    typealias HTTPResult = Swift.Result<(Data, HTTPURLResponse), Error>

    func get(from url: URL, completion: @escaping (HTTPResult) -> Void)
}
