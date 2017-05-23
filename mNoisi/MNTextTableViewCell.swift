//
//  MNTextTableViewCell.swift
//  mNoisi
//
//  Created by Leon.yan on 24/05/2017.
//  Copyright © 2017 Leon.yan. All rights reserved.
//

import UIKit

class MNTextTableViewCell: UITableViewCell {

    public static let reuseIdentifier: String = "textCell"

    @IBOutlet
    weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}