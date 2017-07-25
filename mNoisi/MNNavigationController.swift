//
//  MNNavigationController.swift
//  mNoisi
//
//  Created by yan on 2017/07/07.
//  Copyright © 2017 Leon.yan. All rights reserved.
//

import UIKit

class FadeAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    private var _duration: TimeInterval = 0.5

    // This is used for percent driven interactive transitions, as well as for
    // container controllers that have companion animations that might need to
    // synchronize with the main animation.
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return _duration
    }

    // This method can only  be a nop if the transition is interactive and not a percentDriven interactive transition.
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.view(forKey: .from),
            let toView = transitionContext.view(forKey: .to) else {
                return
        }
        fromView.frame = transitionContext.containerView.bounds
        toView.frame = transitionContext.containerView.bounds

        transitionContext.containerView.addSubview(fromView)
        transitionContext.containerView.addSubview(toView)

        fromView.alpha = 1.0
        toView.alpha = 0.0

        UIView.animate(withDuration: _duration, animations: {
            fromView.alpha = 0.0
            toView.alpha = 1.0
        }, completion: { (finish) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }

    // This is a convenience and if implemented will be invoked by the system when the transition context's completeTransition: method is invoked.
    public func animationEnded(_ transitionCompleted: Bool) {

    }

}

class MNNavigationController: UINavigationController, UINavigationControllerDelegate {

    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        self.delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationControllerOperation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return FadeAnimator()
    }
}
