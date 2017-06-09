//
//  MNStaticsInfoTableViewCell.swift
//  mNoisi
//
//  Created by Leon.yan on 20/05/2017.
//  Copyright © 2017 Leon.yan. All rights reserved.
//

import UIKit

class MNStaticsInfoTableViewCell: UITableViewCell {

    public static let reuseIdentifier: String = "staticsInfoCell"

    @IBOutlet
    weak var natrualSoundImageView: UIImageView!

    @IBOutlet
    weak var meditationImageView: UIImageView!

    @IBOutlet
    weak var breathImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        natrualSoundImageView.image = UIImage(named: "natrual sound")?.withRenderingMode(.alwaysTemplate)
        meditationImageView.image = UIImage(named: "meditation")?.withRenderingMode(.alwaysTemplate)
        breathImageView.image = UIImage(named: "breath")?.withRenderingMode(.alwaysTemplate)
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
