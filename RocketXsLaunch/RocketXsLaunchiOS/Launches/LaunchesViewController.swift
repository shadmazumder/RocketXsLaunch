//
//  LaunchesViewController.swift
//  RocketXsLaunchiOS
//
//  Created by Shad Mazumder on 11/1/22.
//

import UIKit
import RocketXsLaunch
import RxSwift
import RxCocoa
import Kingfisher

public final class LaunchesViewController: UIViewController {
    @IBOutlet public weak var tableView: UITableView!
    public var remoteLoader: RemoteLoader<[LaunchAPIModel]>?
    
    private let disposeBag = DisposeBag()
    private let launchs: BehaviorRelay<[LaunchViewModel]> = BehaviorRelay(value: [])
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        fetchLaunches()
    }
    
    private func configureTableView(){
        launchs.bind(to: tableView.rx.items(cellIdentifier: LaunchTableViewCell.ReuseableIdentifier,
                                            cellType: LaunchTableViewCell.self))
        { row, model, cell in
            cell.name.text = model.name
            cell.launchNumber.text = model.id
            cell.date.text = model.dateString
            cell.launchDetails.text = model.details
            
            if let imageUrl = model.imageUrl{
                cell.patchImageView.kf.setImage(with: imageUrl)
            }
            
        }.disposed(by: disposeBag)
    }
    
    private func fetchLaunches(){
        tableView.refreshControl?.beginRefreshing()
        remoteLoader?.load(completion: { [weak self] result in
            switch result {
            case let .success(apiModel):
                self?.launchs.accept(apiModel.toViewModel())
            default:
                break
            }
            self?.tableView.refreshControl?.endRefreshing()
        })
    }
    
    @IBAction func filterBy(_ sender: Any) {
    }
    
}
