//
//  MNShadowButton.swift
//  mNoisi
//
//  Created by yan on 2017/07/11.
//  Copyright © 2017 Leon.yan. All rights reserved.
//

import UIKit

class MNShadowButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        _commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        _commonInit()
    }

    private func _commonInit() {
        layer.shadowOpacity = 0.75
        layer.shadowRadius = 2.0
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize.init(width: 0, height: 2)

        if let image = self.image(for: .selected) {
            self.setImage(image, for: [.selected, .highlighted])
        }
    }
}
