//
//  MNButton.swift
//  mNoisi
//
//  Created by Leon.yan on 29/05/2017.
//  Copyright © 2017 Leon.yan. All rights reserved.
//

import UIKit

@IBDesignable
class MNButton: UIButton {

    @IBInspectable
    var spacing: CGFloat = 0 {
        didSet {
            self.setNeedsDisplay()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let imageSize = self.imageView?.frame.size ?? CGSize.zero
        self.titleEdgeInsets = UIEdgeInsetsMake(0.0, -imageSize.width, -(imageSize.height + spacing), 0.0)
        let titleSize = self.titleLabel?.frame.size ?? CGSize.zero
        self.imageEdgeInsets = UIEdgeInsetsMake(-(titleSize.height + spacing), 0, 0, -titleSize.width)
    }

}
