//
//  MNMeditationCountDownView.swift
//  mNoisi
//
//  Created by yan on 2017/07/11.
//  Copyright © 2017 Leon.yan. All rights reserved.
//

import UIKit

class MNCountDownView: UIView {

    var _unspentTimeLayer: CAShapeLayer = CAShapeLayer()
    var _spentTimeLayer: CAShapeLayer = CAShapeLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        _commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _commonInit()
    }

    private func _commonInit() {
        let side = min(self.bounds.size.width, self.bounds.size.height)
        let center = CGPoint(x: self.bounds.width / 2.0, y: self.bounds.height / 2.0)
        print(center)
        let borderWidth: CGFloat = 2.0
        let radius = (side - borderWidth) / 2.0
        print(radius)

        let path: UIBezierPath = UIBezierPath.init(arcCenter: center, radius: radius, startAngle: CGFloat(-Double.pi / 2.0), endAngle: CGFloat(Double.pi / 2.0 * 3.0), clockwise: true)
        print(path)
        _unspentTimeLayer.path = path.cgPath
        _unspentTimeLayer.fillRule = kCAFillRuleNonZero
        _unspentTimeLayer.fillColor = UIColor.clear.cgColor
        _unspentTimeLayer.frame = self.bounds
        _unspentTimeLayer.lineWidth = borderWidth
        _unspentTimeLayer.strokeColor = UIColor(white: 0.77, alpha: 1.0).cgColor

        _spentTimeLayer.path = path.cgPath
        _spentTimeLayer.fillRule = kCAFillRuleNonZero
        _spentTimeLayer.fillColor = UIColor.clear.cgColor
        _spentTimeLayer.frame = self.bounds
        _spentTimeLayer.lineWidth = borderWidth
        _spentTimeLayer.strokeColor = UIColor(white: 0.9, alpha: 1.0).cgColor

        self.layer.addSublayer(_unspentTimeLayer)
        self.layer.addSublayer(_spentTimeLayer)
    }

    var progress: CGFloat = 0.0 {
        didSet {
            CATransaction.begin()
            CATransaction.setAnimationDuration(0.0)
            _unspentTimeLayer.strokeStart = progress // 0.75
            _unspentTimeLayer.strokeEnd = 0.99
            _spentTimeLayer.strokeEnd = progress - 0.01
            _spentTimeLayer.strokeStart = 0.00
            CATransaction.commit()
        }
    }

    func start() {
        CATransaction.begin()
        CATransaction.setAnimationDuration(5.0)
        _unspentTimeLayer.strokeStart = 0.75
        _unspentTimeLayer.strokeEnd = 0.99
        _spentTimeLayer.strokeEnd = 0.74
        _spentTimeLayer.strokeStart = 0.00
        CATransaction.commit()
    }
}
