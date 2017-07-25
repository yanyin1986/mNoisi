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
                                 title: "Breath",
                                 defaultTime: 1,
                                 lastTime: Defaults[.lastBreathTime]),
        BMType.meditation : Meta(imageName: "bg_meditation",
                                 title: "Meditation",
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
        tip2Label.text = String(format: "%d M", time)
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
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    // MARK: MNTimerViewControllerDelegate
    func timerViewController(_ viewController: MNTimerViewController!, didChooseTime time: Int) {
        self.time = time
        self.tip2Label.text = "\(time) M"
        
        if type == .breath {
            Defaults[.lastBreathTime] = time
        } else {
            Defaults[.lastMeditationTime] = time
        }
        Defaults.sync()
    }
}
