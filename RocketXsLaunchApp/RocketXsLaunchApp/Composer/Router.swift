//
//  Router.swift
//  FreshRead
//
//  Created by Shad Mazumder on 16/11/21.
//

import UIKit
import RocketXsLaunchiOS

struct Router {
    private let navigationController: UINavigationController
    private let launchesViewController = LaunchComposer.postViewControllerComposer()
//    private let rocketDetailsViewController = RocketDetailsComposer.rocketDetailsViewControllerComposer()

    init() {
        navigationController =  UINavigationController(rootViewController: launchesViewController)
    }

    func startRouting() -> UIViewController {
        return navigationController
    }
}
