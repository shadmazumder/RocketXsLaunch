//
//  LaunchTableViewCell.swift
//  RocketXsLaunchiOS
//
//  Created by Shad Mazumder on 12/1/22.
//

import UIKit

class LaunchTableViewCell: UITableViewCell {
    static let ReuseableIdentifier = "LaunchTableViewCell"

    @IBOutlet weak var launchDetails: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var launchNumber: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var patchImageView: UIImageView!
}
