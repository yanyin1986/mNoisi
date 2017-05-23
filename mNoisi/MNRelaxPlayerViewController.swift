//
//  MNRelaxPlayerViewController.swift
//  mNoisi
//
//  Created by Leon.yan on 15/05/2017.
//  Copyright © 2017 Leon.yan. All rights reserved.
//

import UIKit

class MNRelaxPlayerViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, MNMineViewControllerDelegate {

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

    let images: [String] = [
        "2817564516891261945",
        "Spring Walk.jpeg",
        "Ocean Wave.jpeg",
        "3.jpg",
        "4.jpg",
    ]

    var collapse: Bool = false
    var toggleFullScreenAnimating = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        
        // Do any additional setup after loading the view.
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


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "trackCell", for: indexPath) as! MNTrackCollectionViewCell
        cell.imageView.image = UIImage(named: self.images[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        print(self.view.frame.size)
        return self.view.frame.size
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.maskView.isHidden = false
        //self.maskView.alpha = 0.0
        if let identifier: String = segue.identifier {
            switch identifier {
            case "showMine":
                let vc = segue.destination as! MNMineViewController
                vc.delegate = self
            default:
                break
            }
        }
        super.prepare(for: segue, sender: sender)
    }

    // MARK: MNMineViewControllerDelegate
    func mineViewControllerWillDismiss() {
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
        return UIStatusBarAnimation.fade
    }
}

