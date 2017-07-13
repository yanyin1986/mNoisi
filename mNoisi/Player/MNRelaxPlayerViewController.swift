//
//  MNRelaxPlayerViewController.swift
//  mNoisi
//
//  Created by Leon.yan on 15/05/2017.
//  Copyright © 2017 Leon.yan. All rights reserved.
//

import UIKit
import AVFoundation
import MBProgressHUD

class MNRelaxPlayerViewController: MNBaseViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, MNTableViewDelegate {

    var showList: Bool = false
    //
    @IBOutlet
    private weak var topView: UIView!

    @IBOutlet
    weak var titleLabel: MNShadowLabel!

    @IBOutlet
    weak var maskView: UIView!

    @IBOutlet
    private weak var playButton: MNShadowButton!
    
    @IBOutlet
    private weak var likeButton: UIButton!

    @IBOutlet
    weak var containerView: UIView!

    @IBOutlet
    private weak var bottomView: UIView!

    @IBOutlet
    private weak var bottomViewBottomConst: NSLayoutConstraint!

    @IBOutlet
    private weak var playerView: UIView!

    @IBOutlet
    private weak var collectionView: UICollectionView!

    lazy var playerListViewController: MNTableViewController = {
        let vc = MNTableViewController()
        vc.delegate = self
        return vc
    }()

    private var _selectedIndex: Int = -1
    private var _currentIndex: Int = -1

    var collapse: Bool = false
    var toggleFullScreenAnimating = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false

        // Do any additional setup after loading the view.
        self.collectionView.register(UINib(nibName: "MNTrackCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "trackCell")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.calculateIndex(self.collectionView)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    // MARK: MNTableViewDelegate
    func playerListViewWillHide() {
        UIView.animate(withDuration: 0.35, animations: { 
            self.playerListViewController.view.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: self.view.frame.height)
        }, completion: { (finish) in
            self.playerListViewController.view.removeFromSuperview()
            self.playerListViewController.removeFromParentViewController()
            self.playerListViewController.didMove(toParentViewController: nil)
            self.containerView.isHidden = true
        })
    }

    func playerListWannaHideBottomView() {
        self.bottomViewBottomConst.constant = -70
        UIView.animate(withDuration: 0.35, delay: 0, options: .curveEaseIn, animations: {
            self.bottomView.alpha = 0.0
            self.view.layoutIfNeeded()
            self.setNeedsStatusBarAppearanceUpdate()
        }, completion: nil)
    }

    func playerListWannaShowBottomView() {
        self.bottomViewBottomConst.constant = 0
        UIView.animate(withDuration: 0.35, delay: 0, options: .curveEaseIn, animations: {
            self.bottomView.alpha = 1.0
            self.view.layoutIfNeeded()
            self.setNeedsStatusBarAppearanceUpdate()
        }, completion: nil)
    }

    @IBAction
    func showPlayerList(_ sender: UIButton) {
        self.addChildViewController(self.playerListViewController)
        self.playerListViewController.willMove(toParentViewController: self)
        self.containerView.isHidden = false
        self.containerView.addSubview(self.playerListViewController.view)
        self.playerListViewController.view.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: self.view.frame.height)
        self.playerListViewController.didMove(toParentViewController: self)
        UIView.animate(withDuration: 0.35, animations: {
            self.playerListViewController.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        }, completion: { (finish) in

        })
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
                self.maskView.alpha = 0.0
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
                self.maskView.alpha = 1.0
                self.view.layoutIfNeeded()
                self.setNeedsStatusBarAppearanceUpdate()
            }, completion: { (finish) in
                self.toggleFullScreenAnimating = false
            })
        }
    }

    @IBAction
    func playButtonPressed(_ sender: UIButton) {
        if !sender.isSelected {
            // paused, wanna play
            self.play()
        } else {
            // is playing, wanna pause
            self.pause()
        }
    }

    @IBAction
    func likeButtonPressed(_ sender: UIButton) {
        guard _currentIndex >= 0 else {
            return
        }
        let track = MNTrackManager.shared.tracks[_currentIndex]

        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            MNTrackManager.shared.like(track: track)
        } else {
            MNTrackManager.shared.unlike(track: track)
        }
    }

    @IBAction
    func breathButtonPressed(_ sender: Any) {
        let vc = MNNavigationController(rootViewController: MNBreathViewController())
        vc.isNavigationBarHidden = true
        self.navigationController?.present(vc, animated: true, completion: nil)
    }

    @IBAction
    func meditationButtonPressed(_ sender: Any) {

    }

    @IBAction
    func mineButtonPressed(_ sender: Any) {
        let vc = MNNavigationController(rootViewController: MNMineViewController())
        vc.isNavigationBarHidden = true
        self.navigationController?.present(vc, animated: true, completion: nil)
    }

    // MARK: collection view
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MNTrackManager.shared.tracks.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "trackCell", for: indexPath) as! MNTrackCollectionViewCell
        let track = MNTrackManager.shared.tracks[indexPath.row]
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
        self.play()
    }

    // MARK: play control
    private func play() {
        guard _currentIndex >= 0 else { return }
        let track = MNTrackManager.shared.tracks[_currentIndex]
        self.titleLabel.text = track.name
        self.playButton.isSelected = true
        MNPlayer.shared.reset(withAudioUrl: track.audioUrl)

        let hudView = MBProgressHUD.showAdded(to: self.view, animated: true)
        hudView.animationType = MBProgressHUDAnimation.zoom
        hudView.mode = MBProgressHUDMode.text
        hudView.label.text = "Play: \(track.name)"
        hudView.removeFromSuperViewOnHide = true
        hudView.hide(animated: true, afterDelay: 2.0)
    }

    private func pause() {
        self.playButton.isSelected = false
        MNPlayer.shared.pause()
    }

    // MARK: page jump
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.maskView.frame = self.view.bounds
        self.maskView.isHidden = false
        self.maskView.alpha = 1.0

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
    @objc func hideBlurView(_ sender: Any) {
        UIView.animate(withDuration: 0.3, animations: {
            self.maskView.alpha = 0.0
        }, completion: { (finished) in
            self.maskView.isHidden = true
            self.maskView.alpha = 1.0
        })
    }
    
    // MARK: status
    private var hideStatusBar: Bool = false

    override var prefersStatusBarHidden: Bool {
        return hideStatusBar
    }

    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return UIStatusBarAnimation.slide
    }
}

