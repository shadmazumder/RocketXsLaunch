//
//  LaunchesViewController.swift
//  Prototype
//
//  Created by Shad Mazumder on 11/1/22.
//

import UIKit
import Alamofire
import RxSwift
import RxCocoa
import Kingfisher

class LaunchesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentController: UISegmentedControl!
    
    let disposeBag = DisposeBag()
    let launchs: BehaviorRelay<[LaunchAPIModel]> = BehaviorRelay(value: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchLaunches()
        configureTableView()
    }
    
    private func configureTableView(){
        launchs.bind(to: tableView.rx.items(cellIdentifier: "LaunchCell", cellType: LaunchCellTableViewCell.self)){ row, model, cell in
            cell.name.text = model.name
            if let imageUrl = model.imageUrl{
                cell.launchImageView.kf.setImage(with: imageUrl)
            }
            
        }.disposed(by: disposeBag)
    }
    
    private func fetchLaunches(){
        AF.request("https://api.spacexdata.com/v4/launches").response { response in
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let launchApiModel =  try decoder.decode([LaunchAPIModel].self, from: response.data!)
                self.launchs.accept(launchApiModel)
            } catch  {
                print(error)
            }
        }
    }
    
    @IBAction func filterLaunches(_ sender: UISegmentedControl) {
    }
    
    override func showDetailViewController(_ vc: UIViewController, sender: Any?) {
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

public struct LaunchAPIModel {
    public let name: String
    public let id: String
    public let details: String?
    public let dateString: String
    public let links: Links?
    public let rocketId: String
    public let success: Bool?
    public let upcoming: Bool
    
    public var imageUrl: URL?{
        guard let urlString = links?.patch?.small, let url = URL(string: urlString) else { return nil }
        return url
    }
    public var date: Date? { ISO8601DateFormatter().date(from: dateString) }
    
    public init(name: String, id: String, details: String, dateString: String, links: Links, rocketId: String, success: Bool?, upcoming: Bool){
        self.name = name
        self.id = id
        self.details = details
        self.dateString = dateString
        self.links = links
        self.rocketId = rocketId
        self.success = success
        self.upcoming = upcoming
    }
}

extension LaunchAPIModel: Decodable{
    enum CodingKeys: String, CodingKey{
        case name
        case id
        case details
        case dateString = "dateUtc"
        case links
        case rocketId = "rocket"
        case success
        case upcoming
    }
}

public struct Patch: Decodable{
    public let small: String?
    
    public init(small: String){
        self.small = small
    }
}

public struct Links: Decodable{
    public let patch: Patch?
    
    public init(patch: Patch) {
        self.patch = patch
    }
}


public struct Launch {
    public let name: String
    public let id: String
    public let details: String
    public let date: Date
    public let imageUrl: URL?
    public let rocketId: String
    public let success: Bool?
    public let upcoming: Bool
    
    public init(name: String, id: String, details: String, date: Date, imageUrl: URL?, rocketId: String, success: Bool?, upcoming: Bool) {
        self.name = name
        self.id = id
        self.details = details
        self.date = date
        self.imageUrl = imageUrl
        self.rocketId = rocketId
        self.success = success
        self.upcoming = upcoming
    }
}

extension Launch{
    public var nonFailure: Bool{
        guard let success = success else { return upcoming }
        return success || upcoming
    }
}

extension Array where Element == Launch{
    public func nonFailure() -> [Launch]{
        filter({$0.nonFailure})
    }
    
    public func filterByYear(_ year: DateComponents) -> [Launch] {
        nonFailure().filter({ Calendar.current.dateComponents([.year], from: $0.date) == year })
    }
}

