//
//  MNSoundTrackTableViewCell.swift
//  mNoisi
//
//  Created by Leon.yan on 18/05/2017.
//  Copyright © 2017 Leon.yan. All rights reserved.
//

import UIKit

class MNSoundTrackCollectionViewCell: UICollectionViewCell {

    static public let reuseIdentifier: String = "soundTrackCell"

    @IBOutlet weak var soundImageView: UIImageView!
    @IBOutlet weak var titleLabel: MNShadowLabel!
    @IBOutlet weak var isFavorite: UIImageView!
    @IBOutlet weak var isPlay: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.soundImageView.layer.cornerRadius = 6.0
        self.soundImageView.layer.masksToBounds = true
        self.backgroundColor = UIColor.clear
    }

}
