//
//  MNPlayer.swift
//  mNoisi
//
//  Created by Leon.yan on 08/06/2017.
//  Copyright © 2017 Leon.yan. All rights reserved.
//

import Foundation
import AVFoundation
import MediaPlayer

protocol MNPlayerDelegate: class {

    func volumeDidChanged(_ volume: Float)
}

final class MNPlayer: NSObject {
    public static let shared: MNPlayer = MNPlayer()
    public weak var delegate: MNPlayerDelegate?

    private var _track: MNTrack?
    private var _audioPlayer: AVAudioPlayer?
    private var _timer: Timer?
    private var _executedStep: Int = -1

    private var _volume: Float = 0.0
    var volume: Float {
        get {
            _volume = AVAudioSession.sharedInstance().outputVolume
            return _volume
        }

        set {
            _volume = newValue
            let volumeView = MPVolumeView()
            volumeView.center = CGPoint(x: -1000, y: -1000)
            (volumeView.subviews.filter{NSStringFromClass($0.classForCoder) == "MPVolumeSlider"}.first as? UISlider)?.setValue(_volume, animated: false)
        }
    }

    private override init() {
        super.init()

        AVAudioSession.sharedInstance().addObserver(self, forKeyPath: "outputVolume", options: [NSKeyValueObservingOptions.old, NSKeyValueObservingOptions.new], context: nil)
    }

    deinit {
        AVAudioSession.sharedInstance().removeObserver(self, forKeyPath: "outputVolume")
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let key = keyPath else { return }

        if key == "outputVolume" && AVAudioSession.sharedInstance().isEqual(object) {
            let newVolume = AVAudioSession.sharedInstance().outputVolume
            _volume = newVolume
            delegate?.volumeDidChanged(newVolume)
        }
    }

    public func reset(withTrack track: MNTrack) {
        _track = track
        self.resetPlayer()
    }

    public func play() {
        if _audioPlayer == nil {
            self.fadeInPlayer()
        } else {
            _audioPlayer?.play()
        }
    }

    public func pause() {
        _audioPlayer?.pause()
    }

    // MARK: private methods
    private func resetPlayer() {
        guard _track != nil else {
            return
        }

        if _audioPlayer == nil {
            self.fadeInPlayer()
        } else {
            _timer?.invalidate()
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.fadeInPlayer), object: nil)

            self.fade(audioPlayer: _audioPlayer!, toVolume: 0.0, duration: 0.75, withCompletion: {
                self._audioPlayer?.pause()
                DispatchQueue.main.async {
                    self.perform(#selector(self.fadeInPlayer), with: nil, afterDelay: 0.1)
                }
            })
        }
    }

    @objc
    private func fadeInPlayer() {
        guard let track = _track else {
            return
        }

        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            _audioPlayer = try AVAudioPlayer(contentsOf: track.audioUrl)
            _audioPlayer?.volume = 0.0
            _audioPlayer?.play()
            _audioPlayer?.numberOfLoops = -1

            var info: [String: Any] = [
                MPMediaItemPropertyTitle : track.name,
                MPMediaItemPropertyArtist : "RelaxBreath",
            ]
            
            if let image = UIImage.init(named: track.fullScreen) {
                info[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(image: image)
            }
            
            MPNowPlayingInfoCenter.default().nowPlayingInfo = info
            self.fade(audioPlayer: _audioPlayer!, toVolume: 1.0, duration: 0.75, withCompletion: {
                self._audioPlayer?.numberOfLoops = -1
            })
        } catch {
            debugPrint(error.localizedDescription)
        }
        
    }

    @objc
    private func repeatCheck() {
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

    private func fade(audioPlayer: AVAudioPlayer, toVolume: Float, duration: TimeInterval = 1.0, withCompletion: @escaping ()->Void) {
        let volumn = toVolume - audioPlayer.volume
        let step = Int(duration / 0.05)
        let stepValue = volumn / Float(step)
        _executedStep = 0
        let userInfo: [String : Any] = [
            "step" : step,
            "stepValue" : stepValue,
            "completion" : withCompletion ]
        _timer?.invalidate()
        _timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(repeatCheck), userInfo: userInfo, repeats: true)
    }

}
