//
//  MNMeditationStartViewController.swift
//  mNoisi
//
//  Created by yanyin on 2017/07/15.
//  Copyright © 2017 Leon.yan. All rights reserved.
//

import UIKit

class MNMeditationStartViewController: MNBaseViewController, MNTimerDelegate {
    
    @IBOutlet weak var countDownView: MNCountDownView!
    @IBOutlet weak var countDownLabel: UILabel!
    @IBOutlet weak var tipLabel: UILabel!
    
    private var timer: MNTimer = MNTimer()
    private var countDown: Int = 3
    var minute: Int = 5
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let duration = 60.0 * TimeInterval(minute)
        let minVal = Int(duration / 60.0)
        let secondsVal = Int(duration - 60.0 * TimeInterval(minVal))
        
        countDownView.title = String(format: "%02d : %02d", minVal, secondsVal)
        self.perform(#selector(countDown(_:)), with: nil, afterDelay: 1.0)
        self.countDownAnimation()
    }
    
    dynamic func countDown(_ sender: Any) {
        self.countDown -= 1
        
        if self.countDown <= 0 {
            self.countDownLabel.isHidden = true
            let duration = 60.0 * TimeInterval(minute)
            // start animation
            timer.interval = 1.0 / 30.0
            timer.duration = duration
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
        let remainTime = timer.duration - time
        
        let minVal = Int(remainTime / 60.0)
        let secondsVal = Int(remainTime - 60.0 * TimeInterval(minVal))
        
        countDownView.title = String(format: "%02d : %02d", minVal, secondsVal)
        countDownView.progress = CGFloat(time.truncatingRemainder(dividingBy: 60.0) / 60.0)
    }
    
    func timerDidFinish(_ timer: MNTimer!) {
        self.finish(nil)
    }
    
}
