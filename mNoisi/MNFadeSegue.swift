//
//  MNFadeSegue.swift
//  mNoisi
//
//  Created by Leon.yan on 25/05/2017.
//  Copyright © 2017 Leon.yan. All rights reserved.
//

import UIKit

class MNFadeSegue: UIStoryboardSegue, UIViewControllerTransitioningDelegate {

    override func perform() {
//        self.destination.transitioningDelegate = self
        self.source.navigationController?.transitioningDelegate = self
        self.source.navigationController?.pushViewController(self.destination, animated: true)
//        super.perform()`
//        let fromView = self.source.view!
//        let toView = self.destination.view!
//        toView.frame = fromView.frame
//
//
//        toView.alpha = 0.0
//        fromView.superview?.insertSubview(toView, aboveSubview: fromView)
//
//        UIView.animate(withDuration: 0.3, animations: {
//            fromView.alpha = 0.0
//            toView.alpha = 1.0
//            toView.layoutIfNeeded()
//        }, completion: { (finish) in
//            fromView.removeFromSuperview()
//            print(toView)
//        })
    }

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return FadeTransitionAnimator()
    }
}

class FadeTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    private var duration: TimeInterval = 0.5
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.view(forKey: .from),
            let toView = transitionContext.view(forKey: .to) else {
                return
        }
        toView.frame = fromView.frame
        toView.alpha = 0.0
        transitionContext.containerView.addSubview(toView)
        
        UIView.animate(withDuration: duration, animations: {
            fromView.alpha = 0.0
            toView.alpha = 1.0
        }, completion: { (finished) in
            transitionContext.completeTransition(finished)
        })
    }
}
