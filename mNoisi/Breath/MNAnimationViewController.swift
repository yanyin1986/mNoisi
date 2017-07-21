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
        case hide
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
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var countDownLabel: UILabel!
    @IBOutlet weak var breathTipLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!

    private var _progress: ProgressStatus = .notStart {
        didSet {
            switch _progress {
            case .notStart:
                /* do nothing */
                break
            case .prepare:
                self.playButton.alpha = 0.0
                self.doneButton.alpha = 0.0
                self.playButton.isHidden = true
                self.doneButton.isHidden = true
                UIView.animate(withDuration: 0.75, animations: {
                    self.backButton.alpha = 0.0
                }, completion: { (finished) in
                    self.backButton.isHidden = true
                })
            case .hide:
                let buttons = [self.playButton, self.doneButton, self.backButton]
                buttons.forEach { $0?.isHidden = false }
                UIView.animate(withDuration: 0.75, animations: {
                    buttons.forEach { $0?.alpha = 0.0 }
                })
            case .show:
                let buttons = [self.playButton, self.doneButton, self.backButton]
                buttons.forEach {
                    $0?.alpha = 0.0
                    $0?.isHidden = false
                }
                UIView.animate(withDuration: 0.75, animations: {
                    buttons.forEach {
                        $0?.alpha = 1.0
                    }
                }, completion: { (finished) in

                })
            default:
                /* do nothing */
                break
            }
        }
    }

    var minute: Int = 5
    private var status: BreathStatus = .idle
    private var duration: TimeInterval = -1

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        duration = TimeInterval(minute) * 60.0
        self.timeLabel.text = self.timeText(duration)
    }

    func timeText(_ time: TimeInterval) -> String {
        let min = Int(time / 60.0)
        let seconds = Int(time - 60.0 * TimeInterval(min))
        return String(format: "%d : %02d", min, seconds)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if _progress == .notStart {
            _progress = .prepare

            self.timeLabel.isHidden = false
            self.timeLabel.alpha = 0.0
            UIView.animate(withDuration: 0.75, animations: {
                self.timeLabel.alpha = 1.0
            })

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
            timer.duration = duration
            timer.delegate = self
            timer.start()
            self.breathView.startAnimation()

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
        if _progress == .prepare || _progress == .hide {
            _progress = .show
        } else if _progress == .show {
            _progress = .hide
        }
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

        self.timeLabel.text = timeText(duration - time)
    }

    func timerDidFinish(_ timer: MNTimer!) {
        self.finish(nil)
    }

}
