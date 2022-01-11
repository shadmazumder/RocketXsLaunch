//
//  LaunchComposer.swift
//  FreshRead
//
//  Created by Shad Mazumder on 14/11/21.
//

import UIKit
import RocketXsLaunch
import RocketXsLaunchiOS

final class LaunchComposer {
    private init() {}

    static func postViewControllerComposer() -> LaunchesViewController {
        return makeLaunchesViewCotroller()
    }

    private static func makeLaunchesViewCotroller() -> LaunchesViewController {
        let bundle = Bundle(for: LaunchesViewController.self)
        let storyboard = UIStoryboard(name: "Launches", bundle: bundle)

        guard let launchesViewController = storyboard.instantiateInitialViewController() as? LaunchesViewController else {
            return LaunchesViewController()
        }

        configure(launchesViewController)

        return launchesViewController
    }

    private static func configure(_ launchesViewController: LaunchesViewController) {
        LaunchComposer.configureTitle(on: launchesViewController)
        LaunchComposer.configureLoader(on: launchesViewController)
    }

    private static func configureTitle(on launchViewController: LaunchesViewController) {
        launchViewController.title = "SpaceX Launches"
    }

    private static func configureLoader(on launchesViewController: LaunchesViewController) {
        guard let url = URL(string: "https://api.spacexdata.com/v4/launches") else { return }
        let client = HTTPClientWrapper()
        let loader = RemoteLoader<[LaunchAPIModel]>(url: url, client: client)
        launchesViewController.remoteLoader = loader
    }
}
