//
//  MNSwitchTableViewCell.swift
//  mNoisi
//
//  Created by Leon.yan on 24/05/2017.
//  Copyright © 2017 Leon.yan. All rights reserved.
//

import UIKit
import SnapKit

class MNSwitchTableViewCell: UITableViewCell {

    public static let reuseIdentifier: String = "switchCell"

    var `switch`: UISwitch!

    var titleLabel: UILabel!

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        titleLabel = UILabel(frame: CGRect.zero)
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.textColor = UIColor.white
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (m) in
            m.leading.equalTo(self.snp.leading).offset(30)
            m.centerY.equalTo(self.snp.centerY)
        }

        `switch` = UISwitch()
        self.addSubview(`switch`)
        `switch`.snp.makeConstraints { (m) in
            m.trailing.equalTo(self.snp.trailing).offset(-8)
            m.centerY.equalTo(self.snp.centerY)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("not implement")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
