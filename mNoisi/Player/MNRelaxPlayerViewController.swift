//
//  MNRelaxPlayerViewController.swift
//  mNoisi
//
//  Created by Leon.yan on 15/05/2017.
//  Copyright © 2017 Leon.yan. All rights reserved.
//

import UIKit
import AVFoundation

class MNRelaxPlayerViewController: MNBaseViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, MNTableViewDelegate, MNPlayerDelegate {

    var tracks = [MNTrack]()

    var showList: Bool = false
    //
    @IBOutlet
    private weak var topView: UIView!

    @IBOutlet
    private weak var titleLabel: MNShadowLabel!

    @IBOutlet
    private weak var maskView: UIView!

    @IBOutlet
    private weak var fullScreenButton: MNShadowButton!

    @IBOutlet
    private weak var playButton: MNShadowButton!
    
    @IBOutlet
    private weak var likeButton: UIButton!

    @IBOutlet
    private weak var containerView: UIView!

    @IBOutlet
    private weak var bottomView: UIView!

    @IBOutlet
    private weak var bottomViewBottomConst: NSLayoutConstraint!

    @IBOutlet
    private weak var volumeSlider: UISlider!

    @IBOutlet
    private weak var playerView: UIView!

    @IBOutlet
    private weak var collectionView: UICollectionView!

    private lazy var playerListViewController: MNTableViewController = {
        let vc = MNTableViewController()
        vc.delegate = self
        return vc
    }()

    private var _selectedIndex: Int = -1
    private var _currentIndex: Int = -1

    var collapse: Bool = false
    var toggleFullScreenAnimating = false

    lazy var hudView: MBProgressHUD = {
        let hudView = MBProgressHUD.showAdded(to: self.view, animated: true)
        hudView.animationType = MBProgressHUDAnimation.zoom
        hudView.mode = MBProgressHUDMode.text
        hudView.removeFromSuperViewOnHide = true

        hudView.isUserInteractionEnabled = false
        return hudView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false

        // Do any additional setup after loading the view.
        volumeSlider.value = MNPlayer.shared.volume
        MNPlayer.shared.delegate = self
        self.collectionView.register(MNTrackCollectionViewCell.self,
                                     forCellWithReuseIdentifier: "trackCell")
        tracks.append(contentsOf: MNTrackManager.shared.tracks)
        tracks.insert(MNTrackManager.shared.tracks.last!, at: 0)
        tracks.append(MNTrackManager.shared.tracks.first!)
        collectionView.alpha = 0.0
        self.hideStatusBar = true
        self.bottomViewBottomConst.constant = -70
        self.view.layoutIfNeeded()
        self.setNeedsStatusBarAppearanceUpdate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        debugPrint("--- \(self.view.frame)")
        volumeSlider.value = MNPlayer.shared.volume
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        guard _currentIndex < 0 else { return }
        if let musicId = Defaults[.lastPlayedMusicId],
            let index = MNTrackManager.shared.tracks.index(where: { $0.id == musicId }) {
            /// do have
            let track = MNTrackManager.shared.tracks[index]
            self.select(track: track)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                self.play()
            })
        } else {
            /// play first track
            self.select(track: MNTrackManager.shared.tracks.first!)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                self.play()
            })
        }
        self.hideStatusBar = false
        self.bottomViewBottomConst.constant = 0
        UIView.animate(withDuration: 0.75, delay: 0.1, options: .curveEaseOut, animations: {
            self.collectionView.alpha = 1.0
            self.topView.alpha = 1.0
            self.bottomView.alpha = 1.0
            self.playerView.alpha = 1.0
            self.maskView.alpha = 1.0
            self.view.layoutIfNeeded()
            self.setNeedsStatusBarAppearanceUpdate()
        }, completion: nil)
    }

    // MARK: MNPlayerDelegate
    func volumeDidChanged(_ volume: Float) {
        volumeSlider.value = volume
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

    func playerListDidSelectTrack(_ track: MNTrack) {
        self.select(track: track)
        self.play()
    }

    private func select(track: MNTrack, animated: Bool = false) {
        guard let index = self.tracks.index(where: { $0 == track }) else { return }
        _currentIndex = index
        let size = self.view.frame.size
        let offset = CGPoint(x: size.width * CGFloat(index), y: 0)
        self.collectionView.setContentOffset(offset, animated: animated)
    }

    
    // MARK: Actions
    @IBAction
    func showPlayerList(_ sender: UIButton) {
        self.addChildViewController(self.playerListViewController)
        self.playerListViewController.willMove(toParentViewController: self)
        self.playerListViewController.playingTrack = self.tracks[_currentIndex]
        self.containerView.isHidden = false
        self.containerView.addSubview(self.playerListViewController.view)
        self.playerListViewController.view.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: self.view.frame.height)
        self.playerListViewController.didMove(toParentViewController: self)
        self.playerListViewController.collectionView.reloadData()
        UIView.animate(withDuration: 0.35, animations: {
            self.playerListViewController.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        }, completion: { (finish) in

        })
    }

    @IBAction func previous(_ sender: Any) {
        let index = _currentIndex == 0 ? self.tracks.count - 2 : _currentIndex - 1
        self.collectionView.scrollToItem(at: IndexPath(row: index, section: 0),
                                         at: .centeredHorizontally,
                                         animated: true)
        _currentIndex = index
        self.play()
    }

    @IBAction func next(_ sender: Any) {
        let index = _currentIndex + 1 >= self.tracks.count ? 1 : _currentIndex + 1
        self.collectionView.scrollToItem(at: IndexPath.init(row: index, section: 0), at: .centeredHorizontally, animated: true)
        _currentIndex = index
        self.play()
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
                self.fullScreenButton.alpha = 0.65
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
                self.fullScreenButton.alpha = 1.0
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
        let track = self.tracks[_currentIndex]// MNTrackManager.shared.tracks[_currentIndex]
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
        let vc = MNNavigationController(rootViewController: MNMeditationViewController())
        vc.isNavigationBarHidden = true
        self.navigationController?.present(vc, animated: true, completion: nil)
    }

    @IBAction
    func mineButtonPressed(_ sender: Any) {
        let vc = MNNavigationController(rootViewController: MNMineViewController())
        vc.isNavigationBarHidden = true
        self.navigationController?.present(vc, animated: true, completion: nil)
    }

    @IBAction func volumeChanged(_ sender: UISlider) {
        MNPlayer.shared.volume = sender.value
    }

    // MARK: collection view
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.tracks.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "trackCell", for: indexPath) as! MNTrackCollectionViewCell
        let track = self.tracks[indexPath.row]
        //MNTrackManager.shared.tracks[indexPath.row]
        cell.imageView.image = UIImage(named: track.fullScreen)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return UIScreen.main.bounds.size
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.jump(withContentOffset: scrollView.contentOffset)
    }

    func jump(withContentOffset offset: CGPoint) {
        if offset.x <= 0 {
            self.jumpToLast()
        }
        if offset.x >= CGFloat(self.tracks.count - 1) * collectionView.frame.width {
            self.jumpToFirst()
        }
    }

    func jumpToLast() {
        let indexPath = IndexPath(row: self.tracks.count - 2, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
    }

    func jumpToFirst() {
        let indexPath = IndexPath(row: 1, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
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
        let track = self.tracks[_currentIndex]
        self.titleLabel.text = track.name
        self.likeButton.isSelected = MNTrackManager.shared.isTrackLiked(track)
        self.playButton.isSelected = true
        MNPlayer.shared.reset(withTrack: track)

        self.hudView.label.text = "Playing: \(track.name)"
        if self.hudView.superview == nil {
            self.view.addSubview(self.hudView)
        }
        self.hudView.show(animated: true)
        self.hudView.hide(animated: true, afterDelay: 2.0)

        ///
        Defaults[.lastPlayedMusicId] = track.id
        Defaults.sync()
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

