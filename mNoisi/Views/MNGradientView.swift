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
    var startColor: UIColor = UIColor.black {
        didSet {
            _commonInit()
        }
    }

    @IBInspectable
    var centerColor: UIColor? {
        didSet {
            _commonInit()
        }
    }

    @IBInspectable
    var endColor: UIColor = UIColor.white {
        didSet {
            _commonInit()
        }
    }

    @IBInspectable
    var startPoint: CGPoint = CGPoint(x: 0.5, y: 0) {
        didSet {
            _commonInit()
        }
    }

    @IBInspectable
    var endPoint: CGPoint = CGPoint(x: 0.5, y: 1.0) {
        didSet {
            _commonInit()
        }
    }

    @IBInspectable
    var cornerRadius: CGFloat = 0 {
        didSet {
            if cornerRadius > 0 {
                self.layer.masksToBounds = true
                self.layer.cornerRadius = cornerRadius
                self.layer.edgeAntialiasingMask = [.layerTopEdge, .layerLeftEdge, .layerBottomEdge, .layerRightEdge]
            } else {
                self.layer.masksToBounds = false
                self.layer.cornerRadius = 0
            }
        }
    }

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
        self.gradientLayer.startPoint = self.startPoint
        self.gradientLayer.endPoint = self.endPoint
        if let centerColor = self.centerColor {
            self.gradientLayer.colors = [
                startColor.cgColor,
                centerColor.cgColor,
                endColor.cgColor,
            ]
        } else {
            self.gradientLayer.colors = [
                startColor.cgColor,
                endColor.cgColor,
            ]
        }
    }
}
