//
//  MNMeditationStartViewController.swift
//  mNoisi
//
//  Created by yanyin on 2017/07/15.
//  Copyright © 2017 Leon.yan. All rights reserved.
//

import UIKit

class MNMeditationStartViewController: MNBaseViewController, MNTimerDelegate {

    enum ProgressStatus {
        case notStart
        case prepare
        case hide
        case show
        case finish
    }
    
    @IBOutlet weak var countDownView: MNCountDownView!
    @IBOutlet weak var countDownLabel: UILabel!
    @IBOutlet weak var tipLabel: UILabel!
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var playButton: MNRadiusButton!
    @IBOutlet weak var doneButton: UIButton!
    private var timer: MNTimer = MNTimer()
    private var countDown: Int = 3
    var duration: TimeInterval = -1
    var meditationEvent: MeditationEvent = MeditationEvent()

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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let minVal = Int(duration / 60.0)
        let secondsVal = Int(duration - 60.0 * TimeInterval(minVal))
        countDownView.title = String(format: "%02d : %02d", minVal, secondsVal)
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
            UIView.animate(withDuration: 0.75, animations: {
                self.backButton.alpha = 0.0
            }, completion: { (finished) in
                if finished {
                    self._progress = .hide
                    self.timer.interval = 1.0 / 30.0
                    self.timer.duration = self.duration
                    self.timer.delegate = self
                    self.timer.start()
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

        } else {
            if _progress != .show {
                _progress = .show
            }

            if !timer.isPaused {
                timer.pause()
            }
        }
    }

    @IBAction func doneButtonPressed(_ sender: Any) {
        let time = timer.spentTime
        timer.stop()

        // end and insert breath events
        meditationEvent.end(withDuration: time)
        EventsManager.shared.insert(meditationEvent)

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
        resultViewController.type = .meditation
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
        let remainTime = timer.duration - time
        
        let minVal = Int(remainTime / 60.0)
        let secondsVal = Int(remainTime - 60.0 * TimeInterval(minVal))
        
        countDownView.title = String(format: "%02d : %02d", minVal, secondsVal)
        countDownView.progress = CGFloat(time.truncatingRemainder(dividingBy: 60.0) / 60.0)
    }
    
    func timerDidFinish(_ timer: MNTimer!) {
        meditationEvent.end(withDuration: duration)
        EventsManager.shared.insert(meditationEvent)
        self.finish(nil)
    }
    
}
