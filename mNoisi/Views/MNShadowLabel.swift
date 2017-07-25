//
//  MNShadowLabel.swift
//  mNoisi
//
//  Created by yan on 2017/07/11.
//  Copyright © 2017 Leon.yan. All rights reserved.
//

import UIKit

@IBDesignable
class MNShadowLabel: UILabel {

    @IBInspectable
    var textShadowRadius: CGFloat = 2.0 {
        didSet {
            layer.shadowRadius = textShadowRadius
            self.setNeedsDisplay()
        }
    }

    @IBInspectable
    var textShadowColor: UIColor? {
        didSet {
            layer.shadowColor = textShadowColor?.cgColor
            self.setNeedsDisplay()
        }
    }

    @IBInspectable
    var textShadowOffset: CGSize = CGSize(width: 0, height: 2) {
        didSet {
            layer.shadowOffset = textShadowOffset
            self.setNeedsDisplay()
        }
    }

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
        layer.shadowOpacity = 1.0
        layer.shadowRadius = textShadowRadius
        layer.shadowColor = textShadowColor?.cgColor
        layer.shadowOffset = textShadowOffset
    }
}
