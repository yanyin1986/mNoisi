//
//  MNBreathResultViewController.swift
//  mNoisi
//
//  Created by yan on 2017/07/12.
//  Copyright © 2017 Leon.yan. All rights reserved.
//

import UIKit
import AVFoundation

class MNBreathResultViewController: MNBaseViewController {

    /// seconds
    var time: Int = 0
    var duration: TimeInterval = -1
    var type: BMType = .breath
    
    @IBOutlet weak var againButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var completeLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var doneImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if type == .breath {
            // .breath
            completeLabel.text = "Breath Completed"
        } else {
            // .meditation
            completeLabel.text = "Meditation Completed"
        }
        timeLabel.text = timeText(time)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if let url = Bundle.main.url(forResource: "meditation_finish", withExtension: "mp3") {
                let audioPlayer = try? AVAudioPlayer(contentsOf: url)
                audioPlayer?.play()
            }

            self.doneImageView.alpha = 0.0
            self.doneImageView.isHidden = false
            UIView.animate(withDuration: 1.0, animations: {
                self.doneImageView.alpha = 1.0
            }, completion: { (_) in
                self.completeLabel.alpha = 0.0
                self.completeLabel.isHidden = false
                self.timeLabel.alpha = 0.0
                self.timeLabel.isHidden = false

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    UIView.animate(withDuration: 1.0, animations: {
                        self.completeLabel.alpha = 1.0
                        self.timeLabel.alpha = 1.0
                    }, completion: { (_) in

                        self.doneButton.alpha = 0.0
                        self.doneButton.isHidden = false
                        self.againButton.alpha = 0.0
                        self.againButton.isHidden = false

                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                            UIView.animate(withDuration: 1.0, animations: {
                                self.doneButton.alpha = 1.0
                                self.againButton.alpha = 1.0
                            }, completion: nil)
                        })
                    })
                })
            })
        }
    }
    
    func timeText(_ time: Int) -> String {
        if time < 60 {
            return "Duration \(time) seconds"
        } else {
            let min = time / 60
            let seconds = time - min * 60
            return "Duration \(min) m \(seconds) s"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func done(_ sender: Any) {
        let vc = MNMineViewController()
        self.navigationController?.setViewControllers([vc], animated: true)
    }

    @IBAction func redo(_ sender: Any) {
        let breathViewController = MNAnimationViewController()
        breathViewController.duration = duration
        self.navigationController?.setViewControllers([breathViewController], animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
