//
//  MNMeditationCountDownView.swift
//  mNoisi
//
//  Created by yan on 2017/07/11.
//  Copyright © 2017 Leon.yan. All rights reserved.
//

import UIKit

extension UIBezierPath {
    
    convenience init(arcCenter: CGPoint, radius: CGFloat, clockwise: Bool = true) {
        self.init(arcCenter: arcCenter, radius: radius, startAngle: CGFloat(-Double.pi / 2.0), endAngle: CGFloat(Double.pi / 2.0 * 3.0), clockwise: clockwise)
    }
}

class MNCountDownView: UIView {

    private var _timeLabel: UILabel = UILabel()
    private var _unspentTimeLayer: CAShapeLayer = CAShapeLayer()
    private var _spentTimeLayer: CAShapeLayer = CAShapeLayer()
    private var _bgTimeLayer: CAShapeLayer = CAShapeLayer()

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
        let borderWidth: CGFloat = 2.0
        let radius = (side - borderWidth) / 2.0

        let path: UIBezierPath = UIBezierPath(arcCenter: center, radius: radius)
        _bgTimeLayer.path = path.cgPath
        _bgTimeLayer.fillRule = kCAFillRuleNonZero
        _bgTimeLayer.fillColor = UIColor.clear.cgColor
        _bgTimeLayer.frame = self.bounds
        _bgTimeLayer.lineWidth = 1
        _bgTimeLayer.strokeColor = UIColor(white: 0.77, alpha: 1.0).cgColor
        
        let innerPath: UIBezierPath = UIBezierPath(arcCenter: center, radius: radius - 18)
        _unspentTimeLayer.path = innerPath.cgPath
        _unspentTimeLayer.fillRule = kCAFillRuleNonZero
        _unspentTimeLayer.fillColor = UIColor.clear.cgColor
        _unspentTimeLayer.frame = self.bounds
        _unspentTimeLayer.lineWidth = borderWidth
        _unspentTimeLayer.strokeColor = UIColor(white: 0.77, alpha: 1.0).cgColor

        _spentTimeLayer.path = innerPath.cgPath
        _spentTimeLayer.fillRule = kCAFillRuleNonZero
        _spentTimeLayer.fillColor = UIColor.clear.cgColor
        _spentTimeLayer.frame = self.bounds
        _spentTimeLayer.lineWidth = borderWidth
        _spentTimeLayer.strokeColor = UIColor(white: 0.9, alpha: 1.0).cgColor

        self.layer.addSublayer(_bgTimeLayer)
        self.layer.addSublayer(_unspentTimeLayer)
        self.layer.addSublayer(_spentTimeLayer)
        
        _timeLabel.font = UIFont.boldSystemFont(ofSize: 40)
        _timeLabel.text = ""
        _timeLabel.textAlignment = .center
        _timeLabel.textColor = UIColor(white: 0.9, alpha: 1.0)
        _timeLabel.frame = self.bounds
        self.addSubview(_timeLabel)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        _timeLabel.center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
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
    
    var title: String = "" {
        didSet {
            _timeLabel.text = title
            _timeLabel.center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
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
