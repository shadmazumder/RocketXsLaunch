//
//  AppDelegate.swift
//  RocketXsLaunchApp
//
//  Created by Shad Mazumder on 8/1/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    typealias LaunchOptions = [UIApplication.LaunchOptionsKey: Any]?
    typealias Option = UIScene.ConnectionOptions
    typealias SceneConfig = UISceneConfiguration

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: LaunchOptions) -> Bool {
        return true
    }

    func application(_ app: UIApplication, configurationForConnecting: UISceneSession, options: Option) -> SceneConfig {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: configurationForConnecting.role)
    }
}

