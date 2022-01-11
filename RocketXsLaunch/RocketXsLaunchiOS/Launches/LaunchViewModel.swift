//
//  LaunchViewModel.swift
//  RocketXsLaunchiOS
//
//  Created by Shad Mazumder on 12/1/22.
//

import Foundation
import RocketXsLaunch

struct LaunchViewModel {
    let name: String
    let id: String
    let details: String?
    let date: Date?
    let imageUrl: URL?
    let rocketId: String
    let success: Bool?
    let upcoming: Bool
}

extension LaunchViewModel{
    init(_ apiModel: LaunchAPIModel) {
        name = apiModel.name
        id = apiModel.id
        details = apiModel.details
        date = apiModel.date
        imageUrl = apiModel.imageUrl
        rocketId = apiModel.rocketId
        success = apiModel.success
        upcoming = apiModel.upcoming
    }
}

extension LaunchViewModel{
    var nonFailure: Bool{
        guard let success = success else { return upcoming }
        return success || upcoming
    }
}

extension Array where Element == LaunchViewModel{
    func nonFailure() -> [LaunchViewModel]{
        filter({$0.nonFailure})
    }
    
    func filterByYear(_ year: DateComponents) -> [LaunchViewModel] {
        let validModels = filter({ $0.date != nil }).nonFailure()
        return validModels.filter({ Calendar.current.dateComponents([.year], from: $0.date!) == year })
    }
}

