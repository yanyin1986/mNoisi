//
//  MNTrackCollectionViewCell.swift
//  mNoisi
//
//  Created by Leon.yan on 21/05/2017.
//  Copyright © 2017 Leon.yan. All rights reserved.
//

import UIKit
import SnapKit

class MNTrackCollectionViewCell: UICollectionViewCell {
    var imageView: UIImageView!

    override init(frame: CGRect) {
        super.init(frame: frame)

        imageView = UIImageView(frame: self.bounds)
        imageView.contentMode = .scaleAspectFill
        self.contentView.addSubview(imageView)
        imageView.snp.makeConstraints { (m) in
            m.edges.equalTo(self.contentView.snp.edges)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("not implement")
    }
}
