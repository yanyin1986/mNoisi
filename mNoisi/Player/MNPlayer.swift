//
//  MNPlayer.swift
//  mNoisi
//
//  Created by Leon.yan on 08/06/2017.
//  Copyright © 2017 Leon.yan. All rights reserved.
//

import Foundation
import AVFoundation

final class MNPlayer: NSObject {
    public static let shared: MNPlayer = MNPlayer()
    private var _audioUrl: URL?
    private var _audioPlayer: AVAudioPlayer?
    private var _timer: Timer?
    private var _executedStep: Int = -1

    private override init() {
        super.init()
    }

    public func reset(withAudioUrl url: URL) {
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

    private func resetPlayer() {
        guard _audioUrl != nil else {
            return
        }

        if _audioPlayer == nil {
            self.fadeInPlayer()
        } else {
            _timer?.invalidate()
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.fadeInPlayer), object: nil)

            self.fade(audioPlayer: _audioPlayer!, toVolume: 0.0, duration: 1.75, withCompletion: {
                self._audioPlayer?.pause()
                DispatchQueue.main.async {
                    self.perform(#selector(self.fadeInPlayer), with: nil, afterDelay: 0.1)
                }
            })
        }
    }

    @objc
    private func fadeInPlayer() {
        guard let url = _audioUrl else {
            return
        }

        do {
            _audioPlayer = try AVAudioPlayer(contentsOf: url)
            _audioPlayer?.volume = 0.0
            _audioPlayer?.play()
            self.fade(audioPlayer: _audioPlayer!, toVolume: 1.0, duration: 1.25, withCompletion: {

            })
        } catch {
            debugPrint(error)
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
