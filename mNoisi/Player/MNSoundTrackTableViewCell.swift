//
//  MNSoundTrackTableViewCell.swift
//  mNoisi
//
//  Created by Leon.yan on 18/05/2017.
//  Copyright © 2017 Leon.yan. All rights reserved.
//

import UIKit

class MNSoundTrackTableViewCell: UITableViewCell {

    
    @IBOutlet weak var soundImageView: UIImageView!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.soundImageView.layer.cornerRadius = 6.0
        self.soundImageView.layer.masksToBounds = true
        self.backgroundColor = UIColor.clear
        self.selectionStyle = UITableViewCellSelectionStyle.none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
