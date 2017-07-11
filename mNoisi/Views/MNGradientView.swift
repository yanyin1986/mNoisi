//
//  MNGradientView.swift
//  mNoisi
//
//  Created by yan on 2017/07/11.
//  Copyright © 2017 Leon.yan. All rights reserved.
//

import UIKit

@IBDesignable
class MNGradientView: UIView {

    @IBInspectable
    var startColor: UIColor = UIColor.black

    @IBInspectable
    var endColor: UIColor = UIColor.white

    open override class var layerClass: Swift.AnyClass {
        return CAGradientLayer.self
    }

    private var gradientLayer: CAGradientLayer {
        return self.layer as! CAGradientLayer
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        _commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func awakeFromNib() {
        _commonInit()
    }

    private func _commonInit() {
        self.gradientLayer.colors = [
            startColor.cgColor,
            endColor.cgColor,
        ]
    }
}
