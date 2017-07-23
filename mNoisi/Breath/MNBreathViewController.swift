//
//  MNBreathViewController.swift
//  mNoisi
//
//  Created by Leon.yan on 25/05/2017.
//  Copyright © 2017 Leon.yan. All rights reserved.
//

import UIKit

class MNBreathViewController: _BaseViewController, MNTimerViewControllerDelegate {

    @IBOutlet weak var tip1Label: UILabel!
    @IBOutlet weak var tip2Label: UILabel!
    var time: Int = 1

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction
    func dismiss(_ sender: Any) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }

    @IBAction
    func timerButtonPressed(_ sender: Any) {
        let timerViewController = MNTimerViewController()
        timerViewController.times = [1, 2, 3, 4, 5, 6, 7, 8, 9]
        timerViewController.currentTime = NSNumber(value: self.time)
        timerViewController.delegate = self
        self.navigationController?.pushViewController(timerViewController, animated: true)
    }

    @IBAction
    func startBreath(_ sender: Any) {
        let animationViewController = MNAnimationViewController()
        animationViewController.duration = 60.0 * TimeInterval(time)
        self.navigationController?.pushViewController(animationViewController, animated: true)
    }

    // MARK: MNTimerViewControllerDelegate
    func timerViewController(_ viewController: MNTimerViewController!, didChooseTime time: Int) {
        self.time = time
        self.tip2Label.text = "\(time) min"
    }
}
