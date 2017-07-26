//
//  MNBreathViewController.swift
//  mNoisi
//
//  Created by Leon.yan on 25/05/2017.
//  Copyright © 2017 Leon.yan. All rights reserved.
//

import UIKit

class MNBreathViewController: MNBaseViewController, MNTimerViewControllerDelegate {

    var type: BMType = .breath
    var time: Int = 1
    
    private struct Meta {
        var imageName: String
        var title: String
        var defaultTime: Int
        var lastTime: Int?
    }
    
    @IBOutlet
    private weak var imageView: UIImageView!
    
    @IBOutlet
    private weak var titleLabel: UILabel!
    
    @IBOutlet
    private weak var tip1Label: UILabel!
    
    @IBOutlet
    private weak var tip2Label: UILabel!
    
    private let metas: [BMType: Meta] = [
        BMType.breath     : Meta(imageName: "bg_breath",
                                 title: NSLocalizedString("Breath", comment: ""),
                                 defaultTime: 1,
                                 lastTime: Defaults[.lastBreathTime]),
        BMType.meditation : Meta(imageName: "bg_meditation",
                                 title: NSLocalizedString("Meditation", comment: ""),
                                 defaultTime: 5,
                                 lastTime: Defaults[.lastMeditationTime]),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let meta = metas[type] else {
            fatalError("error with type for MNBreathViewController")
        }
        imageView.image = UIImage(named: meta.imageName)
        titleLabel.text = meta.title
        
        if let lastTime = meta.lastTime {
            time = lastTime
        } else {
            time = meta.defaultTime
        }

        let components = Calendar(identifier: .gregorian).dateComponents(in: TimeZone.current, from: Date())
        let today = components.year! * 10000 + components.month! * 100 + components.day!
        if type == .breath {
            if let lastBreathEvent = EventsManager.shared.lastBreathEvent() {
                // breath duration
                let breathDuration = EventsManager.shared.breathDuration(forDay: today)
                /// today times
                tip1Label.text = todayDescription(forDuration: breathDuration)
                /// last time
                tip2Label.text = description(forLastTime: lastBreathEvent.startTime)
            } else {
                tip1Label.text = NSLocalizedString("Take Deep Breath", comment: "")
                tip2Label.text = String(format: NSLocalizedString("%d min", comment: ""), time)
            }
        } else {
            // .meditation
            if let lastMeditationEvent = EventsManager.shared.lastMeditationEvent() {
                let meditationDuration = EventsManager.shared.meditationDuration(forDay: today)
                /// today duration
                tip1Label.text = todayDescription(forDuration: meditationDuration)
                /// last time
                tip2Label.text = description(forLastTime: lastMeditationEvent.startTime)
            } else {
                tip1Label.text = NSLocalizedString("Meditation", comment: "")
                tip2Label.text = String(format: NSLocalizedString("%d min", comment: ""), time)
            }
        }
    }

    func todayDescription(forDuration duration: TimeInterval) -> String {
        if duration < 60 {
            return String(format: NSLocalizedString("Today %d seconds", comment: ""), Int(max(0, duration)))
        } else if duration < 3600 {
            return String(format: NSLocalizedString("Today %d minutes", comment: ""), Int(duration/60.0))
        } else if duration < 86400 {
            return String(format: NSLocalizedString("Today %d hours", comment: ""), Int(duration/3600.0))
        } else {
            return ""
        }
    }

    func description(forLastTime lastTime: TimeInterval) -> String {
        let diff = Date().timeIntervalSince1970 - lastTime
        if diff < 60 {
            return String(format: NSLocalizedString("Last time %d seconds ago", comment: ""), Int(max(0, diff)))
        } else if diff < 3600 {
            return String(format: NSLocalizedString("Last time %d minutes ago", comment: ""), Int(diff / 60))
        } else if diff < 86400 {
            return String(format: NSLocalizedString("Last time %d hours ago", comment: ""), Int(diff / 3600))
        } else if diff < 604800 {
            return String(format: NSLocalizedString("Last time %d days ago", comment: ""), Int(diff / 86400))
        } else {
            return String(format: NSLocalizedString("Last time %d weeks ago", comment: ""), Int(diff / 604800))
        }
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
        if type == .breath {
            timerViewController.times = [1, 2, 3, 4, 5, 6, 7, 8, 9]
        } else {
            timerViewController.times = [5, 10, 15, 20, 25, 30]
        }
        
        timerViewController.currentTime = NSNumber(value: self.time)
        timerViewController.delegate = self
        self.navigationController?.pushViewController(timerViewController, animated: true)
    }

    @IBAction
    func startBreath(_ sender: Any) {
        if type == .breath {
            let animationViewController = MNAnimationViewController()
            animationViewController.duration = 60.0 * TimeInterval(time)
            self.navigationController?.pushViewController(animationViewController, animated: true)
        } else {
            let vc = MNMeditationStartViewController()
            vc.duration = 60.0 * TimeInterval(time)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    // MARK: MNTimerViewControllerDelegate
    func timerViewController(_ viewController: MNTimerViewController!, didChooseTime time: Int) {
        self.time = time
        self.tip2Label.text = String(format: NSLocalizedString("%d min", comment: ""), time)

        if type == .breath {
            Defaults[.lastBreathTime] = time
        } else {
            Defaults[.lastMeditationTime] = time
        }
        Defaults.sync()
    }
}
