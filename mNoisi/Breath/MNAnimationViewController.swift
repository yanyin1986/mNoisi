//
//  MNAnimationViewController.swift
//  mNoisi
//
//  Created by Leon.yan on 25/05/2017.
//  Copyright © 2017 Leon.yan. All rights reserved.
//

import UIKit

class MNAnimationViewController: MNBaseViewController, MNTimerDelegate {

    @IBOutlet weak var countDownView: MNCountDownView!
    var timer: MNTimer = MNTimer()
    var countDown: Int = 3
    @IBOutlet weak var countDownLabel: UILabel!
    @IBOutlet weak var breathTipLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.perform(#selector(countDown(_:)), with: nil, afterDelay: 1.0)
        self.countDownAnimation()
    }

    dynamic func countDown(_ sender: Any) {
        self.countDown -= 1

        if self.countDown <= 0 {
            self.countDownLabel.isHidden = true
            // start animation
            timer.interval = 1.0 / 30.0
            timer.duration = 60.0
            timer.delegate = self
            timer.start()
        } else {
            countDownLabel.text = String(self.countDown)
            self.countDownAnimation()
            self.perform(#selector(countDown(_:)), with: nil, afterDelay: 1.0)
        }
    }

    func countDownAnimation() {
        countDownLabel.transform = CGAffineTransform.identity
        UIView.animate(withDuration: 0.95) {
            self.countDownLabel.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func dismiss(_ sender: Any) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(countDown(_:)), object: nil)
        self.navigationController?.popViewController(animated: true)
    }

    func finish(_ sender: Any?) {
        let resultViewController = MNBreathResultViewController()
        self.navigationController?.setViewControllers([resultViewController], animated: true)
    }

    // MARK: MNTimerDelegate
    func timerDidTip(_ timer: MNTimer!) {
        let time = timer.spentTime
        countDownView.progress = CGFloat(time / 60.0)
    }

    func timerDidFinish(_ timer: MNTimer!) {
        self.finish(nil)
    }

}
