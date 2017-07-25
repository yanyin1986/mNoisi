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

    var breathEvent: BreathEvent = BreathEvent()

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

    private var status: BreathStatus = .idle
    var duration: TimeInterval = -1

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
            self.perform(#selector(countDown(_:)), with: nil, afterDelay: 1.0)
            self.countDownAnimation()
        }
    }

    dynamic func countDown(_ sender: Any) {
        self.countDown -= 1

        if self.countDown <= 0 {
            self.countDownLabel.isHidden = true
            self.timeLabel.isHidden = false
            // start animation
            UIView.animate(withDuration: 0.75, animations: {
                self.timeLabel.alpha = 1.0
                self.backButton.alpha = 0.0
            }, completion: { (finished) in
                if finished {
                    self._progress = .hide
                    self.timer.interval = 1.0 / 30.0
                    self.timer.duration = self.duration
                    self.timer.delegate = self
                    self.timer.start()
                    self.breathEvent.start()
                    self.breathView.startAnimation()
                    self.playButton.isSelected = true
                }
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
    
    @IBAction func playButtonPressed(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            if _progress != .hide {
                _progress = .hide
            }
            
            if timer.isPaused {
                timer.resume()
            }
            
            breathView.resume()
        } else {
            if _progress != .show {
                _progress = .show
            }
            
            if !timer.isPaused {
                timer.pause()
            }
            breathView.pause()
        }
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        let time = timer.spentTime
        timer.stop()

        // end and insert breath events
        breathEvent.end(withDuration: time)
        EventsManager.shared.insert(breathEvent)

        // show results
        self.showResult(withTime: Int(time), duration: duration)
    }

    @IBAction func showButtons(_ sender: Any) {
        guard _progress == .hide || _progress == .show else { return }
        
        if _progress == .hide {
            _progress = .show
        } else if _progress == .show {
            _progress = .hide
        }
    }

    @IBAction func dismiss(_ sender: Any) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(countDown(_:)), object: nil)
        self.navigationController?.popViewController(animated: true)
    }

    private func showResult(withTime time: Int, duration: TimeInterval) {
        let resultViewController = MNBreathResultViewController()
        resultViewController.time = time
        resultViewController.duration = duration
        self.navigationController?.setViewControllers([resultViewController], animated: true)
    }

    func finish(_ sender: Any?) {
        self.showResult(withTime: Int(duration), duration: duration)
    }

    // MARK: MNTimerDelegate
    func timerDidTip(_ timer: MNTimer!) {
        let time = timer.spentTime
        let remainTime = time.truncatingRemainder(dividingBy: 12.0)

        if remainTime >= 0.0 && remainTime < 3.5 && status != .breathIn {
            status = .breathIn
            breathTipLabel.text = "Breath in ..."
            breathTipLabel.alpha = 0.0
            UIView.animate(withDuration: 0.3, animations: {
                self.breathTipLabel.alpha = 1.0
            }, completion: nil)
        } else if remainTime >= 3.5 && remainTime < 6.0 && status != .hold {
            status = .hold
            UIView.animate(withDuration: 0.3, animations: {
                self.breathTipLabel.alpha = 0.0
            }, completion: { (_) in
                self.breathTipLabel.text = "Hold..."
                UIView.animate(withDuration: 0.3, animations: {
                    self.breathTipLabel.alpha = 1.0
                }, completion: nil)
            })
        } else if remainTime >= 6.0 && remainTime < 9.5 && status != .breathOut {
            status = .breathOut
            UIView.animate(withDuration: 0.3, animations: {
                self.breathTipLabel.alpha = 0.0
            }, completion: { (_) in
                self.breathTipLabel.text = "Breath out..."
                UIView.animate(withDuration: 0.3, animations: {
                    self.breathTipLabel.alpha = 1.0
                }, completion: nil)
            })
        } else if remainTime >= 9.5 && status != .idle {
            status = .idle
            UIView.animate(withDuration: 0.3, animations: {
                self.breathTipLabel.alpha = 0.0
            }, completion: { (_) in
                self.breathTipLabel.text = ""
            })
        }

        self.timeLabel.text = timeText(duration - time)
    }

    func timerDidFinish(_ timer: MNTimer!) {
        // end and insert breath events
        breathEvent.end(withDuration: duration)
        EventsManager.shared.insert(breathEvent)

        // finish
        self.finish(nil)
    }

}
