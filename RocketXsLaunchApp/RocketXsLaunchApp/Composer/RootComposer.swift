//
//  RootComposer.swift
//  FreshRead
//
//  Created by Shad Mazumder on 14/11/21.
//

import UIKit

struct RootComposer {
    static func composeStartingViewController() -> UIViewController {
        return Router().startRouting()
    }
}
