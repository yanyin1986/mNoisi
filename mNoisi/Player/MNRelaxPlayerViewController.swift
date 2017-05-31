//
//  MNRelaxPlayerViewController.swift
//  mNoisi
//
//  Created by Leon.yan on 15/05/2017.
//  Copyright © 2017 Leon.yan. All rights reserved.
//

import UIKit
import AVFoundation

extension Notification.Name {
    public static let MNRelaxPlayerViewWillAppear: Notification.Name = Notification.Name.init("dev.mmd.mNoisi.relaxPlayerViewWillAppear")
}

class MNRelaxPlayerViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    //
    @IBOutlet
    private weak var topView: UIView!

    @IBOutlet
    private weak var maskView: UIVisualEffectView!

    @IBOutlet
    private weak var bottomView: UIView!

    @IBOutlet
    private weak var bottomViewBottomConst: NSLayoutConstraint!

    @IBOutlet
    private weak var playerView: UIView!

    @IBOutlet
    private weak var collectionView: UICollectionView!

    private var _selectedIndex: Int = -1
    private var _currentIndex: Int = -1

    private var _audioPlayer: AVAudioPlayer?
    private var _timer: Timer?
    private var _executedStep: Int = -1

    var collapse: Bool = false
    var toggleFullScreenAnimating = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false

        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(hideBlurView(_:)),
            name: Notification.Name.MNRelaxPlayerViewWillAppear,
            object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    @IBAction
    func toggleFullScreen(_ sender: UIButton) {
        guard toggleFullScreenAnimating == false else { return }
        toggleFullScreenAnimating = true

        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            // enter full screen

            self.hideStatusBar = true
            self.bottomViewBottomConst.constant = -70
            UIView.animate(withDuration: 0.5, animations: {
                self.topView.alpha = 0.0
                self.bottomView.alpha = 0.0
                self.playerView.alpha = 0.0
                self.view.layoutIfNeeded()
                self.setNeedsStatusBarAppearanceUpdate()
            }, completion: { (finish) in
                self.toggleFullScreenAnimating = false
            })
        } else {
            // quit full screen

            self.hideStatusBar = false
            self.bottomViewBottomConst.constant = 0
            UIView.animate(withDuration: 0.5, animations: { 
                self.topView.alpha = 1.0
                self.bottomView.alpha = 1.0
                self.playerView.alpha = 1.0
                self.view.layoutIfNeeded()
                self.setNeedsStatusBarAppearanceUpdate()
            }, completion: { (finish) in
                self.toggleFullScreenAnimating = false
            })
        }
    }

    @IBAction
    func playButtonPressed(_ sender: UIButton) {
        
    }

    private func resetPlayer() {
        guard _currentIndex >= 0 else {
            return
        }
        let track = tracks[_currentIndex]

        if #available(iOS 10, *) {
            if _audioPlayer != nil {
//                _audioPlayer?.setVolume(0.0, fadeDuration: 1.0)
                self.fade(audioPlayer: _audioPlayer!, toVolume: 0.0, withCompletion: { 
                    print("complete")
                })
            } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: { 
                do {
                    self._audioPlayer?.pause()
                    self._audioPlayer = try AVAudioPlayer(contentsOf: track.audioUrl)
                    self._audioPlayer?.volume = 0.0
                    self._audioPlayer?.setVolume(1.0, fadeDuration: 1.0)
                    self._audioPlayer!.prepareToPlay()
                    self._audioPlayer!.play()
                } catch {
                    debugPrint(error)
                }
            })
            }
        } else {
            if (track.audioUrl.isFileURL) {
                _audioPlayer?.pause()
                do {
                    _audioPlayer = try AVAudioPlayer(contentsOf: track.audioUrl)
                    _audioPlayer!.prepareToPlay()
                    _audioPlayer!.play()
                } catch {
                    debugPrint(error)
                }
            }
        }
    }

    func fade(audioPlayer: AVAudioPlayer, toVolume: Float, duration: TimeInterval = 1.0, withCompletion: @escaping ()->Void) {
        let volumn = toVolume - audioPlayer.volume
        let step = Int(duration / 0.1)
        let stepValue = volumn / Float(step)
        _executedStep = 0
        let userInfo: [String : Any] = [
            "step" : step,
            "stepValue" : stepValue,
            "completion" : withCompletion ]
        _timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(repeatCheck), userInfo: userInfo, repeats: true)
    }

    func repeatCheck() {
        guard let timer = self._timer else { return }
        guard let userInfo = timer.userInfo as? [String : Any] else { return }
        guard let audioPlayer = _audioPlayer else { return }

        let step = userInfo["step"] as! Int
        let stepValue = userInfo["stepValue"] as! Float

        audioPlayer.volume += stepValue
        _executedStep += 1
        if _executedStep >= step {
            _timer?.invalidate()
            let completion = userInfo["completion"] as! ()->Void
            completion()
        }

    }

    // MARK: collection view

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tracks.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "trackCell", for: indexPath) as! MNTrackCollectionViewCell
        let track = tracks[indexPath.row]
        cell.imageView.image = UIImage(named: track.fullScreen)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        print(self.view.frame.size)
        return self.view.frame.size
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.calculateIndex(scrollView)
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            self.calculateIndex(scrollView)
        }
    }

    private func calculateIndex(_ scrollView: UIScrollView) {
        let x = scrollView.contentOffset.x
        let index = Int(x / scrollView.frame.width)
        print(index)

        guard _currentIndex != index, index >= 0 else {
            return
        }

        _currentIndex = index
        self.resetPlayer()
    }

    // MARK: page jump
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.maskView.isHidden = false
        //self.maskView.alpha = 0.0
        if let identifier: String = segue.identifier {
            switch identifier {
            default:
                break
            }
        }
        super.prepare(for: segue, sender: sender)
    }

    // MARK: MNMineViewControllerDelegate
    func hideBlurView(_ sender: Any) {
        UIView.animate(withDuration: 0.3, animations: {
            self.maskView.alpha = 0.0
        }, completion: { (finished) in
            self.maskView.isHidden = true
            self.maskView.alpha = 1.0
        })
    }
    
    // MARK: status
    private var hideStatusBar: Bool = false

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override var prefersStatusBarHidden: Bool {
        return hideStatusBar
    }

    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return UIStatusBarAnimation.slide
    }
}

