//
//  MNAnimationViewController.swift
//  mNoisi
//
//  Created by Leon.yan on 25/05/2017.
//  Copyright © 2017 Leon.yan. All rights reserved.
//

import UIKit

class MNAnimationViewController: MNBaseViewController, MNTimerDelegate {

    enum ProgressStatus {
        case notStart
        case prepare
        case hiding
        case hide
        case showing
        case show
        case finish
    }

    enum BreathStatus: Int {
        case idle      = 0
        case breathIn  = 1
        case hold      = 2
        case breathOut = 3
    }
    
    @IBOutlet weak var breathView: MNBreathView!
    var timer: MNTimer = MNTimer()
    var countDown: Int = 3
    @IBOutlet weak var countDownLabel: UILabel!
    @IBOutlet weak var breathTipLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!

    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!

    private var _progress: ProgressStatus = .notStart

    var minute: Int = 5
    private var status: BreathStatus = .idle

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if _progress == .notStart {
            _progress = .prepare
            self.perform(#selector(countDown(_:)), with: nil, afterDelay: 1.0)
            self.countDownAnimation()
        }
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
            self.breathView.startAnimation()

            // hide backbutton,
            //
            UIView.animate(withDuration: 0.3, animations: { 
                self.backButton.alpha = 0.0
            })
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
    
    @IBAction func showButtons(_ sender: Any) {
        
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
        let remainTime = time.truncatingRemainder(dividingBy: 12.0)

        if remainTime >= 0.0 && remainTime < 3.5 && status != .breathIn {
            status = .breathIn
            breathTipLabel.text = "Breath in ..."
        } else if remainTime >= 3.5 && remainTime < 6.0 && status != .hold {
            status = .hold
            breathTipLabel.text = "Hold..."
        } else if remainTime >= 6.0 && remainTime < 9.5 && status != .breathOut {
            status = .breathOut
            breathTipLabel.text = "Breath out..."
        } else if remainTime >= 9.5 && status != .idle {
            status = .idle
            breathTipLabel.text = "Relax"
        }
    }

    func timerDidFinish(_ timer: MNTimer!) {
        self.finish(nil)
    }

}
