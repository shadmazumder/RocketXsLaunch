//
//  LaunchesViewController.swift
//  RocketXsLaunchiOS
//
//  Created by Shad Mazumder on 11/1/22.
//

import UIKit
import RocketXsLaunch

public final class LaunchesViewController: UIViewController {
    @IBOutlet public weak var tableView: UITableView!

    public var remoteLoader: RemoteLoader<LaunchAPIModel>?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        fetchLaunches()
    }
    
    private func fetchLaunches(){
        tableView.refreshControl?.beginRefreshing()
        
        remoteLoader?.load(completion: { [weak self] _ in
            
            self?.tableView.refreshControl?.endRefreshing()
        })
    }
    
    @IBAction func filterBy(_ sender: Any) {
    }
    
}
