//
//  LaunchMapperTests.swift
//  RocketXsLaunchTests
//
//  Created by Shad Mazumder on 10/1/22.
//

import XCTest
import RocketXsLaunch

struct Patch: Decodable{
    let small: String
}

struct Links: Decodable{
    let patch: Patch
}

struct LaunchAPIModel: Decodable {
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
    
    public let name: String
    public let id: String
    public let details: String
    public let dateString: String
    public let links: Links
    public let rocketId: String
    public let success: Bool?
    public let upcoming: Bool
    
    public var imageUrl: URL?{ URL(string: links.patch.small) }
    public var date: Date? { ISO8601DateFormatter().date(from: dateString) }
}

class LaunchMapperTests: XCTestCase {
    func test_jsonDataMapsLaunchAPIModel() {
        let sut = makeSUT()
        
        let client = HTTPClientSpy()
        let loader = RemoteLoader<LaunchAPIModel>(url: URL(string: "any-url")!, client: client)
        
        let exp = expectation(description: "Waiting for the client")

        loader.load { result in
            switch (result) {
            case let .success(recieved):
                XCTAssertEqual(recieved, sut.model)
            default:
                XCTFail("Expected \(sut.model) but got \(result)")
            }
            exp.fulfill()
        }
        
        client.completeWith(sut.data)

        wait(for: [exp], timeout: 1.0)
    }
    
    private func makeSUT() -> (model: LaunchAPIModel, data: Data){
        (launchApiModel, launchApiModelJson)
    }
    
    private let launchApiModel = LaunchAPIModel(name: "Any name",
                                                id: UUID().uuidString,
                                                details: "Some details",
                                                dateString: ISO8601DateFormatter().string(from: Date()),
                                                links: Links(patch: Patch(small: "any-string")),
                                                rocketId: UUID().uuidString,
                                                success: true,
                                                upcoming: false)
    
    private var launchApiModelJson: Data{
        """
        {
            "fairings": {
                "reused": false,
                "recovery_attempt": false,
                "recovered": false,
                "ships": []
            },
            "links": {
                "patch": {
                    "small": "\(launchApiModel.links.patch.small)",
                    "large": "https://images2.imgbox.com/40/e3/GypSkayF_o.png"
                },
                "reddit": {
                    "campaign": null,
                    "launch": null,
                    "media": null,
                    "recovery": null
                },
                "flickr": {
                    "small": [],
                    "original": []
                },
                "presskit": null,
                "webcast": "https://www.youtube.com/watch?v=0a_00nJ_Y88",
                "youtube_id": "0a_00nJ_Y88",
                "article": "https://www.space.com/2196-spacex-inaugural-falcon-1-rocket-lost-launch.html",
                "wikipedia": "https://en.wikipedia.org/wiki/DemoSat"
            },
            "static_fire_date_utc": "2006-03-17T00:00:00.000Z",
            "static_fire_date_unix": 1142553600,
            "net": false,
            "window": 0,
            "rocket": "\(launchApiModel.rocketId)",
            "success": \(launchApiModel.success!),
            "failures": [{
                "time": 33,
                "altitude": null,
                "reason": "merlin engine failure"
            }],
            "details": "\(launchApiModel.details)",
            "crew": [],
            "ships": [],
            "capsules": [],
            "payloads": [
                "5eb0e4b5b6c3bb0006eeb1e1"
            ],
            "launchpad": "5e9e4502f5090995de566f86",
            "flight_number": 1,
            "name": "\(launchApiModel.name)",
            "date_utc": "\(launchApiModel.dateString)",
            "date_unix": 1143239400,
            "date_local": "2006-03-25T10:30:00+12:00",
            "date_precision": "hour",
            "upcoming": \(launchApiModel.upcoming),
            "cores": [{
                "core": "5e9e289df35918033d3b2623",
                "flight": 1,
                "gridfins": false,
                "legs": false,
                "reused": false,
                "landing_attempt": false,
                "landing_success": null,
                "landing_type": null,
                "landpad": null
            }],
            "auto_update": true,
            "tbd": false,
            "launch_library_id": null,
            "id": "\(launchApiModel.id)"
        }
        """.data(using: .utf8)!
    }
}

extension LaunchAPIModel: Equatable{
    static func == (lhs: LaunchAPIModel, rhs: LaunchAPIModel) -> Bool {
        lhs.id == rhs.id
    }
}
