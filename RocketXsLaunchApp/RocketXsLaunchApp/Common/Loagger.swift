//
//  Loagger.swift
//  FreshRead
//
//  Created by Shad Mazumder on 17/11/21.
//

import Foundation

protocol Loggable {
    func log(event: String?, for context: String?)
}

/*
 The Logger is a concrete implementation of the Loggable protocol. Add the corresponding logger and log the anomalies
 */
struct Logger: Loggable {
    func log(event: String?, for context: String?) {}
}
