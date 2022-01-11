//
//  LaunchesViewController.swift
//  RocketXsLaunchiOS
//
//  Created by Shad Mazumder on 11/1/22.
//

import UIKit
import RocketXsLaunch

public final class LaunchesViewController: UIViewController {
    public var remoteLoader: RemoteLoader<LaunchAPIModel>?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        fetchLaunches()
    }
    
    private func fetchLaunches(){
        remoteLoader?.load(completion: { _ in
            
        })
    }
}
