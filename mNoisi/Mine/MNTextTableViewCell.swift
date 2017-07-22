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

    var titleLabel: UILabel!

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        titleLabel = UILabel()
        titleLabel.textColor = UIColor.white
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (m) in
            m.leading.equalTo(self.snp.leading).offset(30)
            m.centerY.equalTo(self.snp.centerY)
        }

        let imageView = UIImageView(image: UIImage(named: "arrow_right"))
        self.addSubview(imageView)
        imageView.snp.makeConstraints { (m) in
            m.trailing.equalTo(self.snp.trailing).offset(-30)
            m.centerY.equalTo(self.snp.centerY)
            m.width.equalTo(8)
            m.height.equalTo(13)
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
