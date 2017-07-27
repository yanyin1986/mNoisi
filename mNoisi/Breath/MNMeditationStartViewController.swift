//
//  MNMeditationStartViewController.swift
//  mNoisi
//
//  Created by yanyin on 2017/07/15.
//  Copyright © 2017 Leon.yan. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(hex: UInt, alpha: CGFloat = 1.0) {
        let red: CGFloat = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let green: CGFloat = CGFloat((hex & 0x00FF00) >> 8) / 255.0
        let blue: CGFloat = CGFloat(hex & 0x0000FF) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}

extension UIColor {
    struct Meditation {
        /// 0x614385 -> 0x516395
        static var gradientColors_1: [UIColor] { return [#colorLiteral(red: 0.3803921569, green: 0.262745098, blue: 0.5215686275, alpha: 1), #colorLiteral(red: 0.3176470588, green: 0.3882352941, blue: 0.5843137255, alpha: 1)] }
        /// 0x5F2C82 -> 0x49A09D
        static var gradientColors_2: [UIColor] { return [#colorLiteral(red: 0.3725490196, green: 0.1725490196, blue: 0.5098039216, alpha: 1), #colorLiteral(red: 0.2862745098, green: 0.6274509804, blue: 0.6156862745, alpha: 1)] }
        /// 0x4776E6 -> 0x8E54E9
        static var gradientColors_3: [UIColor] { return [#colorLiteral(red: 0.2784313725, green: 0.462745098, blue: 0.9019607843, alpha: 1), #colorLiteral(red: 0.5568627451, green: 0.3294117647, blue: 0.9137254902, alpha: 1)] }
        /// 0x7141e2 -> 0xd46cb3
        static var gradientColors_4: [UIColor] { return [#colorLiteral(red: 0.4431372549, green: 0.2549019608, blue: 0.8862745098, alpha: 1), #colorLiteral(red: 0.831372549, green: 0.4235294118, blue: 0.7019607843, alpha: 1)] }

        /// CGColors
        static var gradientCGColors_1 : [CGColor] { return gradientColors_1.map{ $0.cgColor } }
        static var gradientCGColors_2 : [CGColor] { return gradientColors_2.map{ $0.cgColor } }
        static var gradientCGColors_3 : [CGColor] { return gradientColors_3.map{ $0.cgColor } }
        static var gradientCGColors_4 : [CGColor] { return gradientColors_4.map{ $0.cgColor } }
    }
}

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
                    self.startGradientAnimation()
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

    func startGradientAnimation() {
        guard let gradientView = self.view as? MNGradientView else { return }

        let anim1 = CABasicAnimation(keyPath: "colors")
        anim1.fromValue = UIColor.Meditation.gradientCGColors_1
        anim1.toValue = UIColor.Meditation.gradientCGColors_2
        anim1.duration = 12
        anim1.beginTime = 0

        let anim2 = CABasicAnimation(keyPath: "colors")
        anim2.fromValue = UIColor.Meditation.gradientCGColors_2
        anim2.toValue = UIColor.Meditation.gradientCGColors_3
        anim2.duration = 12
        anim2.beginTime = 12.0

        let anim3 = CABasicAnimation(keyPath: "colors")
        anim3.fromValue = UIColor.Meditation.gradientCGColors_3
        anim3.toValue = UIColor.Meditation.gradientCGColors_4
        anim3.duration = 12
        anim3.beginTime = 24.0

        let anim4 = CABasicAnimation(keyPath: "colors")
        anim4.fromValue = UIColor.Meditation.gradientCGColors_4
        anim4.toValue = UIColor.Meditation.gradientCGColors_1
        anim4.duration = 12
        anim4.beginTime = 36.0

        let anim = CAAnimationGroup()
        anim.animations = [anim1, anim2, anim3, anim4]
        anim.repeatCount = 9999
        anim.duration = 48.0
        
        gradientView.gradientLayer.add(anim, forKey: "anim")
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

        if let count = self.navigationController?.viewControllers.count, count > 1 {
            self.navigationController?.popViewController(animated: true)
        } else {
            self.navigationController?.dismiss(animated: true, completion: nil)
        }
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
