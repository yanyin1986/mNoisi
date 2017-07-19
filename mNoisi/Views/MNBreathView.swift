//
//  MNBreathView.swift
//  mNoisi
//
//  Created by yan on 2017/07/18.
//  Copyright © 2017 Leon.yan. All rights reserved.
//

import UIKit

class MNBreathView: UIView {
    private var _borderLayer: CAShapeLayer = CAShapeLayer()
    private var _maskLayer: CAShapeLayer = CAShapeLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self._commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func awakeFromNib() {
        _commonInit()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    private func _commonInit() {
        let radius = min(self.bounds.width, self.bounds.height) / 2.0
        let center = CGPoint(x: self.bounds.width / 2.0, y: self.bounds.height / 2.0)
        let path = UIBezierPath(arcCenter: center, radius: radius)
        path.append(UIBezierPath(arcCenter: center, radius: radius - 10.0).reversing())

        _borderLayer.frame = self.bounds
        _borderLayer.path = path.cgPath

        _maskLayer = CAShapeLayer()
        let maskPath = UIBezierPath(arcCenter: center, radius: radius - 8.0)
        _maskLayer.path = maskPath.cgPath
        _maskLayer.lineWidth = 1.0
        _maskLayer.fillRule = kCAFillRuleEvenOdd
        _maskLayer.strokeColor = UIColor.white.cgColor
        _maskLayer.fillColor = UIColor.white.cgColor


        _borderLayer.fillRule = kCAFillRuleEvenOdd
        _borderLayer.fillColor = UIColor.white.cgColor
        _borderLayer.mask = _maskLayer

        let shadow = UIBezierPath(arcCenter: center, radius: radius)
        shadow.append(UIBezierPath.init(arcCenter: center, radius: radius - 10.0).reversing())

        _borderLayer.shadowColor = UIColor.white.cgColor
        _borderLayer.shadowPath = shadow.cgPath
        _borderLayer.shadowOpacity = 0.0
        _borderLayer.shadowOffset = CGSize.zero
        _borderLayer.shadowRadius = 7.0
        
        self.layer.addSublayer(_borderLayer)
    }

    func startAnimation() {
        let anim1 = CAKeyframeAnimation(keyPath: "lineWidth")
        anim1.keyTimes = [0, 0.29167, 0.5, 0.79167, 1.0]
        anim1.values = [1.0, 50, 50, 1.0, 1.0]
        anim1.timingFunctions = [ CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn),
                                  CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear),
                                  CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut),
                                  CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear),]
        anim1.duration = 12.0
        anim1.repeatCount = 1000
        _maskLayer.add(anim1, forKey: "anim")

        let anim2 = CAKeyframeAnimation(keyPath: "transform.scale")
        anim2.keyTimes = [0, 0.29167, 0.5, 0.79167, 1.0]
        anim2.values = [1.0, 1.1, 1.1, 1.0, 1.0]
        anim2.timingFunctions = [ CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn),
                                  CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear),
                                  CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut),
                                  CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear),]
        anim2.duration = 12.0

        let anim3 = CAKeyframeAnimation(keyPath: "shadowOpacity")
        anim3.keyTimes = [0, 0.4, 0.5, 0.612, 1.0]
        anim3.values = [0.0, 0.65, 0.75, 0.0, 0.0]
        anim2.timingFunctions = [ CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear),
                                  CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn),
                                  CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut),
                                  CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear),]
        anim3.duration = 12.0

//        let anim4 = CABasicAnimation(keyPath: "strokeColor")
//        anim4.beginTime = 3.5
//        anim4.fromValue = UIColor.lightGray.cgColor
//        anim4.toValue = UIColor.white.cgColor
//        anim4.duration = 2.5
//        anim4.fillMode = kCAFillModeForwards
//
//        let anim5 = CABasicAnimation(keyPath: "strokeColor")
//        anim5.beginTime = 6.0
//        anim5.fromValue = UIColor.white.cgColor
//        anim5.toValue = UIColor.lightGray.cgColor
//        anim5.duration = 2.5
//        anim5.fillMode = kCAFillModeForwards

        let anim = CAAnimationGroup()
        anim.animations = [anim2, anim3]
        //, anim4, anim5]
        anim.duration = 12.0
        // TODO: fix repeat count
        anim.repeatCount = 100

        _borderLayer.add(anim, forKey: "anim")
    }

}
