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

    @IBOutlet weak var longestStreakLabel: UILabel!
    @IBOutlet
    weak var meditationImageView: UIImageView!
    @IBOutlet weak var meditationLabel: UILabel!

    @IBOutlet
    weak var breathImageView: UIImageView!
    @IBOutlet weak var sessionLabel: UILabel!

    var info: AllInfo? {
        didSet {
            guard let info = self.info else { return }

            self.longestStreakLabel.text = String.init(format: "%d Days", info.longestStreakCount)
            self.meditationLabel.text = self.stringFor(time: Int(info.meditationTime))
            self.sessionLabel.text = String.init(format: "%d", info.sessionCount)
        }
    }

    func stringFor(time: Int) -> String {
        let hour = time / 3600
        let min = time % 3600 / 60
        let seconds = time % 3600 % 60

        return String(format: "%02d:%02d:%02d", hour, min, seconds)
    }

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
